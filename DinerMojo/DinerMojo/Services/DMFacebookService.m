//
//  DMFacebookService.m
//  DinerMojo
//
//  Created by hedgehog lab on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMFacebookService.h"
#import "DMRequest.h"

@implementation DMFacebookService

+ (id)sharedInstance
{
    static dispatch_once_t once;
    static DMFacebookService *sharedInstance;
    dispatch_once(&once, ^ { sharedInstance = [[self alloc] init]; });
    return sharedInstance;
}

+ (NSString *)dinerMojoFormattedDate:(NSString *)facebookDate
{
    NSArray *components = [facebookDate componentsSeparatedByString:@"/"];
    
    return [NSString stringWithFormat:@"%@-%@-%@", [components objectAtIndex:2], [components objectAtIndex:0], [components objectAtIndex:1]];
}

#pragma mark - private methods

- (void)retrieveUserDetailsWithCompletionHandler:(FBSDKGraphRequestHandler)handler
{
    NSDictionary *requiredFields = @{@"fields" : @"picture.width(320).height(320),birthday,email,first_name,gender,id,last_name"};
    [[[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:requiredFields]
     startWithCompletionHandler:handler];
}

- (NSError *)errorForFacebookEmailVerification:(id)data
{
    if ([data objectForKey:@"email"] == nil)
    {
        return [NSError errorWithDomain:NSCocoaErrorDomain
                                             code:DMErrorCode300
                                         userInfo:nil];
    }
    else
    {
        return nil;
    }
}

#pragma mark - public methods

- (void)loginWithSuccess:(DMFacebookServiceRequestTokenHandlerSuccess)success
                   error:(DMFacebookServiceRequestTokenHandlerFailure)failure
      missingPermissions:(DMFacebookServiceRequestTokenHandlerMissingPermissions)permissionsAreMissing
                  cancel:(DMFacebookServiceRequestTokenHandlerCancel)cancel
      fromViewController:(UIViewController *)viewController
{
    FBSDKLoginManager *login = [[FBSDKLoginManager alloc] init];
    
    __weak typeof(self) weakSelf = self;

    [login logInWithPermissions:[self permissions] fromViewController:viewController handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
        if (error)
        {
            failure(error, nil);
        }
        else if ([result isCancelled])
        {
            cancel();
        }
        else {
            if ([[result declinedPermissions] count] > 0)
            {
                permissionsAreMissing([result declinedPermissions]);
            }
            else {
                [weakSelf retrieveUserDetailsWithCompletionHandler:^(FBSDKGraphRequestConnection *connection, id result, NSError *error) {
                    if (error)
                    {
                        failure(error, nil);
                    }
                    else
                    {
                        NSError *verificationError = [self errorForFacebookEmailVerification:result];
                        if (verificationError == nil)
                        {
                            success(result);
                        }
                        else
                        {
                            failure(verificationError, nil);
                        }
                    }
                }];
            }
        }

    }];
    
   
}

- (BOOL)isFacebookSessionOpen
{
    return ([FBSDKAccessToken currentAccessToken] != nil);
}

- (void)logOut
{
    [[FBSDKLoginManager new] logOut];
}

@end
