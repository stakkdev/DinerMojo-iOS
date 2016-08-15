// DO NOT EDIT. This file is machine-generated and constantly overwritten.

@protocol DMRedeemTransactionProtocol;

















@protocol DMOfferItemProtocol



- (NSNumber*)discount;
- (void)setDiscount:(NSNumber*)discount;



- (NSNumber*)is_birthday_offer;
- (void)setIs_birthday_offer:(NSNumber*)is_birthday_offer;



- (NSNumber*)is_special_offer;
- (void)setIs_special_offer:(NSNumber*)is_special_offer;



- (NSNumber*)points_required;
- (void)setPoints_required:(NSNumber*)points_required;



- (NSDate*)start_date;
- (void)setStart_date:(NSDate*)start_date;



- (NSString*)terms_conditions;
- (void)setTerms_conditions:(NSString*)terms_conditions;



- (NSNumber*)update_type;
- (void)setUpdate_type:(NSNumber*)update_type;







- (NSSet*)transactions;
- (void)setTransactions:(NSSet*)transactions;






- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(id<DMRedeemTransactionProtocol>)value_;
- (void)removeTransactionsObject:(id<DMRedeemTransactionProtocol>)value_;


@end