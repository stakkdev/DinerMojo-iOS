// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMOfferItem.h instead.

#import <CoreData/CoreData.h>
#import "DMUpdateItem.h"

extern const struct DMOfferItemAttributes {
	__unsafe_unretained NSString *discount;
	__unsafe_unretained NSString *is_birthday_offer;
	__unsafe_unretained NSString *is_special_offer;
	__unsafe_unretained NSString *points_required;
    __unsafe_unretained NSString *allowed_mojo_levels;
    __unsafe_unretained NSString *days_available;
    __unsafe_unretained NSString *monetary_value;
	__unsafe_unretained NSString *start_date;
	__unsafe_unretained NSString *terms_conditions;
	__unsafe_unretained NSString *update_type;
    __unsafe_unretained NSString *is_prodigal_reward;
    __unsafe_unretained NSString *additional_payload;

} DMOfferItemAttributes;

extern const struct DMOfferItemRelationships {
	__unsafe_unretained NSString *transactions;
} DMOfferItemRelationships;

@class DMRedeemTransaction;

@interface DMOfferItemID : DMUpdateItemID {}
@end

@interface _DMOfferItem : DMUpdateItem {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMOfferItemID* objectID;

@property (nonatomic, strong) NSNumber* discount;
@property (nonatomic, strong) NSDictionary* additional_payload;


@property BOOL isRead;

@property (atomic) float discountValue;
- (float)discountValue;
- (void)setDiscountValue:(float)value_;

//- (BOOL)validateDiscount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_birthday_offer;

@property (atomic) BOOL is_birthday_offerValue;
- (BOOL)is_birthday_offerValue;
- (void)setIs_birthday_offerValue:(BOOL)value_;

//- (BOOL)validateIs_birthday_offer:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_special_offer;

@property (atomic) int16_t is_special_offerValue;
- (int16_t)is_special_offerValue;
- (void)setIs_special_offerValue:(int16_t)value_;

//- (BOOL)validateIs_special_offer:(id*)value_ error:(NSError**)error_;


@property (nonatomic, strong) NSArray* days_available;
@property (nonatomic, strong) NSNumber* points_required;
@property (nonatomic, strong) NSNumber* monetary_value;
@property (nonatomic, strong) NSNumber* is_prodigal_reward;
@property (nonatomic, strong) NSArray* allowed_mojo_levels;

@property (atomic) int16_t points_requiredValue;
- (int16_t)points_requiredValue;
- (void)setPoints_requiredValue:(int16_t)value_;

//- (BOOL)validatePoints_required:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* start_date;

//- (BOOL)validateStart_date:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* terms_conditions;

//- (BOOL)validateTerms_conditions:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* update_type;

@property (atomic) int16_t update_typeValue;
- (int16_t)update_typeValue;
- (void)setUpdate_typeValue:(int16_t)value_;

//- (BOOL)validateUpdate_type:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;

@end

@interface _DMOfferItem (TransactionsCoreDataGeneratedAccessors)
- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(DMRedeemTransaction*)value_;
- (void)removeTransactionsObject:(DMRedeemTransaction*)value_;

@end

@interface _DMOfferItem (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveDiscount;
- (void)setPrimitiveDiscount:(NSNumber*)value;

- (float)primitiveDiscountValue;
- (void)setPrimitiveDiscountValue:(float)value_;

- (NSNumber*)primitiveIs_birthday_offer;
- (void)setPrimitiveIs_birthday_offer:(NSNumber*)value;

- (BOOL)primitiveIs_birthday_offerValue;
- (void)setPrimitiveIs_birthday_offerValue:(BOOL)value_;

- (NSNumber*)primitiveIs_special_offer;
- (void)setPrimitiveIs_special_offer:(NSNumber*)value;

- (int16_t)primitiveIs_special_offerValue;
- (void)setPrimitiveIs_special_offerValue:(int16_t)value_;

- (NSNumber*)primitivePoints_required;
- (void)setPrimitivePoints_required:(NSNumber*)value;

- (int16_t)primitivePoints_requiredValue;
- (void)setPrimitivePoints_requiredValue:(int16_t)value_;

- (NSDate*)primitiveStart_date;
- (void)setPrimitiveStart_date:(NSDate*)value;

- (NSString*)primitiveTerms_conditions;
- (void)setPrimitiveTerms_conditions:(NSString*)value;

- (NSNumber*)primitiveUpdate_type;
- (void)setPrimitiveUpdate_type:(NSNumber*)value;

- (int16_t)primitiveUpdate_typeValue;
- (void)setPrimitiveUpdate_typeValue:(int16_t)value_;

- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;

@end
