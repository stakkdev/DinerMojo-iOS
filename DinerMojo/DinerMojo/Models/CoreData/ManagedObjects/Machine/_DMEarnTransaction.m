// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMEarnTransaction.m instead.

#import "_DMEarnTransaction.h"


const struct DMEarnTransactionAttributes DMEarnTransactionAttributes = {
	.amount_saved = @"amount_saved",
	.bill_amount = @"bill_amount",
	.bill_image = @"bill_image",
	.earn_type = @"earn_type",
	.loyalty_description = @"loyalty_description",
	.points_earned = @"points_earned",
	.rejection_reason = @"rejection_reason",
	.state = @"state",
	.transaction_type = @"transaction_type",
};








@implementation DMEarnTransactionID
@end

@implementation _DMEarnTransaction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMEarnTransaction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMEarnTransaction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMEarnTransaction" inManagedObjectContext:moc_];
}

- (DMEarnTransactionID*)objectID {
	return (DMEarnTransactionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"amount_savedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"amount_saved"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"bill_amountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"bill_amount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"earn_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"earn_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"points_earnedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"points_earned"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"stateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"state"];
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




@dynamic amount_saved;



- (float)amount_savedValue {
	NSNumber *result = [self amount_saved];
	return [result floatValue];
}


- (void)setAmount_savedValue:(float)value_ {
	[self setAmount_saved:@(value_)];
}


- (float)primitiveAmount_savedValue {
	NSNumber *result = [self primitiveAmount_saved];
	return [result floatValue];
}

- (void)setPrimitiveAmount_savedValue:(float)value_ {
	[self setPrimitiveAmount_saved:@(value_)];
}





@dynamic bill_amount;



- (float)bill_amountValue {
	NSNumber *result = [self bill_amount];
	return [result floatValue];
}


- (void)setBill_amountValue:(float)value_ {
	[self setBill_amount:@(value_)];
}


- (float)primitiveBill_amountValue {
	NSNumber *result = [self primitiveBill_amount];
	return [result floatValue];
}

- (void)setPrimitiveBill_amountValue:(float)value_ {
	[self setPrimitiveBill_amount:@(value_)];
}





@dynamic bill_image;






@dynamic earn_type;



- (int16_t)earn_typeValue {
	NSNumber *result = [self earn_type];
	return [result shortValue];
}


- (void)setEarn_typeValue:(int16_t)value_ {
	[self setEarn_type:@(value_)];
}


- (int16_t)primitiveEarn_typeValue {
	NSNumber *result = [self primitiveEarn_type];
	return [result shortValue];
}

- (void)setPrimitiveEarn_typeValue:(int16_t)value_ {
	[self setPrimitiveEarn_type:@(value_)];
}





@dynamic loyalty_description;






@dynamic points_earned;



- (int16_t)points_earnedValue {
	NSNumber *result = [self points_earned];
	return [result shortValue];
}


- (void)setPoints_earnedValue:(int16_t)value_ {
	[self setPoints_earned:@(value_)];
}


- (int16_t)primitivePoints_earnedValue {
	NSNumber *result = [self primitivePoints_earned];
	return [result shortValue];
}

- (void)setPrimitivePoints_earnedValue:(int16_t)value_ {
	[self setPrimitivePoints_earned:@(value_)];
}





@dynamic rejection_reason;






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










@end




