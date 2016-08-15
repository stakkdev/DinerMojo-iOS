// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMUser.m instead.

#import "_DMUser.h"


const struct DMUserAttributes DMUserAttributes = {
	.annual_points_balance = @"annual_points_balance",
	.annual_points_earned = @"annual_points_earned",
	.date_of_birth = @"date_of_birth",
	.email_address = @"email_address",
	.facebook_id = @"facebook_id",
	.first_name = @"first_name",
	.gender = @"gender",
	.is_email_verified = @"is_email_verified",
	.last_name = @"last_name",
	.local_account = @"local_account",
	.notification_filter = @"notification_filter",
	.notification_frequency = @"notification_frequency",
	.post_code = @"post_code",
	.profile_picture = @"profile_picture",
	.referred_points = @"referred_points",
};



const struct DMUserRelationships DMUserRelationships = {
	.favourite_venues = @"favourite_venues",
	.transactions = @"transactions",
};






@implementation DMUserID
@end

@implementation _DMUser

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMUser" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMUser";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMUser" inManagedObjectContext:moc_];
}

- (DMUserID*)objectID {
	return (DMUserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"annual_points_balanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"annual_points_balance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"annual_points_earnedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"annual_points_earned"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"genderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"gender"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_email_verifiedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_email_verified"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"local_accountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"local_account"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"notification_filterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"notification_filter"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"notification_frequencyValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"notification_frequency"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"referred_pointsValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"referred_points"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic annual_points_balance;



- (int16_t)annual_points_balanceValue {
	NSNumber *result = [self annual_points_balance];
	return [result shortValue];
}


- (void)setAnnual_points_balanceValue:(int16_t)value_ {
	[self setAnnual_points_balance:@(value_)];
}


- (int16_t)primitiveAnnual_points_balanceValue {
	NSNumber *result = [self primitiveAnnual_points_balance];
	return [result shortValue];
}

- (void)setPrimitiveAnnual_points_balanceValue:(int16_t)value_ {
	[self setPrimitiveAnnual_points_balance:@(value_)];
}





@dynamic annual_points_earned;



- (int16_t)annual_points_earnedValue {
	NSNumber *result = [self annual_points_earned];
	return [result shortValue];
}


- (void)setAnnual_points_earnedValue:(int16_t)value_ {
	[self setAnnual_points_earned:@(value_)];
}


- (int16_t)primitiveAnnual_points_earnedValue {
	NSNumber *result = [self primitiveAnnual_points_earned];
	return [result shortValue];
}

- (void)setPrimitiveAnnual_points_earnedValue:(int16_t)value_ {
	[self setPrimitiveAnnual_points_earned:@(value_)];
}





@dynamic date_of_birth;






@dynamic email_address;






@dynamic facebook_id;






@dynamic first_name;






@dynamic gender;



- (int16_t)genderValue {
	NSNumber *result = [self gender];
	return [result shortValue];
}


- (void)setGenderValue:(int16_t)value_ {
	[self setGender:@(value_)];
}


- (int16_t)primitiveGenderValue {
	NSNumber *result = [self primitiveGender];
	return [result shortValue];
}

- (void)setPrimitiveGenderValue:(int16_t)value_ {
	[self setPrimitiveGender:@(value_)];
}





@dynamic is_email_verified;



- (BOOL)is_email_verifiedValue {
	NSNumber *result = [self is_email_verified];
	return [result boolValue];
}


- (void)setIs_email_verifiedValue:(BOOL)value_ {
	[self setIs_email_verified:@(value_)];
}


- (BOOL)primitiveIs_email_verifiedValue {
	NSNumber *result = [self primitiveIs_email_verified];
	return [result boolValue];
}

- (void)setPrimitiveIs_email_verifiedValue:(BOOL)value_ {
	[self setPrimitiveIs_email_verified:@(value_)];
}





@dynamic last_name;






@dynamic local_account;



- (BOOL)local_accountValue {
	NSNumber *result = [self local_account];
	return [result boolValue];
}


- (void)setLocal_accountValue:(BOOL)value_ {
	[self setLocal_account:@(value_)];
}


- (BOOL)primitiveLocal_accountValue {
	NSNumber *result = [self primitiveLocal_account];
	return [result boolValue];
}

- (void)setPrimitiveLocal_accountValue:(BOOL)value_ {
	[self setPrimitiveLocal_account:@(value_)];
}





@dynamic notification_filter;



- (int16_t)notification_filterValue {
	NSNumber *result = [self notification_filter];
	return [result shortValue];
}


- (void)setNotification_filterValue:(int16_t)value_ {
	[self setNotification_filter:@(value_)];
}


- (int16_t)primitiveNotification_filterValue {
	NSNumber *result = [self primitiveNotification_filter];
	return [result shortValue];
}

- (void)setPrimitiveNotification_filterValue:(int16_t)value_ {
	[self setPrimitiveNotification_filter:@(value_)];
}





@dynamic notification_frequency;



- (int16_t)notification_frequencyValue {
	NSNumber *result = [self notification_frequency];
	return [result shortValue];
}


- (void)setNotification_frequencyValue:(int16_t)value_ {
	[self setNotification_frequency:@(value_)];
}


- (int16_t)primitiveNotification_frequencyValue {
	NSNumber *result = [self primitiveNotification_frequency];
	return [result shortValue];
}

- (void)setPrimitiveNotification_frequencyValue:(int16_t)value_ {
	[self setPrimitiveNotification_frequency:@(value_)];
}





@dynamic post_code;






@dynamic profile_picture;






@dynamic referred_points;



- (int16_t)referred_pointsValue {
	NSNumber *result = [self referred_points];
	return [result shortValue];
}


- (void)setReferred_pointsValue:(int16_t)value_ {
	[self setReferred_points:@(value_)];
}


- (int16_t)primitiveReferred_pointsValue {
	NSNumber *result = [self primitiveReferred_points];
	return [result shortValue];
}

- (void)setPrimitiveReferred_pointsValue:(int16_t)value_ {
	[self setPrimitiveReferred_points:@(value_)];
}





@dynamic favourite_venues;

	
- (NSMutableSet*)favourite_venuesSet {
	[self willAccessValueForKey:@"favourite_venues"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"favourite_venues"];
  
	[self didAccessValueForKey:@"favourite_venues"];
	return result;
}
	

@dynamic transactions;

	
- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];
  
	[self didAccessValueForKey:@"transactions"];
	return result;
}
	






@end




