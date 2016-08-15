#import "_DMVenue.h"
#import "DMVenueProtocol.h"
#import "SharedModelProtocol.h"

typedef NS_ENUM(NSInteger, DMVenueState) {
    DMVenueStateSubmitted = 1,
    DMVenueStateDraft = 2,
    DMVenueStateVerfiedDemo = 3,
    DMVenueStateVerified = 4,
    DMVenueStateRejected = 5,
};

@interface DMVenue : _DMVenue <SharedModelProtocol, DMVenueProtocol> {}
// Custom logic goes here.

- (NSString *)friendlyPhoneNumber;
- (NSString *)friendlyPlaceName;
- (NSString *)friendlyFullString;
- (NSString *)priceBracketString;
- (NSArray *)sortedImagesArray;
- (DMVenueImage *)primaryImage;



@end
