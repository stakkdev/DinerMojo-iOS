// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenueImage.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"

extern const struct DMVenueImageAttributes {
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *image_description;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *thumb;
} DMVenueImageAttributes;

extern const struct DMVenueImageRelationships {
	__unsafe_unretained NSString *venue;
	__unsafe_unretained NSString *venue_primary;
} DMVenueImageRelationships;

@class DMVenue;
@class DMVenue;

@interface DMVenueImageID : DMBaseID {}
@end

@interface _DMVenueImage : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMVenueImageID* objectID;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image_description;

//- (BOOL)validateImage_description:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* thumb;

//- (BOOL)validateThumb:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMVenue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMVenue *venue_primary;

//- (BOOL)validateVenue_primary:(id*)value_ error:(NSError**)error_;

@end

@interface _DMVenueImage (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveImage_description;
- (void)setPrimitiveImage_description:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitiveThumb;
- (void)setPrimitiveThumb:(NSString*)value;

- (DMVenue*)primitiveVenue;
- (void)setPrimitiveVenue:(DMVenue*)value;

- (DMVenue*)primitiveVenue_primary;
- (void)setPrimitiveVenue_primary:(DMVenue*)value;

@end
