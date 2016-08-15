// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenueCategory.m instead.

#import "_DMVenueCategory.h"


const struct DMVenueCategoryAttributes DMVenueCategoryAttributes = {
	.name = @"name",
};



const struct DMVenueCategoryRelationships DMVenueCategoryRelationships = {
	.venue = @"venue",
};






@implementation DMVenueCategoryID
@end

@implementation _DMVenueCategory

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMVenueCategory" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMVenueCategory";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMVenueCategory" inManagedObjectContext:moc_];
}

- (DMVenueCategoryID*)objectID {
	return (DMVenueCategoryID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic venue;

	
- (NSMutableSet*)venueSet {
	[self willAccessValueForKey:@"venue"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"venue"];
  
	[self didAccessValueForKey:@"venue"];
	return result;
}
	






@end




