// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenue.m instead.

#import "_DMVenue.h"

const struct DMVenueAttributes DMVenueAttributes = {
	.allows_earns = @"allows_earns",
    .booking_available = @"booking_available",
	.allows_redemptions = @"allows_redemptions",
	.area = @"area",
	.created_on = @"created_on",
	.email_address = @"email_address",
	.has_news = @"has_news",
	.has_offers = @"has_offers",
	.house_number_street_name = @"house_number_street_name",
	.in_wishlist = @"in_wishlist",
	.latitude = @"latitude",
	.longitude = @"longitude",
	.menu_url = @"menu_url",
	.name = @"name",
	.open_now = @"open_now",
	.phone_number = @"phone_number",
	.post_code = @"post_code",
	.price_bracket = @"price_bracket",
    .booking_url = @"booking_url",
	.state = @"state",
	.town = @"town",
	.trip_advisor_link = @"trip_advisor_link",
	.user_last_viewed = @"user_last_viewed",
    .last_redeem = @"last_redeem",
    .last_redeem_name = @"last_redeem_name",
	.venue_description = @"venue_description",
	.venue_type = @"venue_type",
	.web_address = @"web_address",
};

const struct DMVenueRelationships DMVenueRelationships = {
	.categories = @"categories",
	.favourite = @"favourite",
	.images = @"images",
	.opening_times = @"opening_times",
	.primary_image = @"primary_image",
	.transactions = @"transactions",
	.updates = @"updates",
};

const struct DMVenueUserInfo DMVenueUserInfo = {
	.relatedByAttribute = @"modelID",
};

@implementation DMVenueID
@end

@implementation _DMVenue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMVenue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMVenue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMVenue" inManagedObjectContext:moc_];
}

