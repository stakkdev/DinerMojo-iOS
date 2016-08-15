#import "DMVenueImage.h"
#import "DMRequest.h"


@interface DMVenueImage ()

// Private interface goes here.

@end


@implementation DMVenueImage

- (NSString *)fullURL
{
    DMRequest *request = [DMRequest new];
    
    return [request buildMediaURL:[self image]];
}

- (NSString *)fullThumbURL
{
    DMRequest *request = [DMRequest new];
    
    return [request buildMediaURL:[self thumb]];
}

@end
