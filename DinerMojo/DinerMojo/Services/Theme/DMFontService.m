//
//  DMFontService.m
//  DinerMojo
//
//  Created by Robert Sammons on 05/06/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMFontService.h"

@implementation UIFont (additionalFonts)

+(UIFont *) navigationFont;
{
    return [UIFont fontWithName:@"OpenSans" size:17.0f];
}

+(UIFont *) navigationBarButtonItemFont;
{
    return [UIFont fontWithName:@"OpenSans" size:18.0f];
}

+(UIFont *)tutorialTitleFont;
{
    return [UIFont fontWithName:@"OpenSans" size:18.0f];

}

+(UIFont *)tutorialDescriptionFont;
{
    return [UIFont fontWithName:@"OpenSans-Light" size:18.0f];
    
}

+(UIFont *)pointsLargeFont;
{
    return [UIFont fontWithName:@"OpenSans-SemiBold" size:18.0f];
    
}

+(UIFont *)settingsTableViewCellFont;
{
    return [UIFont fontWithName:@"OpenSans" size:16.0f];
    
}


@end
