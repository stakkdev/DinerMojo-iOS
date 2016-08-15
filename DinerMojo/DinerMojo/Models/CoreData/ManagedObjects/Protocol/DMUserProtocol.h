// DO NOT EDIT. This file is machine-generated and constantly overwritten.

@protocol DMVenueProtocol;
@protocol DMTransactionProtocol;

































@protocol DMUserProtocol



- (NSNumber*)annual_points_balance;
- (void)setAnnual_points_balance:(NSNumber*)annual_points_balance;



- (NSNumber*)annual_points_earned;
- (void)setAnnual_points_earned:(NSNumber*)annual_points_earned;



- (NSDate*)date_of_birth;
- (void)setDate_of_birth:(NSDate*)date_of_birth;



- (NSString*)email_address;
- (void)setEmail_address:(NSString*)email_address;



- (NSString*)facebook_id;
- (void)setFacebook_id:(NSString*)facebook_id;



- (NSString*)first_name;
- (void)setFirst_name:(NSString*)first_name;



- (NSNumber*)gender;
- (void)setGender:(NSNumber*)gender;



- (NSNumber*)is_email_verified;
- (void)setIs_email_verified:(NSNumber*)is_email_verified;



- (NSString*)last_name;
- (void)setLast_name:(NSString*)last_name;



- (NSNumber*)local_account;
- (void)setLocal_account:(NSNumber*)local_account;



- (NSNumber*)notification_filter;
- (void)setNotification_filter:(NSNumber*)notification_filter;



- (NSNumber*)notification_frequency;
- (void)setNotification_frequency:(NSNumber*)notification_frequency;



- (NSString*)post_code;
- (void)setPost_code:(NSString*)post_code;



- (NSString*)profile_picture;
- (void)setProfile_picture:(NSString*)profile_picture;



- (NSNumber*)referred_points;
- (void)setReferred_points:(NSNumber*)referred_points;







- (NSSet*)favourite_venues;
- (void)setFavourite_venues:(NSSet*)favourite_venues;







- (NSSet*)transactions;
- (void)setTransactions:(NSSet*)transactions;






- (void)addFavourite_venues:(NSSet*)value_;
- (void)removeFavourite_venues:(NSSet*)value_;
- (void)addFavourite_venuesObject:(id<DMVenueProtocol>)value_;
- (void)removeFavourite_venuesObject:(id<DMVenueProtocol>)value_;

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(id<DMTransactionProtocol>)value_;
- (void)removeTransactionsObject:(id<DMTransactionProtocol>)value_;


@end