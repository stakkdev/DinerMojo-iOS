#import "_DMEarnTransaction.h"
#import "DMEarnTransactionProtocol.h"
#import "SharedModelProtocol.h"

typedef NS_ENUM(NSInteger, DMTransactionState) {
    DMPending = 0,
    DMChecked = 1,
    DMVerified = 2,
    DMRejected = 3,
};

typedef NS_ENUM(NSInteger, DMTransactionEarnType) {
    DMTransactionEarnTypeDine = 0,
    DMTransactionEarnTypeReferred = 1,
    DMTransactionEarnTypeLoyalty = 2,
};

@interface DMEarnTransaction : _DMEarnTransaction <SharedModelProtocol, DMEarnTransactionProtocol> {}
// Custom logic goes here.

@end
