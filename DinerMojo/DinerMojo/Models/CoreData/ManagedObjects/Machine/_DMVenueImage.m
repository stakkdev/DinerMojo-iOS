// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenueImage.m instead.

#import "_DMVenueImage.h"


const struct DMVenueImageAttributes DMVenueImageAttributes = {
	.image = @"image",
	.image_description = @"image_description",
	.name = @"name",
	.thumb = @"thumb",
};



const struct DMVenueImageRelationships DMVenueImageRelationships = {
	.venue = @"venue",
	.venue_primary = @"venue_primary",
};






@implementation DMVenueImageID
@end

@implementation _DMVenueImage

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMVenueImage" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMVenueImage";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMVenueImage" inManagedObjectContext:moc_];
}

- (DMVenueImageID*)objectID {
	return (DMVenueImageID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic image;






@dynamic image_description;






@dynamic name;






@dynamic thumb;






@dynamic venue;

	

@dynamic venue_primary;

	






@end




