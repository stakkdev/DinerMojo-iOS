// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMUpdateItem.m instead.

#import "_DMUpdateItem.h"

const struct DMUpdateItemAttributes DMUpdateItemAttributes = {
	.expiry_date = @"expiry_date",
	.image = @"image",
	.news_description = @"news_description",
	.thumb = @"thumb",
	.title = @"title",
};

const struct DMUpdateItemRelationships DMUpdateItemRelationships = {
	.venue = @"venue",
};

@implementation DMUpdateItemID
@end

@implementation _DMUpdateItem

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMUpdateItem" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMUpdateItem";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMUpdateItem" inManagedObjectContext:moc_];
}

- (DMUpdateItemID*)objectID {
	return (DMUpdateItemID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic expiry_date;

@dynamic image;

@dynamic news_description;

@dynamic thumb;

@dynamic title;

@dynamic venue;

@end

