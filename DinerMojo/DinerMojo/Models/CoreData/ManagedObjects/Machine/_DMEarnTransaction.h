// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMEarnTransaction.h instead.

#import <CoreData/CoreData.h>
#import "DMTransaction.h"



extern const struct DMEarnTransactionAttributes {
	__unsafe_unretained NSString *amount_saved;
	__unsafe_unretained NSString *bill_amount;
	__unsafe_unretained NSString *bill_image;
	__unsafe_unretained NSString *earn_type;
	__unsafe_unretained NSString *loyalty_description;
	__unsafe_unretained NSString *points_earned;
	__unsafe_unretained NSString *rejection_reason;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *transaction_type;
} DMEarnTransactionAttributes;




























@interface DMEarnTransactionID : DMTransactionID {}
@end

@interface _DMEarnTransaction : DMTransaction {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DMEarnTransactionID*)objectID;





@property (nonatomic, strong) NSNumber* amount_saved;




@property (atomic) float amount_savedValue;
- (float)amount_savedValue;
- (void)setAmount_savedValue:(float)value_;


//- (BOOL)validateAmount_saved:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* bill_amount;




@property (atomic) float bill_amountValue;
- (float)bill_amountValue;
- (void)setBill_amountValue:(float)value_;


//- (BOOL)validateBill_amount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* bill_image;



//- (BOOL)validateBill_image:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* earn_type;




@property (atomic) int16_t earn_typeValue;
- (int16_t)earn_typeValue;
- (void)setEarn_typeValue:(int16_t)value_;


//- (BOOL)validateEarn_type:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* loyalty_description;



//- (BOOL)validateLoyalty_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* points_earned;




@property (atomic) int16_t points_earnedValue;
- (int16_t)points_earnedValue;
- (void)setPoints_earnedValue:(int16_t)value_;


//- (BOOL)validatePoints_earned:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* rejection_reason;



//- (BOOL)validateRejection_reason:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* state;




@property (atomic) int16_t stateValue;
- (int16_t)stateValue;
- (void)setStateValue:(int16_t)value_;


//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* transaction_type;




@property (atomic) int16_t transaction_typeValue;
- (int16_t)transaction_typeValue;
- (void)setTransaction_typeValue:(int16_t)value_;


//- (BOOL)validateTransaction_type:(id*)value_ error:(NSError**)error_;






@end



@interface _DMEarnTransaction (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAmount_saved;
- (void)setPrimitiveAmount_saved:(NSNumber*)value;

- (float)primitiveAmount_savedValue;
- (void)setPrimitiveAmount_savedValue:(float)value_;




- (NSNumber*)primitiveBill_amount;
- (void)setPrimitiveBill_amount:(NSNumber*)value;

- (float)primitiveBill_amountValue;
- (void)setPrimitiveBill_amountValue:(float)value_;




- (NSString*)primitiveBill_image;
- (void)setPrimitiveBill_image:(NSString*)value;




- (NSNumber*)primitiveEarn_type;
- (void)setPrimitiveEarn_type:(NSNumber*)value;

- (int16_t)primitiveEarn_typeValue;
- (void)setPrimitiveEarn_typeValue:(int16_t)value_;




- (NSString*)primitiveLoyalty_description;
- (void)setPrimitiveLoyalty_description:(NSString*)value;




- (NSNumber*)primitivePoints_earned;
- (void)setPrimitivePoints_earned:(NSNumber*)value;

- (int16_t)primitivePoints_earnedValue;
- (void)setPrimitivePoints_earnedValue:(int16_t)value_;




- (NSString*)primitiveRejection_reason;
- (void)setPrimitiveRejection_reason:(NSString*)value;




- (NSNumber*)primitiveState;
- (void)setPrimitiveState:(NSNumber*)value;

- (int16_t)primitiveStateValue;
- (void)setPrimitiveStateValue:(int16_t)value_;




- (NSNumber*)primitiveTransaction_type;
- (void)setPrimitiveTransaction_type:(NSNumber*)value;

- (int16_t)primitiveTransaction_typeValue;
- (void)setPrimitiveTransaction_typeValue:(int16_t)value_;




@end
