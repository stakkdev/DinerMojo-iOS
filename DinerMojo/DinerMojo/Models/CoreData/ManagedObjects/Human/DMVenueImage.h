#import "_DMVenueImage.h"
#import "DMVenueImageProtocol.h"
#import "SharedModelProtocol.h"

@interface DMVenueImage : _DMVenueImage <SharedModelProtocol, DMVenueImageProtocol> {}
// Custom logic goes here.

- (NSString *)fullURL;
- (NSString *)fullThumbURL;

@end
