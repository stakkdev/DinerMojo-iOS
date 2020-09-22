#import "_DMUser.h"
#import "DMUserProtocol.h"
#import "SharedModelProtocol.h"

typedef NS_ENUM(NSInteger, DMUserGender) {
    DMUserGenderMale = 0,
    DMUserGenderFemale = 1
};

typedef NS_ENUM(NSInteger, DMUserNotificationFilter) {
    DMUserNotificationFilterAll = 0,
    DMUserNotificationFilterNews = 1,
    DMUserNotificationFilterOffers = 2
};

typedef NS_ENUM(NSInteger, DMUserNotificationFrequency) {
    DMUserNotificationFrequencyImmediate = 0,
    DMUserNotificationFrequencyDaily = 1,
    DMUserNotificationFrequencyWeekly = 2,
    DMUserNotificationFrequencyNever = 3
};


typedef NS_ENUM(NSInteger, DMUserMojoLevel) {
    DMUserMojoLevelPlatinum = 0,
    DMUserMojoLevelGold = 1,
    DMUserMojoLevelSilver = 2,
    DMUserMojoLevelBlue = 3
};

@interface DMUser : _DMUser <SharedModelProtocol, DMUserProtocol> {}

+ (BOOL)validateEmailWithString:(NSString*)email;

- (NSString *)fullName;
- (NSString *)initials;
- (NSString *)profilePictureFullURL;
- (DMUserMojoLevel)mojoLevel;
- (NSInteger)pointsToNextLevel;
- (UIColor *)getMojoLevelColor:(NSArray *)levels;
- (UIColor *)getMojoHighestLevelColor:(NSArray *)levels;
- (UIColor *)colorForMojoLevel:(int)level;
- (DMUserMojoLevel)nextMojoLevel;
- (BOOL)availableMojoLevels:(NSArray *)level;
- (NSString *)nextMojoLevelName;
- (NSString *)myMojoLevelName;


@end
