//
//  DMColorService.m
//  DinerMojo
//
//  Created by Rob Sammons on 04/06/2015.
//  Copyright (c) 2015 Hedgehog Lab. All rights reserved.
//

#import "DMColorService.h"
#import <UIKit/UIKit.h>

@implementation UIColor (additionalColor)

+(UIColor *) brandColor;
{
    return [UIColor colorWithRed:0.43137254901961f green:0.7843137254902f blue:0.69803921568627f alpha:1.00f];
}


+(UIColor *) navColor
{
    return [UIColor colorWithRed:0.325f green:0.745f blue:0.643f alpha:1.00f];
}
            
+(UIColor *) facebookColor;
{
    return [UIColor colorWithRed:0.302f green:0.408f blue:0.624f alpha:1.00f];
}

+(UIColor *) newsGrayColor;
{
    return [UIColor colorWithRed:0.847f green:0.847f blue:0.847f alpha:1.00f];
}
+(UIColor *) newsColor;

{
    return [UIColor colorWithRed:0.459f green:0.796f blue:0.714f alpha:1.00f];
}

+(UIColor *) offersColor;
{
    return [UIColor colorWithRed:0.980f green:0.647f blue:0.184f alpha:1.00f];
}

+(UIColor *) platinumMainColor;
{
    return [UIColor colorWithRed:0.765f green:0.792f blue:0.855f alpha:1.00f];
}

+(UIColor *) platinumSubColor;
{
    return [UIColor colorWithRed:0.651f green:0.675f blue:0.729f alpha:1.00f];
}

+(UIColor *) goldMainColor;
{
    return [UIColor colorWithRed:1.000f green:0.812f blue:0.373f alpha:1.00f];
}

+(UIColor *) goldSubColor;
{
    return [UIColor colorWithRed:0.851f green:0.690f blue:0.318f alpha:1.00f];
}

+(UIColor *) silverMainColor;
{
    return [UIColor colorWithRed:0.918f green:0.918f blue:0.918f alpha:1.00f];
}

+(UIColor *) silverSubColor;
{
    return [UIColor colorWithRed:0.780f green:0.780f blue:0.780f alpha:1.00f];
}

+(UIColor *) silverTintColor;
{
    return [UIColor colorWithRed:0.467f green:0.467f blue:0.451f alpha:1.00f];
}
+(UIColor *) blueMainColor;
{
    return [UIColor colorWithRed:0.467f green:0.714f blue:0.914f alpha:1.00f];
}

+(UIColor *) blueSubColor;
{
    return [UIColor colorWithRed:0.392f green:0.608f blue:0.773f alpha:1.00f];
}

+(UIColor *)settingsDarkGrayTextColor;
{
    return [UIColor colorWithRed:0.573f green:0.573f blue:0.573f alpha:1.00f];
}
+(UIColor *)settingsDarkGrayCellColor;
{
    return [UIColor colorWithRed:0.847f green:0.847f blue:0.847f alpha:1.00f];
}

+(UIColor *)settingsLightGrayCellColor;
{
    return [UIColor colorWithRed:0.929f green:0.929f blue:0.929f alpha:1.00f];
}



@end
