#import "_DMTransaction.h"
#import "DMTransactionProtocol.h"
#import "SharedModelProtocol.h"

typedef NS_ENUM(NSInteger, DMTransactionType) {
    DMTransactionTypeEarn = 0,
    DMTransactionTypeRedeem = 1
};

@interface DMTransaction : _DMTransaction <SharedModelProtocol, DMTransactionProtocol> {}
// Custom logic goes here.
@end
