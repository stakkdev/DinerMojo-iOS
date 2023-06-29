//
//  DMUserRequest.m
//  DinerMojo
//
//  Created by hedgehog lab on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMUserRequest.h"
#import "DMMappingHelper.h"
#import "SubscriptionsObject.h"
#import "DinerMojo-Swift.h"
#import <UserNotifications/UserNotifications.h>
@implementation DMUserRequest

#pragma mark - Public methods


- (void)saveFavoriteIds:(NSArray*)ids {
    NSMutableString *stringFavoriteIds = [[NSMutableString alloc] initWithString:@""];
    NSInteger index = 0;
    for(NSString* id in ids) {
        NSString* stringId = [NSString stringWithFormat:@"%@",id];
        if (index == 0) {
            [stringFavoriteIds appendString:stringId];
        } else {
            [stringFavoriteIds appendString:@","];
            [stringFavoriteIds appendString:stringId];
        }
        index += 1;
    }
    [[NSUserDefaults standardUserDefaults] setValue:stringFavoriteIds forKey:@"favourite_ids"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)addFavouriteVenueId:(NSString *)addId {
    NSString *stringFavoriteIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"favourite_ids"];
    NSArray *all_ids = [stringFavoriteIds componentsSeparatedByString:@","];
    NSMutableArray *new_Ids = [NSMutableArray new];
    for(NSString *eachId in all_ids) {
        [new_Ids addObject:eachId];
    }
    [new_Ids addObject:addId];
    [self saveFavoriteIds:new_Ids];
}

- (void)removeFavouriteVenueId:(NSString*)removeId {
    NSString *stringFavoriteIds = [[NSUserDefaults standardUserDefaults] objectForKey:@"favourite_ids"];
    NSArray *all_ids = [stringFavoriteIds componentsSeparatedByString:@","];
    NSMutableArray *new_Ids = [NSMutableArray new];
    for(NSString *eachId in all_ids) {
        if (![eachId isEqual:removeId]) {
            [new_Ids addObject:eachId];
        }
    }
    [self saveFavoriteIds:new_Ids];
}

- (void)downloadFavouriteVenuesWithCompletionBlock:(RequestCompletion)completionBlock
{
    [self GET:@"user/me/favourite_venues" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            DMUser *mappedUser = [DMMappingHelper mapUser:results mapping:[[self mappingProvider] userFavouriteVenuesMapping] inContext:[self objectContext]];
            DMVenueRequest *venueRequest = [DMVenueRequest new];
            [venueRequest GET:@"venues" withParams:nil withCompletionBlock:^(NSError *error, id results) {
                if (error) {
                    completionBlock(error, nil);
                } else {
                    NSMutableArray *all_ids = [[NSMutableArray alloc] init];
                    for(NSDictionary* dict in results) {
                        [all_ids addObject:dict[@"id"]];
                    }
                    NSMutableArray *favs = [[NSMutableArray alloc] init];
                    NSMutableArray *favsIds = [[NSMutableArray alloc] init];
                    for(DMVenue *venue in [[mappedUser favourite_venues] allObjects]) {
                        if([all_ids containsObject:venue.primitiveModelID]) {
                            [favs addObject:venue];
                            [favsIds addObject:[venue modelID]];
                        }
                    }
                    [self saveFavoriteIds:favsIds];
                    
                    completionBlock(nil, favs);
                }
            }];
        }
    }];
}

- (void)recommendedVenue:(DMVenue *)venue withComplectionBlock:(RequestCompletion)complectionBlock
{
    NSDictionary *venueDict = @{@"current_venue": venue.modelID};

    
    [self GET:@"user/me/get_recommended_venues" withParams:venueDict withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            complectionBlock(error,nil);
        }
        
        else
        {
            complectionBlock(nil, results);
        }
    }];
}

- (void)addVenue:(DMVenue *)venue withCompletionBlock:(RequestCompletion)completionBlock
{
    
    NSDictionary *venueDict = @{@"venue_id": venue.modelID};
    NSString *strValue = [NSString stringWithFormat:@"%@",[venue modelID]];
    [self addFavouriteVenueId:strValue];
    
    [self POST:@"user/me/add_venue_to_favourites" withParams:venueDict withCompletionBlock:^(NSError *error, id results) {
        
        if (error == nil)
        {
            DMVenue *addedVenue = [DMMappingHelper mapVenue:results withMapping:[[self mappingProvider] venueMappingWithoutNews] inContext:[self objectContext]];
            
            DMUser *currentUser = [self currentUser];
          
            completionBlock(nil, [[currentUser favourite_venues] allObjects]);
       
            [currentUser addFavourite_venuesObject:addedVenue];
            
            [self saveInContext:[self objectContext]];        }
        else
        {
            NSString *strValue = [NSString stringWithFormat:@"%@", venue.modelID];
            [self removeFavouriteVenueId:strValue];
            completionBlock(error, nil);
        }
    }];
}



