// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenue.m instead.

#import "_DMVenue.h"


const struct DMVenueAttributes DMVenueAttributes = {
	.area = @"area",
	.email_address = @"email_address",
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
	.state = @"state",
	.town = @"town",
	.trip_advisor_link = @"trip_advisor_link",
	.user_last_viewed = @"user_last_viewed",
	.venue_description = @"venue_description",
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




@dynamic area;






@dynamic email_address;






@dynamic house_number_street_name;






@dynamic in_wishlist;



- (BOOL)in_wishlistValue {
	NSNumber *result = [self in_wishlist];
	return [result boolValue];
}


- (void)setIn_wishlistValue:(BOOL)value_ {
	[self setIn_wishlist:@(value_)];
}


- (BOOL)primitiveIn_wishlistValue {
	NSNumber *result = [self primitiveIn_wishlist];
	return [result boolValue];
}

- (void)setPrimitiveIn_wishlistValue:(BOOL)value_ {
	[self setPrimitiveIn_wishlist:@(value_)];
}





@dynamic latitude;



- (float)latitudeValue {
	NSNumber *result = [self latitude];
	return [result floatValue];
}


- (void)setLatitudeValue:(float)value_ {
	[self setLatitude:@(value_)];
}


- (float)primitiveLatitudeValue {
	NSNumber *result = [self primitiveLatitude];
	return [result floatValue];
}

- (void)setPrimitiveLatitudeValue:(float)value_ {
	[self setPrimitiveLatitude:@(value_)];
}





@dynamic longitude;



- (float)longitudeValue {
	NSNumber *result = [self longitude];
	return [result floatValue];
}


- (void)setLongitudeValue:(float)value_ {
	[self setLongitude:@(value_)];
}


- (float)primitiveLongitudeValue {
	NSNumber *result = [self primitiveLongitude];
	return [result floatValue];
}

- (void)setPrimitiveLongitudeValue:(float)value_ {
	[self setPrimitiveLongitude:@(value_)];
}





@dynamic menu_url;






@dynamic name;






@dynamic open_now;



- (int16_t)open_nowValue {
	NSNumber *result = [self open_now];
	return [result shortValue];
}


- (void)setOpen_nowValue:(int16_t)value_ {
	[self setOpen_now:@(value_)];
}


- (int16_t)primitiveOpen_nowValue {
	NSNumber *result = [self primitiveOpen_now];
	return [result shortValue];
}

- (void)setPrimitiveOpen_nowValue:(int16_t)value_ {
	[self setPrimitiveOpen_now:@(value_)];
}





@dynamic phone_number;






@dynamic post_code;






@dynamic price_bracket;



- (int16_t)price_bracketValue {
	NSNumber *result = [self price_bracket];
	return [result shortValue];
}


- (void)setPrice_bracketValue:(int16_t)value_ {
	[self setPrice_bracket:@(value_)];
}


- (int16_t)primitivePrice_bracketValue {
	NSNumber *result = [self primitivePrice_bracket];
	return [result shortValue];
}

- (void)setPrimitivePrice_bracketValue:(int16_t)value_ {
	[self setPrimitivePrice_bracket:@(value_)];
}





@dynamic state;



- (int16_t)stateValue {
	NSNumber *result = [self state];
	return [result shortValue];
}


- (void)setStateValue:(int16_t)value_ {
	[self setState:@(value_)];
}


- (int16_t)primitiveStateValue {
	NSNumber *result = [self primitiveState];
	return [result shortValue];
}

- (void)setPrimitiveStateValue:(int16_t)value_ {
	[self setPrimitiveState:@(value_)];
}





@dynamic town;






@dynamic trip_advisor_link;






@dynamic user_last_viewed;






@dynamic venue_description;






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




