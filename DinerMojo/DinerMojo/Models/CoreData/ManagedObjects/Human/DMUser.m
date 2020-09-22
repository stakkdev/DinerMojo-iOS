#import "DMUser.h"


@interface DMUser ()

// Private interface goes here.

@end


@implementation DMUser

+ (BOOL)validateEmailWithString:(NSString*)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

- (NSString *)fullName
{
    if(self.first_name == NULL || self.last_name == NULL) {
        return @"";
    }
    return [NSString stringWithFormat:@"%@ %@", [self first_name], [self last_name]];
}

- (NSString *)initials
{
    if(self.first_name == NULL || self.last_name == NULL) {
        return @"";
    }
    return [[NSString stringWithFormat:@"%@%@", [[self first_name] substringToIndex:1], [[self last_name] substringToIndex:1]] uppercaseString];
}

- (NSString *)profilePictureFullURL
{
    if ([self profile_picture] == nil)
    {
        return nil;
        
    }
    
    else
    {
        return [[DMUserRequest new] buildMediaURL:[self profile_picture]];
    }
}

- (BOOL)availableMojoLevels:(NSArray *)levels {
    if ([levels containsObject:@"4"]) {
        return true;
    }
    
    NSString *currentLevel = [NSString stringWithFormat:@"%ld", (long)self.mojoLevel];
    return [levels containsObject:currentLevel];
}

- (UIColor *)getMojoLevelColor:(NSArray *)levels {
    if ([levels containsObject:@"4"]) {
        return [UIColor offersGreenColor];
    }
    
    if ([self availableMojoLevels:levels]) {
        return [self colorForMojoLevel:[self mojoLevel]];
    }
    
    int levelToUse;
    
    if ([self containsSmalerLevelThanMine:levels]) {
        levelToUse = [self nextAvailableMojoLevel:levels];
    } else {
        levelToUse = [self lowestLevelInArray:levels];
    }
    
    return [self colorForMojoLevel:levelToUse];
}
    
- (int)nextAvailableMojoLevel:(NSArray *)levels {
    int nextLevel = INT_MAX;
    
    for (NSString *str in levels) {
        int intValue = [str intValue];
        
        if (intValue < [self mojoLevel]) {
            if (nextLevel == INT_MAX) {
                nextLevel = intValue;
            } else {
                if (intValue > nextLevel) {
                    nextLevel = intValue;
                }
            }
        }
    }
    
    return nextLevel;
}
    
- (BOOL)containsSmalerLevelThanMine:(NSArray *)levels {
    for (NSString *str in levels) {
        int intValue = [str intValue];
        
        if (intValue > [self mojoLevel]) {
            return YES;
        }
    }
    
    return NO;
}

- (UIColor *)getMojoHighestLevelColor:(NSArray *)levels {
    int highestLevel = [self highestLevelInArray:levels];
    return [self colorForMojoLevel:highestLevel];
}

- (int)highestLevelInArray:(NSArray *)levels {
    int min = INT_MAX;
    
    for (NSString *str in levels) {
        int intValue = [str intValue];
        
        if (intValue < min) {
            min = intValue;
        }
    }
    
    return min;
}

- (int)lowestLevelInArray:(NSArray *)levels {
    int max = INT_MIN;
    
    for (NSString *str in levels) {
        int intValue = [str intValue];
        
        if (intValue > max) {
            max = intValue;
        }
    }
    
    return max;
}

- (NSString *)nextMojoLevelName {
    return [self nameOfMojoLevel:[self nextMojoLevel]];
}

- (NSString *)nameOfMojoLevel:(DMUserMojoLevel)mojoLevel {
    switch (mojoLevel) {
        case DMUserMojoLevelBlue:
            return @"blue";
            break;
        case DMUserMojoLevelSilver:
            return @"silver";
        case DMUserMojoLevelGold:
            return @"gold";
        default:
            return @"platinum";
            break;
    }
}

- (NSString *)myMojoLevelName {
    return [self nameOfMojoLevel:[self mojoLevel]];
}

- (DMUserMojoLevel)nextMojoLevel {
    switch ([self mojoLevel]) {
        case DMUserMojoLevelBlue:
            return DMUserMojoLevelSilver;
            break;
        case DMUserMojoLevelSilver:
            return DMUserMojoLevelGold;
        case DMUserMojoLevelGold:
            return DMUserMojoLevelPlatinum;
        default:
            return DMUserMojoLevelPlatinum;
            break;
    }
}

- (UIColor *)colorForMojoLevel:(int)level {
    switch (level) {
        case 0:
            return [UIColor platinumMainColor];
            break;
        case 1:
            return [UIColor goldMainColor];
            break;
        case 2:
            return [UIColor silverMainColor];
            break;
        default:
            return [UIColor blueMainColor];
            break;
    }
}

-(NSInteger)pointsToNextLevel {
    DMUserMojoLevel currentLevel = self.mojoLevel;
    NSInteger annualPoints = [[self annual_points_earned] integerValue];
    
    if (currentLevel != DMUserMojoLevelPlatinum) {
        switch (currentLevel) {
            case DMUserMojoLevelBlue:
                return 200 - annualPoints;
                break;
            case DMUserMojoLevelSilver:
                return 1000 - annualPoints;
                break;
            case DMUserMojoLevelGold:
                return 2000 - annualPoints;
                break;
            default:
                return 0;
        }
    }
    
    return 0;
}

- (DMUserMojoLevel)mojoLevel
{
    NSInteger annualPoints = [[self annual_points_earned] integerValue];
    
    if (annualPoints >= 2000)
    {
        return DMUserMojoLevelPlatinum;
    }
    else if (annualPoints >= 1000)
    {
        return DMUserMojoLevelGold;
    }
    else if (annualPoints >= 200)
    {
        return DMUserMojoLevelSilver;
    }
    else
    {
        return DMUserMojoLevelBlue;
    }
}

@end
