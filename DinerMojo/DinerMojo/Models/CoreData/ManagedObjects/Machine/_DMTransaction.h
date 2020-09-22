// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMTransaction.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"

extern const struct DMTransactionAttributes {
	__unsafe_unretained NSString *closing_balance;
	__unsafe_unretained NSString *start_balance;
} DMTransactionAttributes;

extern const struct DMTransactionRelationships {
	__unsafe_unretained NSString *user;
	__unsafe_unretained NSString *venue;
} DMTransactionRelationships;

@class DMUser;
@class DMVenue;

@interface DMTransactionID : DMBaseID {}
@end

@interface _DMTransaction : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMTransactionID* objectID;

@property (nonatomic, strong) NSNumber* closing_balance;

@property (atomic) int16_t closing_balanceValue;
- (int16_t)closing_balanceValue;
- (void)setClosing_balanceValue:(int16_t)value_;

//- (BOOL)validateClosing_balance:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* start_balance;

@property (atomic) int16_t start_balanceValue;
- (int16_t)start_balanceValue;
- (void)setStart_balanceValue:(int16_t)value_;

//- (BOOL)validateStart_balance:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMUser *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMVenue *venue;

//- (BOOL)validateVenue:(id*)value_ error:(NSError**)error_;

@end

@interface _DMTransaction (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveClosing_balance;
- (void)setPrimitiveClosing_balance:(NSNumber*)value;

- (int16_t)primitiveClosing_balanceValue;
- (void)setPrimitiveClosing_balanceValue:(int16_t)value_;

- (NSNumber*)primitiveStart_balance;
- (void)setPrimitiveStart_balance:(NSNumber*)value;

- (int16_t)primitiveStart_balanceValue;
- (void)setPrimitiveStart_balanceValue:(int16_t)value_;

- (DMUser*)primitiveUser;
- (void)setPrimitiveUser:(DMUser*)value;

- (DMVenue*)primitiveVenue;
- (void)setPrimitiveVenue:(DMVenue*)value;

@end