- (void)toggleVenue:(DMVenue *)venue to:(BOOL)favourite withCompletionBlock:(RequestCompletion)completionBlock {
    if (favourite) {
        [self addVenue:venue withCompletionBlock:completionBlock];
    } else {
        [self unfavouriteVenue:venue withCompletionBlock:completionBlock];
    }
}

- (void)unfavouriteVenue:(DMVenue *)venue withCompletionBlock:(RequestCompletion)completionBlock
{
    NSMutableArray *venue_ids = [NSMutableArray new];
    [venue_ids addObject:venue.modelID];
                                 
    [self deleteVenues:venue_ids withCompletionBlock:completionBlock];

}


- (void)deleteVenues:(NSArray *)venues withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *venueDict = [NSDictionary dictionaryWithObject:venues forKey:@"venue_ids"];
    
    for (id removedId in venues) {
        NSString *strValue = [NSString stringWithFormat:@"%@",removedId];
        [self removeFavouriteVenueId:strValue];
    }
    
    [self POST:@"user/me/remove_venues_from_favourites" withParams:venueDict withCompletionBlock:^(NSError *error, id results) {
        if (error == nil)
        {
            DMUser *currentUser = [self currentUser];
            
            NSArray *deletedVenues = [DMMappingHelper mapVenues:results withMapping:[[self mappingProvider] venueMappingWithoutNews] inContext:[self objectContext]];
            
            for (DMVenue *venue in deletedVenues)
            {
                [currentUser removeFavourite_venuesObject:venue];
               
            }
            
       
            
            [self saveInContext:[self objectContext]];
            
            completionBlock(nil, [[currentUser favourite_venues] allObjects]);
        }
        else
        {
            for (id removedId in venues) {
                NSString *strValue = [NSString stringWithFormat:@"%@",removedId];
                [self addFavouriteVenueId:strValue];
            }
            
            completionBlock(error, nil);
        }
    }];
}

- (BOOL)isUserLoggedIn;
{
    return ([DMRequest currentUserToken] != nil && [self currentUser] != nil);
}

#pragma mark - Account login methods

- (void)loginFaceboookWithSuccess:(DMFacebookServiceRequestTokenHandlerSuccess)success
                            error:(DMFacebookServiceRequestTokenHandlerFailure)failure
               missingPermissions:(DMFacebookServiceRequestTokenHandlerMissingPermissions)permissionsAreMissing
                           cancel:(DMFacebookServiceRequestTokenHandlerCancel)cancel
               fromViewController:(UIViewController *)viewController;
{
    __weak typeof(self) weakSelf = self;
    [[DMFacebookService sharedInstance] loginWithSuccess:^(id result) {
        
        [weakSelf loginWithToDinerMojoFacebook:[result objectForKey:@"id"] token:[[FBSDKAccessToken currentAccessToken] tokenString] completionBlock:^(NSError *error, id results) {
            if (error != nil)
            {
                // Pass through the Facebook result so that data derived from Facebook can be used to register if approppriate error code.
                failure(error, result);
            }
            else
            {
                success([self userFromLoginResults:results]);
            }
        }];
        
    } error:^(NSError *error, id additionalInfo) {
        failure(error, nil);
    } missingPermissions:^(NSSet *missingPermissions) {
        permissionsAreMissing(missingPermissions);
    } cancel:^{
        cancel();
    } fromViewController:viewController];
}

- (void)signUpWithFacebook:(NSDictionary *)data WithCompletionBlock:(RequestCompletion)completionBlock;
{
    UIImage *profileImage = data[@"profile_picture"];
    
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    [self POST:@"user/signup" withParams:data withBody:(profileImage != nil) ? ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(profileImage, 0.75) name:@"profile_picture" fileName:[NSString stringWithFormat:@"%@.jpg",uuidString] mimeType:@"image/jpg"];
    } : nil withCompletionBlock:^(NSError *error, id results) {
        if (error)
        {
            completionBlock(error, nil);
        }
        else
        {
            [self userFromLoginResults:results];
            completionBlock(nil,[self userFromReferralResults:results]);
        }
    }];
}

