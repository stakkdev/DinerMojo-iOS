#import "_DMBase.h"
#import "DMBaseProtocol.h"
#import "SharedModelProtocol.h"

@interface DMBase : _DMBase <SharedModelProtocol, DMBaseProtocol> {}
// Custom logic goes here.
@end
