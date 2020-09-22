//
//  RestaurantInfoButtonEnum.m
//  DinerMojo
//
//  Created by Patryk on 18/02/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "RestaurantInfoButtonEnum.h"
#import "DMVenueOpeningTimes.h"

@interface RestaurantInfoButtonType()
@end

@implementation RestaurantInfoButtonType

+(RestaurantInfoButtonEnum)typeFor:(int)index withVenue:(DMVenue*)venue {
    BOOL isRestaurant = [venue.venue_type isEqualToString:@"restaurant"];
    switch (index) {
        case 0:
            return kPhoneNumber;
        case 1:
            return kWebSite;
        case 2:
            return kOpeningHours;
        case 3:
            return isRestaurant ? kMenu : kNews;
        case 4:
            return isRestaurant ? kNews : kEmptyButton;
        case 5:
            return isRestaurant ? kTripAdvisor: kEmptyButton;
        default:
            return kEmptyButton;
    }
}
    
+(NSString*)titleFor:(RestaurantInfoButtonEnum)type withVenue:(DMVenue*)venue {
    BOOL isActive = [RestaurantInfoButtonType isActiveWith:venue forType:type];
    switch (type) {
        case kPhoneNumber:
            return isActive ? venue.primitivePhone_number : @"";
        case kWebSite:
            return isActive ? venue.primitiveWeb_address : @"";
        case kOpeningHours: {
            NSString* hours = [RestaurantInfoButtonType createHoursString:venue];
            return isActive ? hours : @"Closed today";
        }
        case kMenu:
            return @"Menu";
        case kNews:
            return @"News";
        case kTripAdvisor:
            return @"See it on TripAdvisor";
        case kEmptyButton:
            return @"";
    }
}
    
+(NSString*)imageNameFor:(RestaurantInfoButtonEnum)type {
    switch (type) {
        case kPhoneNumber:
            return @"phone";
        case kWebSite:
            return @"website";
        case kOpeningHours:
            return @"clock";
        case kMenu:
            return @"menu";
        case kNews:
            return @"news_offers";
        case kTripAdvisor:
            return @"tripadvisorBtn";
        case kEmptyButton:
            return @"";
    }
}
    
+(BOOL)isActiveWith:(DMVenue*)venue forType:(RestaurantInfoButtonEnum)type {
    switch (type) {
        case kPhoneNumber:
            return ![venue.primitivePhone_number isEqualToString:@""];
        case kWebSite:
            return ![venue.primitiveWeb_address isEqualToString:@""];
        case kOpeningHours: {
            NSString* hours = [RestaurantInfoButtonType createHoursString:venue];
            return !([hours isEqualToString:@"closed"] || [hours isEqualToString:@""]);
        }
        case kMenu:
            return ![venue.primitiveMenu_url isEqualToString:@""];
        case kNews:
            return venue.has_offersValue || venue.has_newsValue;
        case kTripAdvisor:
            return venue.trip_advisor_link.length != 0;
        case kEmptyButton:
            return NO;
    }
}
    
+(NSString*)createHoursString:(DMVenue*)venue {
    DMVenueOpeningTimes *openingTimes = (DMVenueOpeningTimes *) venue.opening_times;
    int weekday = (int)[[NSCalendar currentCalendar] component:NSCalendarUnitWeekday
                                                      fromDate:[NSDate date]] - 1;
    if(weekday == 0) weekday = 7;
    weekday -= 1;
    NSString *hours = [RestaurantInfoButtonType openingHoursForDay:weekday openingTimes:openingTimes];
    return hours;
}
    
+(BOOL)isButtonAlwaysActiveFor:(RestaurantInfoButtonEnum)type {
    switch (type) {
        case kPhoneNumber:
        case kWebSite:
        case kMenu:
        case kNews:
        case kTripAdvisor:
        case kEmptyButton:
            return NO;
        case kOpeningHours:
            return YES;
    }
}
    
+(NSString *)openingHoursForDay:(int)day openingTimes:(DMVenueOpeningTimes *)openingTimes {
    switch (day) {
        case 0:
            return [openingTimes primitiveMonday];
        case 1:
            return [openingTimes primitiveTuesday];
        case 2:
            return [openingTimes primitiveWednesday];
        case 3:
            return [openingTimes primitiveThursday];
        case 4:
            return [openingTimes primitiveFriday];
        case 5:
            return [openingTimes primitiveSaturday];
        case 6:
            return [openingTimes primitiveSunday];
        default:
            return @"";
    }
}

@end

