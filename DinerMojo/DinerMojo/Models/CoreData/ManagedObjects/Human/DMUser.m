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
    return [NSString stringWithFormat:@"%@ %@", [self first_name], [self last_name]];
}

- (NSString *)initials
{
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
    else if (annualPoints >= 500)
    {
        return DMUserMojoLevelSilver;
    }
    else
    {
        return DMUserMojoLevelBlue;
    }
}

@end
