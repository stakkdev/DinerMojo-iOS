// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMRedeemTransaction.h instead.

#import <CoreData/CoreData.h>
#import "DMTransaction.h"

extern const struct DMRedeemTransactionAttributes {
	__unsafe_unretained NSString *discount_as_percentage;
	__unsafe_unretained NSString *points_redeemed;
	__unsafe_unretained NSString *transaction_type;
} DMRedeemTransactionAttributes;

extern const struct DMRedeemTransactionRelationships {
	__unsafe_unretained NSString *offer;
} DMRedeemTransactionRelationships;

@class DMOfferItem;

@interface DMRedeemTransactionID : DMTransactionID {}
@end

@interface _DMRedeemTransaction : DMTransaction {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMRedeemTransactionID* objectID;

@property (nonatomic, strong) NSNumber* discount_as_percentage;

@property (atomic) int16_t discount_as_percentageValue;
- (int16_t)discount_as_percentageValue;
- (void)setDiscount_as_percentageValue:(int16_t)value_;

//- (BOOL)validateDiscount_as_percentage:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* points_redeemed;

@property (atomic) int16_t points_redeemedValue;
- (int16_t)points_redeemedValue;
- (void)setPoints_redeemedValue:(int16_t)value_;

//- (BOOL)validatePoints_redeemed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* transaction_type;

@property (atomic) int16_t transaction_typeValue;
- (int16_t)transaction_typeValue;
- (void)setTransaction_typeValue:(int16_t)value_;

//- (BOOL)validateTransaction_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) DMOfferItem *offer;

//- (BOOL)validateOffer:(id*)value_ error:(NSError**)error_;

@end

@interface _DMRedeemTransaction (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveDiscount_as_percentage;
- (void)setPrimitiveDiscount_as_percentage:(NSNumber*)value;

- (int16_t)primitiveDiscount_as_percentageValue;
- (void)setPrimitiveDiscount_as_percentageValue:(int16_t)value_;

- (NSNumber*)primitivePoints_redeemed;
- (void)setPrimitivePoints_redeemed:(NSNumber*)value;

- (int16_t)primitivePoints_redeemedValue;
- (void)setPrimitivePoints_redeemedValue:(int16_t)value_;

- (NSNumber*)primitiveTransaction_type;
- (void)setPrimitiveTransaction_type:(NSNumber*)value;

- (int16_t)primitiveTransaction_typeValue;
- (void)setPrimitiveTransaction_typeValue:(int16_t)value_;

- (DMOfferItem*)primitiveOffer;
- (void)setPrimitiveOffer:(DMOfferItem*)value;

@end
