// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMOfferItem.m instead.

#import "_DMOfferItem.h"

const struct DMOfferItemAttributes DMOfferItemAttributes = {
	.discount = @"discount",
	.is_birthday_offer = @"is_birthday_offer",
	.is_special_offer = @"is_special_offer",
	.points_required = @"points_required",
    .allowed_mojo_levels = @"allowed_mojo_levels",
    .days_available = @"days_available",
    .is_prodigal_reward = @"is_prodigal_reward",
    .monetary_value = @"monetary_value",
	.start_date = @"start_date",
	.terms_conditions = @"terms_conditions",
	.update_type = @"update_type",
    .additional_payload = @"additional_payload",
};

const struct DMOfferItemRelationships DMOfferItemRelationships = {
	.transactions = @"transactions",
};

@implementation DMOfferItemID
@end

@implementation _DMOfferItem
@synthesize allowed_mojo_levels, days_available, is_prodigal_reward, isRead, monetary_value,additional_payload;

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMOfferItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMOfferItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMOfferItem" inManagedObjectContext:moc_];
}

- (DMOfferItemID*)objectID {
	return (DMOfferItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"discountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"discount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_birthday_offerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_birthday_offer"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"is_special_offerValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"is_special_offer"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"points_requiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"points_required"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"update_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"update_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic discount;

- (float)discountValue {
	NSNumber *result = [self discount];
	return [result floatValue];
}

- (void)setDiscountValue:(float)value_ {
	[self setDiscount:[NSNumber numberWithFloat:value_]];
}

- (float)primitiveDiscountValue {
	NSNumber *result = [self primitiveDiscount];
	return [result floatValue];
}

- (void)setPrimitiveDiscountValue:(float)value_ {
	[self setPrimitiveDiscount:[NSNumber numberWithFloat:value_]];
}

@dynamic is_birthday_offer;

- (BOOL)is_birthday_offerValue {
	NSNumber *result = [self is_birthday_offer];
	return [result boolValue];
}

- (void)setIs_birthday_offerValue:(BOOL)value_ {
	[self setIs_birthday_offer:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIs_birthday_offerValue {
	NSNumber *result = [self primitiveIs_birthday_offer];
	return [result boolValue];
}

- (void)setPrimitiveIs_birthday_offerValue:(BOOL)value_ {
	[self setPrimitiveIs_birthday_offer:[NSNumber numberWithBool:value_]];
}

@dynamic is_special_offer;

- (int16_t)is_special_offerValue {
	NSNumber *result = [self is_special_offer];
	return [result shortValue];
}

- (void)setIs_special_offerValue:(int16_t)value_ {
	[self setIs_special_offer:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIs_special_offerValue {
	NSNumber *result = [self primitiveIs_special_offer];
	return [result shortValue];
}

- (void)setPrimitiveIs_special_offerValue:(int16_t)value_ {
	[self setPrimitiveIs_special_offer:[NSNumber numberWithShort:value_]];
}

@dynamic points_required;

- (int16_t)points_requiredValue {
	NSNumber *result = [self points_required];
	return [result shortValue];
}

- (void)setPoints_requiredValue:(int16_t)value_ {
	[self setPoints_required:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitivePoints_requiredValue {
	NSNumber *result = [self primitivePoints_required];
	return [result shortValue];
}

- (void)setPrimitivePoints_requiredValue:(int16_t)value_ {
	[self setPrimitivePoints_required:[NSNumber numberWithShort:value_]];
}

@dynamic start_date;

@dynamic terms_conditions;

@dynamic update_type;

- (int16_t)update_typeValue {
	NSNumber *result = [self update_type];
	return [result shortValue];
}

- (void)setUpdate_typeValue:(int16_t)value_ {
	[self setUpdate_type:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveUpdate_typeValue {
	NSNumber *result = [self primitiveUpdate_type];
	return [result shortValue];
}

- (void)setPrimitiveUpdate_typeValue:(int16_t)value_ {
	[self setPrimitiveUpdate_type:[NSNumber numberWithShort:value_]];
}

@dynamic transactions;

- (NSMutableSet*)transactionsSet {
	[self willAccessValueForKey:@"transactions"];

	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"transactions"];

	[self didAccessValueForKey:@"transactions"];
	return result;
}

@end

