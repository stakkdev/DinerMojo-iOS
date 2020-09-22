// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMNewsItem.h instead.

#import <CoreData/CoreData.h>
#import "DMUpdateItem.h"

extern const struct DMNewsItemAttributes {
	__unsafe_unretained NSString *update_type;
} DMNewsItemAttributes;

@interface DMNewsItemID : DMUpdateItemID {}
@end

@interface _DMNewsItem : DMUpdateItem {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMNewsItemID* objectID;

@property (nonatomic, strong) NSNumber* update_type;

@property BOOL isRead;

@property (atomic) int16_t update_typeValue;
- (int16_t)update_typeValue;
- (void)setUpdate_typeValue:(int16_t)value_;

//- (BOOL)validateUpdate_type:(id*)value_ error:(NSError**)error_;

@end

@interface _DMNewsItem (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveUpdate_type;
- (void)setPrimitiveUpdate_type:(NSNumber*)value;

- (int16_t)primitiveUpdate_typeValue;
- (void)setPrimitiveUpdate_typeValue:(int16_t)value_;

@end
