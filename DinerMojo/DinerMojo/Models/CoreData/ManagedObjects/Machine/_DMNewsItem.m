// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMNewsItem.m instead.

#import "_DMNewsItem.h"

const struct DMNewsItemAttributes DMNewsItemAttributes = {
	.update_type = @"update_type",
};

@implementation DMNewsItemID
@end

@implementation _DMNewsItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMNewsItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMNewsItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMNewsItem" inManagedObjectContext:moc_];
}

- (DMNewsItemID*)objectID {
	return (DMNewsItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"update_typeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"update_type"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

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

@end

