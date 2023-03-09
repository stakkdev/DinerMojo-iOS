//
//  DMMappingProvider.m
//  DinerMojo
//
//  Created by Craig Tweedy on 08/01/2015.
//  Copyright (c) 2015 hedgehog lab. All rights reserved.
//

#import "DMMappingProvider.h"

@implementation DMMappingProvider

#pragma mark - Base

- (void)baseMapping:(FEMManagedObjectMapping *)mapping
{
    [mapping setPrimaryKey:@"modelID"];  // object uniquing
    
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"created_at" toKeyPath:@"created_on" dateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]];
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"updated_at" toKeyPath:@"updated_on" dateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]];
    
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"modelID" toKeyPath:@"id"]];
}

#pragma mark - Venues

- (void)baseVenueMapping:(FEMManagedObjectMapping *)mapping
{
    [mapping addAttributesFromDictionary:@{@"venue_description":@"description"}];
    
    [mapping addAttributesFromArray:@[@"name", @"house_number_street_name", @"area", @"town", @"post_code", @"web_address", @"phone_number", @"latitude", @"longitude", @"price_bracket", @"menu_url", @"state", @"trip_advisor_link",@"email_adddress",@"allows_earns",@"allows_redemptions",@"venue_type",@"has_offers",@"has_news", @"booking_url", @"booking_available", @"booking_max_people", @"booking_today_allow"]];
    
    [mapping addToManyRelationshipMapping:[self venueImageMapping] forProperty:@"images" keyPath:@"images"];
    
    [mapping addRelationshipMapping:[self venueImageMapping] forProperty:@"primary_image" keyPath:@"primary_image"];
    
    [mapping addToManyRelationshipMapping:[self categoryMapping] forProperty:@"categories" keyPath:@"venue_category"];
    
    [mapping addRelationshipMapping:[self venueOpeningTimesMapping] forProperty:@"opening_times" keyPath:@"opening_times"];
    
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"created_on" toKeyPath:@"created_on" dateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]];
}

- (void)baseProdigalVenueMapping:(FEMManagedObjectMapping *)mapping
{
    [mapping addAttributesFromDictionary:@{@"venue_description":@"description"}];
    
    [mapping addAttributesFromArray:@[@"name", @"house_number_street_name", @"area", @"town", @"post_code", @"web_address", @"phone_number", @"latitude", @"longitude", @"price_bracket", @"menu_url", @"state", @"trip_advisor_link",@"email_adddress",@"allows_earns",@"allows_redemptions",@"venue_type",@"has_offers",@"has_news", @"booking_url", @"booking_available", @"booking_max_people", @"booking_today_allow"]];
    
    [mapping addToManyRelationshipMapping:[self venueImageMapping] forProperty:@"images" keyPath:@"images"];
    
    [mapping addRelationshipMapping:[self venueOpeningTimesMapping] forProperty:@"opening_times" keyPath:@"opening_times"];
    
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"created_on" toKeyPath:@"created_on" dateFormat:@"yyyy-MM-dd'T'HH:mm:ssZ"]];
}

- (FEMManagedObjectMapping *)venueMappingWithoutNews
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMVenue" configuration:^(FEMManagedObjectMapping *mapping) {
    
        [weakSelf baseMapping:mapping];
        
        [weakSelf baseVenueMapping:mapping];
    }];
}

- (FEMManagedObjectMapping *)venueProdigalMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMVenue" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf baseProdigalVenueMapping:mapping];
    }];
}

- (FEMManagedObjectMapping *)venueMappingWithNews
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMVenue" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf baseVenueMapping:mapping];
        
        [mapping addToManyRelationshipMapping:[self newsMapping] forProperty:@"news" keyPath:@"news"];
    }];
}

- (FEMManagedObjectMapping *)categoryMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMVenueCategory" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"name"]];
    }];
}

- (FEMManagedObjectMapping *)venueImageMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMVenueImage" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [mapping addAttributesFromDictionary:@{@"image_description":@"description"}];
        
        [mapping addAttributesFromArray:@[@"name", @"image", @"thumb"]];
    }];
}

- (FEMManagedObjectMapping *)venueOpeningTimesMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMVenueOpeningTimes" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"monday", @"tuesday", @"wednesday", @"thursday", @"friday", @"saturday", @"sunday"]];
    }];
}

#pragma mark - News/Offers

- (void)updateBaseMapping:(FEMManagedObjectMapping *)mapping
{
    [mapping addAttributesFromArray:@[@"title", @"image", @"thumb"]];
    
    [mapping addAttributesFromDictionary:@{@"news_description":@"description"}];
    
    [mapping addRelationshipMapping:[self venueMappingWithoutNews] forProperty:@"venue" keyPath:@"venue"];
    
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"expiry_date" toKeyPath:@"expiry_date" dateFormat:@"yyyy-MM-dd"]];
}

