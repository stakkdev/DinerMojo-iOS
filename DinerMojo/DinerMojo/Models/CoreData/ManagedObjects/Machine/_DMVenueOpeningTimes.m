// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenueOpeningTimes.m instead.

#import "_DMVenueOpeningTimes.h"

const struct DMVenueOpeningTimesAttributes DMVenueOpeningTimesAttributes = {
	.friday = @"friday",
	.monday = @"monday",
	.saturday = @"saturday",
	.sunday = @"sunday",
	.thursday = @"thursday",
	.tuesday = @"tuesday",
	.wednesday = @"wednesday",
};

const struct DMVenueOpeningTimesRelationships DMVenueOpeningTimesRelationships = {
	.venue = @"venue",
};

@implementation DMVenueOpeningTimesID
@end

@implementation _DMVenueOpeningTimes

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"DMVenueOpeningTimes" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"DMVenueOpeningTimes";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"DMVenueOpeningTimes" inManagedObjectContext:moc_];
}

- (DMVenueOpeningTimesID*)objectID {
	return (DMVenueOpeningTimesID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic friday;

@dynamic monday;

@dynamic saturday;

@dynamic sunday;

@dynamic thursday;

@dynamic tuesday;

@dynamic wednesday;

@dynamic venue;

@end

