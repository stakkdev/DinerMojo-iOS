// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMTransaction.m instead.

#import "_DMTransaction.h"

const struct DMTransactionAttributes DMTransactionAttributes = {
	.closing_balance = @"closing_balance",
	.start_balance = @"start_balance",
};

const struct DMTransactionRelationships DMTransactionRelationships = {
	.user = @"user",
	.venue = @"venue",
};

@implementation DMTransactionID
@end

@implementation _DMTransaction

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMTransaction" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMTransaction";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMTransaction" inManagedObjectContext:moc_];
}

- (DMTransactionID*)objectID {
	return (DMTransactionID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"closing_balanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"closing_balance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"start_balanceValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"start_balance"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic closing_balance;

- (int16_t)closing_balanceValue {
	NSNumber *result = [self closing_balance];
	return [result shortValue];
}

- (void)setClosing_balanceValue:(int16_t)value_ {
	[self setClosing_balance:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveClosing_balanceValue {
	NSNumber *result = [self primitiveClosing_balance];
	return [result shortValue];
}

- (void)setPrimitiveClosing_balanceValue:(int16_t)value_ {
	[self setPrimitiveClosing_balance:[NSNumber numberWithShort:value_]];
}

@dynamic start_balance;

- (int16_t)start_balanceValue {
	NSNumber *result = [self start_balance];
	return [result shortValue];
}

- (void)setStart_balanceValue:(int16_t)value_ {
	[self setStart_balance:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveStart_balanceValue {
	NSNumber *result = [self primitiveStart_balance];
	return [result shortValue];
}

- (void)setPrimitiveStart_balanceValue:(int16_t)value_ {
	[self setPrimitiveStart_balance:[NSNumber numberWithShort:value_]];
}

@dynamic user;

@dynamic venue;

@end

