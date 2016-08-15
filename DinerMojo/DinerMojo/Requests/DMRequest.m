//
//  DMBaseRequest.m
//  OneUpp
//
//  Created by Craig Tweedy on 07/01/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMRequest.h"

@interface DMRequest ()

@property (nonatomic, strong) NSURL *apiBaseURL;
@property (nonatomic, strong) NSURL *mediaBaseURL;
@property (nonatomic, strong) AFHTTPRequestOperationManager *jsonManager;

@end

@implementation DMRequest

-(instancetype)init
{
    self = [super init];
    if (self)
    {
        NSDictionary *config = [[NSBundle mainBundle] infoDictionary];
        
        NSString *envsPListPath = [[NSBundle mainBundle] pathForResource:@"Environments" ofType:@"plist"];
        
        NSDictionary *environments = [[NSDictionary alloc] initWithContentsOfFile:envsPListPath];
        
        NSDictionary *environment = [environments objectForKey:[config objectForKey:@"Configuration"]];
        
        _apiBaseURL = [NSURL URLWithString:[environment objectForKey:@"apiURL"]];
        
        _mediaBaseURL = [NSURL URLWithString:[environment objectForKey:@"mediaURL"]];
        
        _objectContext = [NSManagedObjectContext MR_defaultContext];
        
        _mappingProvider = [DMMappingProvider new];
        
        [self setUsesTokenAuthorization];
    }
    return self;
}

#pragma mark - Authentication

+(NSString *)currentUserToken;
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"currentUserToken"];
}

+(void)updateCurrentUserToken:(NSString *)token;
{
    [[NSUserDefaults standardUserDefaults] setObject:token forKey:@"currentUserToken"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(void)setUsesTokenAuthorization;
{
    NSString *currentToken = [DMRequest currentUserToken];
    if (currentToken != nil)
    {
        NSString *tokenHeader = [NSString stringWithFormat:@"Token %@", currentToken];
        [[[self jsonManager] requestSerializer] setValue:tokenHeader forHTTPHeaderField:@"Authorization"];
    }
}

#pragma mark - Utilities

-(NSString *)buildURL:(NSString *)path;
{
    if (path == nil)
    {
        return nil;
    }
    
    return [[[self apiBaseURL] URLByAppendingPathComponent:path] absoluteString];
}

-(NSString *)buildMediaURL:(NSString *)path;
{
    if (path == nil)
    {
        return nil;
    }
    
    // Media Base URL can be blank if absolute for S3 buckets are returned
    if ([[[self mediaBaseURL] absoluteString] length] > 0)
    {
        return [[[self mediaBaseURL] URLByAppendingPathComponent:path] absoluteString];
    }
    else
    {
        return path;
    }
}

-(NSError *)errorWithStatusCode:(AFHTTPRequestOperation *)operation withBaseError:(NSError *)error;
{
    return [NSError errorWithDomain:error.domain code:operation.response.statusCode userInfo:error.userInfo];
}

#pragma mark - GET

-(void)GET:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
{
    [[self jsonManager] GET:[self buildURL:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil, responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([self errorWithStatusCode:operation withBaseError:error], nil);
    }];
}

#pragma mark - POST

-(void)POST:(NSString *)url withParams:(NSDictionary *)params  withCompletionBlock:(RequestCompletion)completionBlock;
{
    [[self jsonManager] POST:[self buildURL:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([self errorWithStatusCode:operation withBaseError:error],nil);
    }];
}

-(void)POST:(NSString *)url withParams:(NSDictionary *)params withBody:(void (^)(id <AFMultipartFormData> formData))body withCompletionBlock:(RequestCompletion)completionBlock;
{
    [[self jsonManager] POST:[self buildURL:url] parameters:params constructingBodyWithBlock:body success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([self errorWithStatusCode:operation withBaseError:error],nil);
    }];
}

#pragma mark - PUT

-(void)PUT:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
{
    [[self jsonManager] PUT:[self buildURL:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([self errorWithStatusCode:operation withBaseError:error],nil);
    }];
}

#pragma mark - PATCH

-(void)PATCH:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
{
    [[self jsonManager] PATCH:[self buildURL:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([self errorWithStatusCode:operation withBaseError:error],nil);
    }];
}

#pragma mark - DELETE

-(void)DELETE:(NSString *)url withParams:(NSDictionary *)params withCompletionBlock:(RequestCompletion)completionBlock;
{
    [[self jsonManager] DELETE:[self buildURL:url] parameters:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        completionBlock(nil,responseObject);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        completionBlock([self errorWithStatusCode:operation withBaseError:error],nil);
    }];
}

#pragma mark - Lazy Loading

-(AFHTTPRequestOperationManager *)jsonManager;
{
    if (_jsonManager) {
        return _jsonManager;
    }
    
    _jsonManager = [AFHTTPRequestOperationManager manager];
    [_jsonManager setRequestSerializer:[AFJSONRequestSerializer serializer]];
    [_jsonManager setResponseSerializer:[AFJSONResponseSerializer serializer]];
    
    return _jsonManager;
}

-(AFHTTPRequestOperationManager *)httpManager;
{
    if (_httpManager) {
        return _httpManager;
    }
    
    _httpManager = [AFHTTPRequestOperationManager manager];
    
    AFImageResponseSerializer *serializer = [AFImageResponseSerializer serializer];
    serializer.acceptableContentTypes = [serializer.acceptableContentTypes setByAddingObject:@"binary/octet-stream"];
    [_httpManager setResponseSerializer:serializer];
    return _httpManager;
}

# pragma mark - Core Data

- (NSManagedObjectContext *)localContext;
{
    return [NSManagedObjectContext MR_context];
}

- (void)saveInContext:(NSManagedObjectContext *)context;
{
    [context MR_saveToPersistentStoreAndWait];
}

@end
