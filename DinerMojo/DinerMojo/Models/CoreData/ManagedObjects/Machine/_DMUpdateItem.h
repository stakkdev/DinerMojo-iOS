// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMUpdateItem.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"

extern const struct DMUpdateItemAttributes {
	__unsafe_unretained NSString *expiry_date;
	__unsafe_unretained NSString *image;
	__unsafe_unretained NSString *news_description;
	__unsafe_unretained NSString *thumb;
	__unsafe_unretained NSString *title;
} DMUpdateItemAttributes;

extern const struct DMUpdateItemRelationships {
	__unsafe_unretained NSString *venue;
} DMUpdateItemRelationships;

@class DMVenue;

@interface DMUpdateItemID : DMBaseID {}
@end

@interface _DMUpdateItem : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMUpdateItemID* objectID;

@property (nonatomic, strong) NSDate* expiry_date;

//- (BOOL)validateExpiry_date:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* image;

//- (BOOL)validateImage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* news_description;

//- (BOOL)validateNews_description:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* thumb;

//- (BOOL)validateThumb:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMVenue *venue;

@property (nonatomic, strong) DMVenue *add;


//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;

@end

@interface _DMUpdateItem (CoreDataGeneratedPrimitiveAccessors)

- (NSDate*)primitiveExpiry_date;
- (void)setPrimitiveExpiry_date:(NSDate*)value;

- (NSString*)primitiveImage;
- (void)setPrimitiveImage:(NSString*)value;

- (NSString*)primitiveNews_description;
- (void)setPrimitiveNews_description:(NSString*)value;

- (NSString*)primitiveThumb;
- (void)setPrimitiveThumb:(NSString*)value;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (DMVenue*)primitiveVenue;
- (void)setPrimitiveVenue:(DMVenue*)value;

@end
