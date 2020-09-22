//
//  RestaurantInfoEnum.h
//  DinerMojo
//
//  Created by Patryk on 18/02/2019.
//  Copyright © 2019 hedgehog lab. All rights reserved.
//

#ifndef RestaurantInfoEnum_h
#define RestaurantInfoEnum_h

#import <Foundation/Foundation.h>

@interface RestaurantInfoButtonType : NSObject

typedef enum {
    kPhoneNumber,
    kWebSite,
    kOpeningHours,
    kMenu,
    kNews,
    kTripAdvisor,
    kEmptyButton
} RestaurantInfoButtonEnum;

+(RestaurantInfoButtonEnum)typeFor:(int)index withVenue:(DMVenue*)venue;
+(NSString*)titleFor:(RestaurantInfoButtonEnum)type withVenue:(DMVenue*)venue;
+(NSString*)imageNameFor:(RestaurantInfoButtonEnum)type;
+(BOOL)isActiveWith:(DMVenue*)venue forType:(RestaurantInfoButtonEnum)type;
+(NSString*)createHoursString:(DMVenue*)venue;
+(BOOL)isButtonAlwaysActiveFor:(RestaurantInfoButtonEnum)type;
+(NSString *)openingHoursForDay:(int)day openingTimes:(DMVenueOpeningTimes *)openingTimes;
    
@end

#endif /* RestaurantInfoEnum_h */
