#import "DMVenue.h"
#import "DMVenueImage.h"


@interface DMVenue ()

// Private interface goes here.

@end


@implementation DMVenue



- (NSString *)friendlyPhoneNumber
{
    NSRange range = NSMakeRange(0,1);
    
    
    NSString* phoneString = [[self.phone_number componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
    
    
    if ([phoneString hasPrefix:@"0"]) {
        phoneString = [phoneString stringByReplacingCharactersInRange:range withString:@"+44"];
    }
    
    return phoneString;
}

- (NSString *)friendlyPlaceName
{
    if ([self house_number_street_name] != nil)
    {
        return [self house_number_street_name];
    }
    else
    {
        if ([self area] != nil)
        {
            return [self area];
        }
        else
        {
            return [self town];
        }
    }
}

- (NSString *)friendlyFullString
{
    if ([self area].length == 0)
    {
        return [NSString stringWithFormat:@"%@\n%@\n%@", [self house_number_street_name], [self town], [self post_code]];

    }
    
    else
    {
        return [NSString stringWithFormat:@"%@\n%@\n%@\n%@", [self house_number_street_name], [self area], [self town], [self post_code]];
    }
}

- (NSString *)priceBracketString
{
    NSMutableString *priceString = [NSMutableString new];
    
    for (NSInteger c = 0; c <= [self price_bracketValue]; c++)
    {
        [priceString appendString:@"£"];
    }
    
    return priceString;
}

- (NSArray *)sortedImagesArray
{
    if ([[self images] count] == 0)
    {
        return nil;
    }
    
    NSMutableArray *returnArray = [NSMutableArray arrayWithArray:[[self images] allObjects]];
    
    if ([self primary_image] != nil)
    {
        [returnArray removeObject:[self primary_image]];

    }
    
    // Order by date and then filename (Dates tend to be the same when uploaded in batch via hub)
    NSSortDescriptor *dateDescr = [[NSSortDescriptor alloc] initWithKey:@"created_at" ascending:NO];
    NSSortDescriptor *strDescr = [[NSSortDescriptor alloc] initWithKey:@"image" ascending:YES];
    NSArray *sortDescriptors = @[dateDescr, strDescr];
    returnArray = [NSMutableArray arrayWithArray:[returnArray sortedArrayUsingDescriptors:sortDescriptors]];
    
    if ([self primary_image] != nil)
    {
        [returnArray insertObject:[self primary_image] atIndex:0];
        
    }
    
    return returnArray;
}

- (DMVenueImage *)primaryImage
{
    if ([self primary_image] == nil)
    {
        if ([[self images] count] > 0)
        {
            return [[self sortedImagesArray] firstObject];
        }
        else
        {
            return nil;
        }
    }
    else
    {
        return (DMVenueImage *)[self primary_image];
    }
}

@end
