#import "_DMUpdateItem.h"
#import "DMUpdateItemProtocol.h"
#import "SharedModelProtocol.h"

typedef NS_ENUM(NSInteger, DMUpdateItemType) {
    DMUpdateItemTypeAll = 0,
    DMUpdateItemTypeNews = 1,
    DMUpdateItemTypeOffer = 2,
    DMUpdateItemTypeReward = 3,
    DMUpdateItemTypeProdigalReward = 5
};

@interface DMUpdateItem : _DMUpdateItem <SharedModelProtocol, DMUpdateItemProtocol> {}
// Custom logic goes here.
@end
