#import "_DMNewsItem.h"
#import "DMNewsItemProtocol.h"
#import "SharedModelProtocol.h"

@interface DMNewsItem : _DMNewsItem <SharedModelProtocol, DMNewsItemProtocol> {}
// Custom logic goes here.
@end