- (void)loginWithEmail:(NSString *)email password:(NSString *)password WithCompletionBlock:(RequestCompletion)completionBlock;
{
    NSDictionary *params = @{ @"email_address" : email, @"password" : password};
    
    //NSDictionary *dictionaryHeader = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Token %@",[DMRequest currentUserToken]],@"Authorization", nil];

    
    [self POST:@"user/login_with_email" withParams:params withCompletionBlock:^(NSError *error, id results) {
        if (error)
        {
            completionBlock(error, nil);
        }
        else
        {
            completionBlock(error, [self userFromLoginResults:results]);
        }
    }];
}

- (void)signUpWithEmailData:(NSDictionary *)data WithCompletionBlock:(RequestCompletion)completionBlock;
{
    UIImage *profileImage = data[@"profile_picture"];
    
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    [self POST:@"user/signup_with_email" withParams:data withBody:(profileImage != nil) ? ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(profileImage, 0.75) name:@"profile_picture" fileName:[NSString stringWithFormat:@"%@.jpg",uuidString] mimeType:@"image/jpg"];
    } : nil withCompletionBlock:^(NSError *error, id results) {
        if (error)
        {
            completionBlock(error, nil);
        }
        else
        {
            [self userFromLoginResults:results];
            completionBlock(nil,[self userFromReferralResults:results]);
        }
    }];
}

- (void)updateProfileEmailVerifificationDisplayed:(BOOL)displayed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:displayed forKey:@"profileEmailVerifificationDisplayed"];
    [defaults synchronize];
}

- (BOOL)hasUpdateProfileEmailVerifificationDisplayed
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"profileEmailVerifificationDisplayed"];
}

- (void)skipUser
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:YES forKey:@"userSkipped"];
    [defaults synchronize];
}

- (BOOL)hasUserSkipped
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults boolForKey:@"userSkipped"];
}

- (void)logout
{
    [[DMUserRequest new] updateProfileEmailVerifificationDisplayed:NO];
    
    [[NSUserDefaults standardUserDefaults] setObject:self.currentUser.email_address forKey:@"lastEmail"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    [DMUserRequest updateCurrentUserToken:nil];
    [[DMFacebookService sharedInstance] logOut];
    [self unregisterUserDeviceforPushNotifications];
    [[self currentUser] setLocal_accountValue:NO];
    [[self objectContext] MR_saveToPersistentStoreAndWait];
    
    [DMUser MR_truncateAll];
    [DMTransaction MR_truncateAll];
}

- (void)sendGDPR:(BOOL)accepted completion:(RequestCompletion)completionBlock {
    NSDictionary *params = @{ @"accept" : [[NSNumber numberWithBool:accepted] stringValue] };
    [self POST:@"user/gdpr_tracking" withParams:params withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, nil);
        }
    }];
}

- (void)downloadUserProfileWithCompletionBlock:(RequestCompletion)completionBlock;
{
    [self GET:@"user/me/user_check" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            NSLog(@"user/me/user_check downloadUserProfileWithCompletionBlock::: %@", results);
            NSMutableDictionary * userDict = (NSMutableDictionary *) results;
            NSLog(@"user dict is: %@", userDict);
            if (userDict != nil) {
                if ((![[userDict objectForKey:@"latitude"] isEqual:[NSNull null]]) && ([[userDict objectForKey:@"latitude"] integerValue]) != 0 && ([userDict objectForKey:@"latitude"]) && ([userDict objectForKey:@"longitude"]) != nil && ([userDict objectForKey:@"longitude"]) != NULL) {
                    NSLog(@"User location exist");
                    [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"LocationExist"];
                } else {
                    NSLog(@"*** User location not exist ****");
                    [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"LocationExist"];
                }
            }
            completionBlock(nil, [DMMappingHelper mapUser:results mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]]);
        }
    }];
}

- (void)downloadUserProfileResponseWithCompletionBlock:(UserProfileRequestCompletion)completionBlock;
{
    [self GET:@"user/me/user_check" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil, nil);
        } else {
            NSLog(@"user/me/user_check downloadUserProfileResponseWithCompletionBlock:::: %@ ", results);
            completionBlock(nil, [DMMappingHelper mapUser:results mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]], results);
        }
    }];
}

