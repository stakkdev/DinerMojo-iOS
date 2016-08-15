// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMBase.h instead.

#import <CoreData/CoreData.h>



extern const struct DMBaseAttributes {
	__unsafe_unretained NSString *created_at;
	__unsafe_unretained NSString *modelID;
	__unsafe_unretained NSString *updated_at;
} DMBaseAttributes;
















@interface DMBaseID : NSManagedObjectID {}
@end

@interface _DMBase : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DMBaseID*)objectID;





@property (nonatomic, strong) NSDate* created_at;



//- (BOOL)validateCreated_at:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* modelID;




@property (atomic) int32_t modelIDValue;
- (int32_t)modelIDValue;
- (void)setModelIDValue:(int32_t)value_;


//- (BOOL)validateModelID:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* updated_at;



//- (BOOL)validateUpdated_at:(id*)value_ error:(NSError**)error_;






@end



@interface _DMBase (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCreated_at;
- (void)setPrimitiveCreated_at:(NSDate*)value;




- (NSNumber*)primitiveModelID;
- (void)setPrimitiveModelID:(NSNumber*)value;

- (int32_t)primitiveModelIDValue;
- (void)setPrimitiveModelIDValue:(int32_t)value_;




- (NSDate*)primitiveUpdated_at;
- (void)setPrimitiveUpdated_at:(NSDate*)value;




@end