- (DMVenueID*)objectID {
	return (DMVenueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"allows_earnsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"allows_earns"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
    if ([key isEqualToString:@"booking_availableValue"]) {
        NSSet *affectingKey = [NSSet setWithObject:@"booking_available"];
        keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
        return keyPaths;
    }
	if ([key isEqualToString:@"allows_redemptionsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"allows_redemptions"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"has_newsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"has_news"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"has_offersValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"has_offers"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"in_wishlistValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"in_wishlist"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"latitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"latitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"longitudeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"longitude"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"open_nowValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"open_now"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"price_bracketValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"price_bracket"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"state"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic allows_earns;

- (BOOL)allows_earnsValue {
	NSNumber *result = [self allows_earns];
	return [result boolValue];
}

- (void)setAllows_earnsValue:(BOOL)value_ {
	[self setAllows_earns:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAllows_earnsValue {
	NSNumber *result = [self primitiveAllows_earns];
	return [result boolValue];
}

- (void)setPrimitiveAllows_earnsValue:(BOOL)value_ {
	[self setPrimitiveAllows_earns:[NSNumber numberWithBool:value_]];
}


@dynamic booking_available;

- (BOOL)booking_availableValue {
    NSNumber *result = [self booking_available];
    return [result boolValue];
}

- (void)setBooking_availableValue:(BOOL)value_ {
    [self setBooking_available:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveBooking_availableValue {
    NSNumber *result = [self primitiveBooking_available];
    return [result boolValue];
}

- (void)setPrimitiveBooking_availableValue:(BOOL)value_ {
    [self setPrimitiveBooking_available:[NSNumber numberWithBool:value_]];
}


@dynamic allows_redemptions;

- (BOOL)allows_redemptionsValue {
	NSNumber *result = [self allows_redemptions];
	return [result boolValue];
}

- (void)setAllows_redemptionsValue:(BOOL)value_ {
	[self setAllows_redemptions:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAllows_redemptionsValue {
	NSNumber *result = [self primitiveAllows_redemptions];
	return [result boolValue];
}

- (void)setPrimitiveAllows_redemptionsValue:(BOOL)value_ {
	[self setPrimitiveAllows_redemptions:[NSNumber numberWithBool:value_]];
}

@dynamic area;

@dynamic created_on;

@dynamic email_address;

@dynamic has_news;

- (BOOL)has_newsValue {
	NSNumber *result = [self has_news];
	return [result boolValue];
}

- (void)setHas_newsValue:(BOOL)value_ {
	[self setHas_news:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHas_newsValue {
	NSNumber *result = [self primitiveHas_news];
	return [result boolValue];
}

- (void)setPrimitiveHas_newsValue:(BOOL)value_ {
	[self setPrimitiveHas_news:[NSNumber numberWithBool:value_]];
}

@dynamic has_offers;

- (BOOL)has_offersValue {
	NSNumber *result = [self has_offers];
	return [result boolValue];
}

- (void)setHas_offersValue:(BOOL)value_ {
	[self setHas_offers:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHas_offersValue {
	NSNumber *result = [self primitiveHas_offers];
	return [result boolValue];
}

- (void)setPrimitiveHas_offersValue:(BOOL)value_ {
	[self setPrimitiveHas_offers:[NSNumber numberWithBool:value_]];
}

@dynamic house_number_street_name;

@dynamic in_wishlist;

- (BOOL)in_wishlistValue {
	NSNumber *result = [self in_wishlist];
	return [result boolValue];
}

- (void)setIn_wishlistValue:(BOOL)value_ {
	[self setIn_wishlist:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIn_wishlistValue {
	NSNumber *result = [self primitiveIn_wishlist];
	return [result boolValue];
}

- (void)setPrimitiveIn_wishlistValue:(BOOL)value_ {
	[self setPrimitiveIn_wishlist:[NSNumber numberWithBool:value_]];
}

@dynamic latitude;

- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}

- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:[NSNumber numberWithFloat:value_]];
}

@dynamic longitude;

- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}

- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:[NSNumber numberWithFloat:value_]];
}

@dynamic menu_url;

@dynamic booking_url;

@dynamic name;

@dynamic open_now;

- (int16_t)open_nowValue {
	NSNumber *result = [self open_now];
	return [result shortValue];
}

- (void)setOpen_nowValue:(int16_t)value_ {
	[self setOpen_now:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveOpen_nowValue {
	NSNumber *result = [self primitiveOpen_now];
	return [result shortValue];
}

- (void)setPrimitiveOpen_nowValue:(int16_t)value_ {
	[self setPrimitiveOpen_now:[NSNumber numberWithShort:value_]];
}

@dynamic phone_number;

@dynamic post_code;

@dynamic price_bracket;

- (int16_t)price_bracketValue {
	NSNumber *result = [self price_bracket];
	return [result shortValue];
}

- (void)setPrice_bracketValue:(int16_t)value_ {
	[self setPrice_bracket:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePrice_bracketValue {
	NSNumber *result = [self primitivePrice_bracket];
	return [result shortValue];
}

- (void)setPrimitivePrice_bracketValue:(int16_t)value_ {
	[self setPrimitivePrice_bracket:[NSNumber numberWithShort:value_]];
}

@dynamic state;

- (int16_t)stateValue {
	NSNumber *result = [self state];
	return [result shortValue];
}

- (void)setStateValue:(int16_t)value_ {
	[self setState:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStateValue {
	NSNumber *result = [self primitiveState];
	return [result shortValue];
}

- (void)setPrimitiveStateValue:(int16_t)value_ {
	[self setPrimitiveState:[NSNumber numberWithShort:value_]];
}

@dynamic town;

@dynamic trip_advisor_link;

@dynamic user_last_viewed;
    
@dynamic last_redeem;

@dynamic last_redeem_name;

@dynamic venue_description;

@dynamic venue_type;

@dynamic web_address;

@dynamic categories;

- (NSMutableSet*)categoriesSet {
	[self willAccessValueForKey:@"categories"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"categories"];

	[self didAccessValueForKey:@"categories"];
	return result;
}

@dynamic favourite;

@dynamic images;

- (NSMutableSet*)imagesSet {
	[self willAccessValueForKey:@"images"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"images"];

	[self didAccessValueForKey:@"images"];
	return result;
}

@dynamic opening_times;

@dynamic primary_image;

@dynamic transactions;

- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];

	[self didAccessValueForKey:@"transactions"];
	return result;
}

@dynamic updates;

- (NSMutableSet*)updatesSet {
	[self willAccessValueForKey:@"updates"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"updates"];

	[self didAccessValueForKey:@"updates"];
	return result;
}

@end