- (void)downloadSubscriptionsWithCompletionBlock:(RequestCompletion)completionBlock;
{
    NSDictionary *params = @{ @"token": [DMRequest currentUserToken] };
    
    [self GET:@"subscriptions" withParams:params withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, [SubscriptionsObject createObjectFromDictionary:results]);
        }
    }];
}

 //(void)uploadSubscriptions:(NSArray *)ids {
- (void)uploadSubscriptions:(NSArray *)ids withDinerSub:(BOOL)dinerSub {
    NSDictionary *params = @{ @"token" : [DMRequest currentUserToken],
                              @"venues" : ids,
                              @"dinermojo_sub" : ((dinerSub == YES) ? @YES : @NO)};
    
    [self POST:@"subscriptions" withParams:params withCompletionBlock:^(NSError *error, id results) {
        if(error == NULL) {
            NSLog(@"it's ok");
        }
    }];
}

- (void)uploadUserProfileWith:(NSDictionary *)data profileImage:(UIImage *)image completionBlock:(RequestCompletion)completionBlock;
{
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    [self POST:@"user/me/user_check" withParams:data  withBody:(image != nil) ? ^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(image, 0.75) name:@"profile_picture" fileName:[NSString stringWithFormat:@"%@.jpg",uuidString] mimeType:@"image/jpg"];
    } : nil withCompletionBlock:completionBlock];
}

- (void)deleteUserWithCompletionBlock:(RequestCompletion)completionBlock
{
    [self POST:@"user/me/delete_user" withParams:nil withCompletionBlock:completionBlock];

}

- (void)resetPasswordWithEmailAddress:(NSString *)emailAddress withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"email_address": emailAddress };
    
    [self POST:@"user/request_password_change" withParams:params withCompletionBlock:completionBlock];
}

- (void)referUserWithEmailAddress:(NSString *)emailAddress withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"email_address": emailAddress };
    
    [self POST:@"user/me/refer" withParams:params withCompletionBlock:completionBlock];
}

- (void)downloadReferralCodeForEmailAddress:(NSString *)emailAddress withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"email_address": emailAddress };
    
    [self GET:@"user/check_code_for_email" withParams:params withCompletionBlock:completionBlock];
}

- (void)validateCode:(NSString *)code withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"code": code };
    
    [self GET:@"user/validate_code" withParams:params withCompletionBlock:completionBlock];
}

- (void)loginWithToDinerMojoFacebook:(NSString *)facebookID token:(NSString *)token completionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"facebook_id": facebookID, @"facebook_token" : token};
    
    [self POST:@"user/login" withParams:params withCompletionBlock:completionBlock];
}

- (void)facebookEmailUpdate:(NSString *)email completionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"email_address": email};
    [self POST:@"user/facebook_email" withParams:params
    withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, results);
        }
    }];
}

- (void)likeDislikeEarnNotification:(NSNumber *)notificationID to:(NSNumber *)isLike completionBlock:(RequestCompletion)completionBlock {
    NSDictionary *params = @{ @"liked": isLike};
    NSString *url = [NSString stringWithFormat:@"news_feedback/%@", notificationID];
    [self POST:url withParams:params withCompletionBlock:^(NSError *error, id results) {
        if(error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, results);
        }
    }];
}


- (void)facebookEmailVerification:(NSString *)userId otp:(NSString *)otp password:(NSString *)password completionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"user_id": userId, @"otp": otp, @"password": password};
    [self POST:@"user/facebook_email_verification" withParams:params
    withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, results);
        }
    }];
}

#pragma mark - Other user related methods

-(void)registerForNotifications {
     UIApplication *application = [UIApplication sharedApplication];
//
//    UIUserNotificationSettings *settings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert | UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
//
//        [application registerUserNotificationSettings:settings];
//        [application registerForRemoteNotifications];
    
    [UNUserNotificationCenter currentNotificationCenter].delegate = self;
      UNAuthorizationOptions authOptions = UNAuthorizationOptionAlert |
          UNAuthorizationOptionSound | UNAuthorizationOptionBadge;
      [[UNUserNotificationCenter currentNotificationCenter]
          requestAuthorizationWithOptions:authOptions
          completionHandler:^(BOOL granted, NSError * _Nullable error) {
            // ...
          }];
    
    
    [application registerForRemoteNotifications];
    
}

