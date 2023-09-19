//
//  DMUserRequest.h
//  DinerMojo
//
//  Created by hedgehog lab on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRequest.h"
#import "DMFacebookService.h"
#import "DMUser.h"

@interface DMUserRequest : DMRequest

- (BOOL)isUserLoggedIn;
- (void)loginFaceboookWithSuccess:(DMFacebookServiceRequestTokenHandlerSuccess)success
                            error:(DMFacebookServiceRequestTokenHandlerFailure)failure
               missingPermissions:(DMFacebookServiceRequestTokenHandlerMissingPermissions)permissionsAreMissing
                           cancel:(DMFacebookServiceRequestTokenHandlerCancel)cancel
               fromViewController:(UIViewController *)viewController;
- (void)signUpWithFacebook:(NSDictionary *)data WithCompletionBlock:(RequestCompletion)completionBlock;
- (void)loginWithEmail:(NSString *)email password:(NSString *)password WithCompletionBlock:(RequestCompletion)completionBlock;
- (void)signUpWithEmailData:(NSDictionary *)data WithCompletionBlock:(RequestCompletion)completionBlock;
- (void)logout;
- (void)downloadUserProfileWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)downloadUserProfileResponseWithCompletionBlock:(UserProfileRequestCompletion)completionBlock;
- (void)uploadUserProfileWith:(NSDictionary *)data profileImage:(UIImage *)image completionBlock:(RequestCompletion)completionBlock;
- (void)deleteUserWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)resetPasswordWithEmailAddress:(NSString *)emailAddress withCompletionBlock:(RequestCompletion)completionBlock;
- (void)referUserWithEmailAddress:(NSString *)emailAddress withCompletionBlock:(RequestCompletion)completionBlock;
- (void)downloadReferralCodeForEmailAddress:(NSString *)emailAddress withCompletionBlock:(RequestCompletion)completionBlock;
- (void)validateCode:(NSString *)code withCompletionBlock:(RequestCompletion)completionBlock;
- (void)facebookEmailVerification:(NSString *)userId otp:(NSString *)otp password:(NSString *)password completionBlock:(RequestCompletion)completionBlock;
- (void)facebookEmailUpdate:(NSString *)email completionBlock:(RequestCompletion)completionBlock;
- (void)likeDislikeEarnNotification:(NSNumber *)notificationID to:(NSNumber *)isLike completionBlock:(RequestCompletion)completionBlock;
-(void)setDeviceToken:(NSString *)deviceToken;
-(NSString *)currentUserDeviceToken;
-(void)registerUserDeviceForPushNotifications;

- (DMUser *)currentUser;

- (void)downloadFavouriteVenuesWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)deleteVenues:(NSArray *)venues withCompletionBlock:(RequestCompletion)completionBlock;
- (void)toggleVenue:(DMVenue *)venue to:(BOOL)favourite withCompletionBlock:(RequestCompletion)completionBlock;
- (void)recommendedVenue:(DMVenue *)venue withComplectionBlock:(RequestCompletion)complectionBlock;
- (void)addVenue:(DMVenue *)venue withCompletionBlock:(RequestCompletion)completionBlock;
- (void)downloadAllTransactionsWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)postEarnTransactionWithBillImage:(UIImage *)billImage venueID:(NSNumber *)venueID transactionID:(NSNumber *)transactionID withCompletionBlock:(RequestCompletion)completionBlock;
- (void)postRedeemTransactionWithOfferID:(NSNumber *)offerID venueID:(NSNumber *)venueID withCompletionBlock:(RequestCompletion)completionBlock;
- (void)downloadAllAvailableOffersWithVenueID:(NSNumber *)venueID withCompletionBlock:(RequestCompletion)completionBlock;
//- (void)postFeedbackWithText:(NSString *)comments rating:(NSNumber *)rating venueID:(NSNumber *)venueID withCompletionBlock:(RequestCompletion)completionBlock;
- (void)postFeedbackWithText:(NSString *)comments rating:(NSNumber *)rating venueID:(NSNumber *)venueID userFeedbackAnswer:(NSString *)userFeedbackAnswer earnTransactionId:(NSNumber *)earnTransactionId withCompletionBlock:(RequestCompletion)completionBlock;
- (void)postNotificationWithFrequency:(NSNumber *)frequency withCompletionBlock:(RequestCompletion)completionBlock;
- (void)postUpdateUserWithDictionaryParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
- (void)postSubscriptionsData:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
- (void)requestEmailVerificationEmailWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)sendGDPR:(BOOL)accepted completion:(RequestCompletion)completionBlock;

- (void)updateProfileEmailVerifificationDisplayed:(BOOL)displayed;
- (BOOL)hasUpdateProfileEmailVerifificationDisplayed;

- (void)skipUser;
- (BOOL)hasUserSkipped;

- (void)downloadSubscriptionsWithCompletionBlock:(RequestCompletion)completionBlock;
- (void)uploadSubscriptions:(NSArray *)ids withDinerSub:(BOOL)dinerSub;
@end

