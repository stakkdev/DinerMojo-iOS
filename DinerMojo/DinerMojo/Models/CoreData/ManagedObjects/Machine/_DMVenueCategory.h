// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenueCategory.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"

extern const struct DMVenueCategoryAttributes {
	__unsafe_unretained NSString *name;
} DMVenueCategoryAttributes;

extern const struct DMVenueCategoryRelationships {
	__unsafe_unretained NSString *venue;
} DMVenueCategoryRelationships;

@class DMVenue;

@interface DMVenueCategoryID : DMBaseID {}
@end

@interface _DMVenueCategory : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMVenueCategoryID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *venue;

- (NSMutableSet*)venueSet;

@end

@interface _DMVenueCategory (VenueCoreDataGeneratedAccessors)
- (void)addVenue:(NSSet*)value_;
- (void)removeVenue:(NSSet*)value_;
- (void)addVenueObject:(DMVenue*)value_;
- (void)removeVenueObject:(DMVenue*)value_;

@end

@interface _DMVenueCategory (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSMutableSet*)primitiveVenue;
- (void)setPrimitiveVenue:(NSMutableSet*)value;

@end
