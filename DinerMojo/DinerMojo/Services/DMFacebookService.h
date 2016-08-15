//
//  DMFacebookService.h
//  DinerMojo
//
//  Created by hedgehog lab on 11/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

typedef void (^DMFacebookServiceRequestTokenHandlerSuccess)(id result);
typedef void (^DMFacebookServiceRequestTokenHandlerFailure)(NSError *error, id additionalInfo);
typedef void (^DMFacebookServiceRequestTokenHandlerMissingPermissions)(NSSet *missingPermissions);
typedef void (^DMFacebookServiceRequestTokenHandlerCancel)();

@interface DMFacebookService : NSObject

@property (strong, nonatomic) NSArray *permissions;

+ (id)sharedInstance;
+ (NSString *)dinerMojoFormattedDate:(NSString *)facebookDate;

- (void)loginWithSuccess:(DMFacebookServiceRequestTokenHandlerSuccess)success
                   error:(DMFacebookServiceRequestTokenHandlerFailure)failure
      missingPermissions:(DMFacebookServiceRequestTokenHandlerMissingPermissions)permissionsAreMissing
                  cancel:(DMFacebookServiceRequestTokenHandlerCancel)cancel;

- (BOOL)isFacebookSessionOpen;
- (void)logOut;

@end