-(void)setDeviceToken:(NSString *)deviceToken
{
    [[NSUserDefaults standardUserDefaults] setObject:deviceToken forKey:@"deviceToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self registerUserDeviceForPushNotifications];
}

-(NSString *)currentUserDeviceToken;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"deviceToken"];
}

-(void)registerUserDeviceForPushNotifications;
{
if ([DMRequest currentUserToken] != nil)
{
        NSString* deviceTokenString = [NSString stringWithFormat:@"%@",[self currentUserDeviceToken]];
        NSMutableDictionary *dictionary = [NSMutableDictionary dictionaryWithObjectsAndKeys:deviceTokenString,@"token",@"fcm",@"type",[NSNumber numberWithInt:0], @"plateform_type", nil];
        [self registerUserWithDeviceToken:dictionary withCompletion:^(NSError *error, id results) {
            
        }];
    }
}

-(void)unregisterUserDeviceforPushNotifications
{
    NSString* deviceTokenString = [NSString stringWithFormat:@"%@",[self currentUserDeviceToken]];
                                  
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:deviceTokenString,@"token",@"fcm",@"type", nil];
    
    [self unRegisterUserWithDeviceToken:dictionary withCompletion:^(NSError *error, id results) {
        
    }];

}

-(void)registerUserWithDeviceToken:(NSDictionary *)params withCompletion:(RequestCompletion)completionBlock;
{
    
    NSDictionary *dictionaryHeader = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Token %@",[DMRequest currentUserToken]],@"Authorization", nil];
    
    [self POSTWithHeader:@"user/me/registerdevice" withParams:params headers:dictionaryHeader withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, nil);
        }
    }];
    
//    [self POST:@"user/me/registerdevice" withParams:params withCompletionBlock:^(NSError *error, id results) {
//        if (error) {
//            completionBlock(error, nil);
//        } else {
//            completionBlock(nil, nil);
//        }
//    }];
}

-(void)unRegisterUserWithDeviceToken:(NSDictionary *)params withCompletion:(RequestCompletion)completionBlock;
{
    [self POST:@"user/me/unregisterdevice" withParams:params withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, nil);
        }
    }];
}

- (DMUser *)userFromLoginResults:(id)results
{
    [DMRequest updateCurrentUserToken:[results objectForKey:@"token"]];
    NSDictionary * userDict = [results objectForKey:@"user"];
    /*
    NSInteger lattitude = [[userDict objectForKey:@"latitude"] integerValue];
    NSLog(@"Latitude is:", lattitude);
    if (lattitude == 0) {
        NSLog(@"Latitude is zero");
    }*/
    NSLog(@"User dict is: %@", userDict);
    if ((![[userDict objectForKey:@"latitude"] isEqual:[NSNull null]]) && ([[userDict objectForKey:@"latitude"] integerValue]) != 0 && ([userDict objectForKey:@"latitude"]) && ([userDict objectForKey:@"longitude"]) != nil && ([userDict objectForKey:@"longitude"]) != NULL) {
        NSLog(@"User location exist");
        [NSUserDefaults.standardUserDefaults setBool:YES forKey:@"LocationExist"];
    } else {
        NSLog(@"*** User location not exist ****");
        [NSUserDefaults.standardUserDefaults setBool:NO forKey:@"LocationExist"];
    }
    DMUser *user = [DMMappingHelper mapUser:userDict mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]];
    [user setLocal_accountValue:YES];
    [self registerForNotifications];
    [self registerUserDeviceForPushNotifications];
    [[self objectContext] MR_saveToPersistentStoreAndWait];
    return user;
}

- (DMUser *)userFromReferralResults:(id)results
{
    DMUser *referralUser;
    
    if ([results objectForKey:@"referrer"])
    {
        referralUser = [DMMappingHelper mapUser:[results objectForKey:@"referrer"] mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]];
        [[self objectContext] MR_saveToPersistentStoreAndWait];
        return referralUser;
    }
    
    else
    {
        referralUser = nil;

    }
    
    return referralUser;
}

- (DMUser *)currentUser
{
    return [DMUser MR_findFirstByAttribute:@"local_account" withValue:@YES];
}

#pragma mark - Tranasctions

-(void)downloadAllTransactionsWithCompletionBlock:(RequestCompletion)completionBlock
{
    __weak typeof(self) weakSelf = self;
    [self GET:@"user/me/transactions" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, [weakSelf parseAllTransactionsFromDictionaryArray:results inContext:[self objectContext]]);
        }
    }];
}

