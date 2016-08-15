// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMRedeemTransaction.m instead.

#import "_DMRedeemTransaction.h"


const struct DMRedeemTransactionAttributes DMRedeemTransactionAttributes = {
	.discount_as_percentage = @"discount_as_percentage",
	.points_redeemed = @"points_redeemed",
	.transaction_type = @"transaction_type",
};



const struct DMRedeemTransactionRelationships DMRedeemTransactionRelationships = {
	.offer = @"offer",
};






@implementation DMRedeemTransactionID
@end

@implementation _DMRedeemTransaction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMRedeemTransaction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMRedeemTransaction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMRedeemTransaction" inManagedObjectContext:moc_];
}

- (DMRedeemTransactionID*)objectID {
	return (DMRedeemTransactionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"discount_as_percentageValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"discount_as_percentage"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"points_redeemedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"points_redeemed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"transaction_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"transaction_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic discount_as_percentage;



- (int16_t)discount_as_percentageValue {
	NSNumber *result = [self discount_as_percentage];
	return [result shortValue];
}


- (void)setDiscount_as_percentageValue:(int16_t)value_ {
	[self setDiscount_as_percentage:@(value_)];
}


- (int16_t)primitiveDiscount_as_percentageValue {
	NSNumber *result = [self primitiveDiscount_as_percentage];
	return [result shortValue];
}

- (void)setPrimitiveDiscount_as_percentageValue:(int16_t)value_ {
	[self setPrimitiveDiscount_as_percentage:@(value_)];
}





@dynamic points_redeemed;



- (int16_t)points_redeemedValue {
	NSNumber *result = [self points_redeemed];
	return [result shortValue];
}


- (void)setPoints_redeemedValue:(int16_t)value_ {
	[self setPoints_redeemed:@(value_)];
}


- (int16_t)primitivePoints_redeemedValue {
	NSNumber *result = [self primitivePoints_redeemed];
	return [result shortValue];
}

- (void)setPrimitivePoints_redeemedValue:(int16_t)value_ {
	[self setPrimitivePoints_redeemed:@(value_)];
}





@dynamic transaction_type;



- (int16_t)transaction_typeValue {
	NSNumber *result = [self transaction_type];
	return [result shortValue];
}


- (void)setTransaction_typeValue:(int16_t)value_ {
	[self setTransaction_type:@(value_)];
}


- (int16_t)primitiveTransaction_typeValue {
	NSNumber *result = [self primitiveTransaction_type];
	return [result shortValue];
}

- (void)setPrimitiveTransaction_typeValue:(int16_t)value_ {
	[self setPrimitiveTransaction_type:@(value_)];
}





@dynamic offer;

	






@end




