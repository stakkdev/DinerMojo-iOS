//
//  DMBaseRequest.h
//  OneUpp
//
//  Created by Craig Tweedy on 07/01/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import <AFNetworking/AFNetworking.h>
#import <CoreData/CoreData.h>

#import "DMMappingProvider.h"

static const NSInteger DMErrorCode300 = 300;
static const NSInteger DMErrorCode400 = 400;
static const NSInteger DMErrorCode401 = 401;
static const NSInteger DMErrorCode404 = 404;
static const NSInteger DMErrorCode409 = 409;

typedef void(^RequestCompletion)(NSError *error, id results);
typedef void(^RequestResponse)(NSError *error, NSDictionary *results);
typedef void(^UserProfileRequestCompletion)(NSError *error, id results, id response);

@interface DMRequest : NSObject

@property (nonatomic, strong) NSManagedObjectContext *objectContext;
@property (nonatomic, strong) DMMappingProvider *mappingProvider;

@property (nonatomic, strong) AFHTTPSessionManager *httpManager;
@property (nonatomic, strong) AFHTTPSessionManager *s3Manager;


+(NSString *)currentUserToken;
+(void)updateCurrentUserToken:(NSString *)token;
-(AFHTTPSessionManager *)jsonManager;

-(void)setUsesTokenAuthorization;

-(NSString *)buildURL:(NSString *)path;
-(NSString *)buildMediaURL:(NSString *)path;
-(NSError *)errorWithStatusCode:(NSURLSessionTask *)operation withBaseError:(NSError *)error;

-(void)GET:(NSString *)url withParams:(NSDictionary *)params  withCompletionBlock:(RequestCompletion)completionBlock;
-(void)POST:(NSString *)url withParams:(NSDictionary *)params  withCompletionBlock:(RequestCompletion)completionBlock;
-(void)POST:(NSString *)url withParams:(NSDictionary *)params withBody:(void (^)(id <AFMultipartFormData> formData))body withCompletionBlock:(RequestCompletion)completionBlock;
-(void)POST:(NSString *)url withParams:(NSDictionary *)params withBodyDict:(NSDictionary *)body withCompletionBlock:(RequestCompletion)completionBlock;
-(void)PUT:(NSString *)url withParams:(NSDictionary *)params  withCompletionBlock:(RequestCompletion)completionBlock;
-(void)PATCH:(NSString *)url withParams:(NSDictionary *)params  withCompletionBlock:(RequestCompletion)completionBlock;
-(void)DELETE:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
-(void)POSTWithHeader:(NSString *)url withParams:(NSDictionary *)params headers:(NSDictionary *)header  withCompletionBlock:(RequestCompletion)completionBlock;


- (NSManagedObjectContext *)localContext;
- (void)saveInContext:(NSManagedObjectContext *)context;

@end