- (void)updateBaseProdigalMapping:(FEMManagedObjectMapping *)mapping
{
    [mapping addAttributesFromArray:@[@"title", @"image", @"thumb"]];
    
    [mapping addAttributesFromDictionary:@{@"news_description":@"description"}];
    
    [mapping addRelationshipMapping:[self venueProdigalMapping] forProperty:@"venue" keyPath:@"venue"];
    
    [mapping addAttribute:[FEMAttribute mappingOfProperty:@"expiry_date" toKeyPath:@"expiry_date" dateFormat:@"yyyy-MM-dd"]];
}

- (FEMManagedObjectMapping *)newsMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMNewsItem" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf updateBaseMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"update_type", @"is_system_news_item", @"venue_type",@"additional_payload"]];
        
    }];
}

- (FEMManagedObjectMapping *)prodigalRewardMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMNewsItem" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf updateBaseProdigalMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"update_type", @"is_system_news_item", @"venue_type",@"additional_payload"]];
        
    }];
}

- (FEMManagedObjectMapping *)offerMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMOfferItem" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf updateBaseMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"update_type", @"points_required", @"is_special_offer", @"discount", @"terms_conditions", @"is_birthday_offer", @"is_system_news_item", @"venue_type", @"monetary_value", @"is_prodigal_reward", @"days_available", @"allowed_mojo_levels"]];
        
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"start_date" toKeyPath:@"start_date" dateFormat:@"yyyy-MM-dd"]];
    }];
}

- (FEMManagedObjectMapping *)simpleOfferMapping;
{
    return [FEMManagedObjectMapping mappingForEntityName:@"DMOfferItem" configuration:^(FEMManagedObjectMapping *mapping) {
        [mapping setPrimaryKey:@"modelID"];
        
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"modelID" toKeyPath:@"id"]];
        
        [mapping addAttributesFromArray:@[@"title"]];
        
    }];
}

#pragma mark - User

- (FEMManagedObjectMapping *)completeUserMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMUser" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"first_name", @"last_name", @"facebook_id", @"email_address", @"gender", @"device_scale", @"profile_picture", @"post_code", @"annual_points_earned", @"annual_points_balance", @"notification_frequency", @"notification_filter", @"referred_points", @"is_email_verified", @"is_gdpr_accepted"]];
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"date_of_birth" toKeyPath:@"date_of_birth" dateFormat:@"yyyy-MM-dd"]];
        [mapping addToManyRelationshipMapping:[self venueMappingWithoutNews] forProperty:@"favourite_venues" keyPath:@"favourite_venues"];
    }];
}

- (FEMManagedObjectMapping *)simpleUserMapping;
{
    return [FEMManagedObjectMapping mappingForEntityName:@"DMUser" configuration:^(FEMManagedObjectMapping *mapping) {
        [mapping setPrimaryKey:@"modelID"];
        
        [mapping addAttribute:[FEMAttribute mappingOfProperty:@"modelID" toKeyPath:@"id"]];
        
    }];
}

// Maps a user but only the favourites data is mapped
- (FEMManagedObjectMapping *)userFavouriteVenuesMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMUser" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [mapping addToManyRelationshipMapping:[self venueMappingWithoutNews] forProperty:@"favourite_venues" keyPath:@"favourite_venues"];
    }];
}

#pragma mark - Transactions

- (void)transactionBaseMapping:(FEMManagedObjectMapping *)mapping
{
    [mapping addAttributesFromArray:@[@"start_balance", @"closing_balance"]];
    
    [mapping addRelationshipMapping:[self venueMappingWithoutNews] forProperty:@"venue" keyPath:@"venue"];
    [mapping addRelationshipMapping:[self simpleUserMapping] forProperty:@"user" keyPath:@"user"];
}

- (FEMManagedObjectMapping *)earnMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMEarnTransaction" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf transactionBaseMapping:mapping];
        
        [mapping addAttributesFromArray:@[@"transaction_type", @"amount_saved", @"bill_amount", @"bill_image", @"state", @"points_earned", @"earn_type", @"rejection_reason", @"loyalty_description"]];
    }];
}

- (FEMManagedObjectMapping *)redeemMapping
{
    __weak typeof(self) weakSelf = self;
    return [FEMManagedObjectMapping mappingForEntityName:@"DMRedeemTransaction" configuration:^(FEMManagedObjectMapping *mapping) {
        
        [weakSelf baseMapping:mapping];
        
        [weakSelf transactionBaseMapping:mapping];
        
        [mapping addRelationshipMapping:[self simpleOfferMapping] forProperty:@"offer" keyPath:@"offer"];
        
        [mapping addAttributesFromArray:@[@"transaction_type", @"discount_as_percentage", @"points_redeemed"]];
    }];
}

@end
