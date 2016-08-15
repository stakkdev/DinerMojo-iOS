// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMBase.m instead.

#import "_DMBase.h"


const struct DMBaseAttributes DMBaseAttributes = {
	.created_at = @"created_at",
	.modelID = @"modelID",
	.updated_at = @"updated_at",
};








@implementation DMBaseID
@end

@implementation _DMBase

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMBase" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMBase";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMBase" inManagedObjectContext:moc_];
}

- (DMBaseID*)objectID {
	return (DMBaseID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"modelIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"modelID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic created_at;






@dynamic modelID;



- (int32_t)modelIDValue {
	NSNumber *result = [self modelID];
	return [result intValue];
}


- (void)setModelIDValue:(int32_t)value_ {
	[self setModelID:@(value_)];
}


- (int32_t)primitiveModelIDValue {
	NSNumber *result = [self primitiveModelID];
	return [result intValue];
}

- (void)setPrimitiveModelIDValue:(int32_t)value_ {
	[self setPrimitiveModelID:@(value_)];
}





@dynamic updated_at;











@end