- (void)downloadAllAvailableOffersWithVenueID:(NSNumber *)venueID withCompletionBlock:(RequestCompletion)completionBlock

{
    [self GET:@"user/me/available_offers" withParams:@{@"venue_id":venueID} withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            
            NSArray *offers = [DMMappingHelper mapOfferItems:results withMapping:[[self mappingProvider] offerMapping] inContext:[self objectContext]];
            completionBlock(nil, offers);
        }
    }];

}

- (NSArray *)parseAllTransactionsFromDictionaryArray:(NSArray *)results inContext:(NSManagedObjectContext *)context
{
    NSMutableArray *returnArray = [NSMutableArray array];
    
    for (NSDictionary *dictionary in results)
    {
        DMTransactionType type = [[dictionary objectForKey:@"transaction_type"] integerValue];
        
        if (type == DMTransactionTypeEarn)
        {
            [returnArray addObject:[DMMappingHelper mapEarn:dictionary mapping:[[self mappingProvider] earnMapping] inContext:context]];
        }
        else
        {
            [returnArray addObject:[DMMappingHelper mapRedeem:dictionary mapping:[[self mappingProvider] redeemMapping] inContext:context]];
        }
    }
    return returnArray;
}

- (void)postEarnTransactionWithBillImage:(UIImage *)billImage venueID:(NSNumber *)venueID transactionID:(NSNumber *)transactionID withCompletionBlock:(RequestCompletion)completionBlock
{
    NSString *uuidString = [[NSUUID UUID] UUIDString];
    
    [self POST:@"user/me/post_earn_transaction" withParams:@{@"venue_id":venueID, @"transaction_id":transactionID} withBody:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:UIImageJPEGRepresentation(billImage, 0.75) name:@"bill_image" fileName:[NSString stringWithFormat:@"%@.jpg",uuidString] mimeType:@"image/jpg"];
    } withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            DMUser *user = [DMMappingHelper mapUser:results mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]];
            completionBlock(nil, user);
        }
    }];
}

- (void)postRedeemTransactionWithOfferID:(NSNumber *)offerID venueID:(NSNumber *)venueID withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"venue_id" : venueID, @"offer_id" : offerID};

    
    [self POST:@"user/me/post_redeem_transaction" withParams:params
    withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
//            DMUser *user = [DMMappingHelper mapUser:results mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]];
            completionBlock(nil, results);
        }
    }];
}

- (void)postFeedbackWithText:(NSString *)comments rating:(NSNumber *)rating venueID:(NSNumber *)venueID withCompletionBlock:(RequestCompletion)completionBlock
{
    NSDictionary *params = @{ @"comments" : comments, @"rating" : rating, @"venue_id" : venueID};
    
    
    [self POST:@"user/me/post_feedback" withParams:params
withCompletionBlock:^(NSError *error, id results) {
    if (error) {
        completionBlock(error, nil);
    } else {
        completionBlock(results, nil);
    }
}];
}

#pragma mark Settings

- (void)postNotificationWithFrequency:(NSNumber *)frequency withCompletionBlock:(RequestCompletion)completionBlock
{
    [self POST:@"user/me/update_notification_frequency" withParams:@{ @"filter" : frequency}
withCompletionBlock:^(NSError *error, id results) {
    if (error) {
        completionBlock(error, nil);
    } else {
        completionBlock(results, nil);
    }
}];
}


- (void)postUpdateUserWithDictionaryParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock
{
    [self POST:@"user/me/update_notification_frequency" withParams:params
withCompletionBlock:^(NSError *error, id results) {
    if (error) {
        completionBlock(error, nil);
    } else {
        completionBlock(results, nil);
    }
}];
}

- (void)requestEmailVerificationEmailWithCompletionBlock:(RequestCompletion)completionBlock
{
    [self GET:@"user/me/request_email_verification" withParams:nil withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(nil, [DMMappingHelper mapUser:results mapping:[[self mappingProvider] completeUserMapping] inContext:[self objectContext]]);
        }
    }];
}


- (void)postSubscriptionsData:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock
{
    [self POST:@"subscriptions" withParams:params
            withCompletionBlock:^(NSError *error, id results) {
        if (error) {
            completionBlock(error, nil);
        } else {
            completionBlock(results, nil);
        }
    }];
}

@end
