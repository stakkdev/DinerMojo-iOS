// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenueOpeningTimes.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"



extern const struct DMVenueOpeningTimesAttributes {
	__unsafe_unretained NSString *friday;
	__unsafe_unretained NSString *monday;
	__unsafe_unretained NSString *saturday;
	__unsafe_unretained NSString *sunday;
	__unsafe_unretained NSString *thursday;
	__unsafe_unretained NSString *tuesday;
	__unsafe_unretained NSString *wednesday;
} DMVenueOpeningTimesAttributes;



extern const struct DMVenueOpeningTimesRelationships {
	__unsafe_unretained NSString *venue;
} DMVenueOpeningTimesRelationships;






@class DMVenue;
















@interface DMVenueOpeningTimesID : DMBaseID {}
@end

@interface _DMVenueOpeningTimes : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DMVenueOpeningTimesID*)objectID;





@property (nonatomic, strong) NSString* friday;



//- (BOOL)validateFriday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* monday;



//- (BOOL)validateMonday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* saturday;



//- (BOOL)validateSaturday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* sunday;



//- (BOOL)validateSunday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* thursday;



//- (BOOL)validateThursday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* tuesday;



//- (BOOL)validateTuesday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* wednesday;



//- (BOOL)validateWednesday:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) DMVenue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;





@end



@interface _DMVenueOpeningTimes (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveFriday;
- (void)setPrimitiveFriday:(NSString*)value;




- (NSString*)primitiveMonday;
- (void)setPrimitiveMonday:(NSString*)value;




- (NSString*)primitiveSaturday;
- (void)setPrimitiveSaturday:(NSString*)value;




- (NSString*)primitiveSunday;
- (void)setPrimitiveSunday:(NSString*)value;




- (NSString*)primitiveThursday;
- (void)setPrimitiveThursday:(NSString*)value;




- (NSString*)primitiveTuesday;
- (void)setPrimitiveTuesday:(NSString*)value;




- (NSString*)primitiveWednesday;
- (void)setPrimitiveWednesday:(NSString*)value;





- (DMVenue*)primitiveVenue;
- (void)setPrimitiveVenue:(DMVenue*)value;


@end
