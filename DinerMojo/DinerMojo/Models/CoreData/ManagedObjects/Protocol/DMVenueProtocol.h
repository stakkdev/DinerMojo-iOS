// DO NOT EDIT. This file is machine-generated and constantly overwritten.

@protocol DMVenueCategoryProtocol;
@protocol DMUserProtocol;
@protocol DMVenueImageProtocol;
@protocol DMVenueOpeningTimesProtocol;
@protocol DMVenueImageProtocol;
@protocol DMTransactionProtocol;
@protocol DMUpdateItemProtocol;







































@protocol DMVenueProtocol



- (NSString*)area;
- (void)setArea:(NSString*)area;



- (NSString*)email_address;
- (void)setEmail_address:(NSString*)email_address;



- (NSString*)house_number_street_name;
- (void)setHouse_number_street_name:(NSString*)house_number_street_name;



- (NSNumber*)in_wishlist;
- (void)setIn_wishlist:(NSNumber*)in_wishlist;



- (NSNumber*)latitude;
- (void)setLatitude:(NSNumber*)latitude;



- (NSNumber*)longitude;
- (void)setLongitude:(NSNumber*)longitude;



- (NSString*)menu_url;
- (void)setMenu_url:(NSString*)menu_url;



- (NSString*)name;
- (void)setName:(NSString*)name;



- (NSNumber*)open_now;
- (void)setOpen_now:(NSNumber*)open_now;



- (NSString*)phone_number;
- (void)setPhone_number:(NSString*)phone_number;



- (NSString*)post_code;
- (void)setPost_code:(NSString*)post_code;



- (NSNumber*)price_bracket;
- (void)setPrice_bracket:(NSNumber*)price_bracket;



- (NSNumber*)state;
- (void)setState:(NSNumber*)state;



- (NSString*)town;
- (void)setTown:(NSString*)town;



- (NSString*)trip_advisor_link;
- (void)setTrip_advisor_link:(NSString*)trip_advisor_link;



- (NSDate*)user_last_viewed;
- (void)setUser_last_viewed:(NSDate*)user_last_viewed;



- (NSString*)venue_description;
- (void)setVenue_description:(NSString*)venue_description;



- (NSString*)web_address;
- (void)setWeb_address:(NSString*)web_address;







- (NSSet*)categories;
- (void)setCategories:(NSSet*)categories;







- (id<DMUserProtocol>)favourite;
- (void)setFavourite:(id<DMUserProtocol>)favourite;







- (NSSet*)images;
- (void)setImages:(NSSet*)images;







- (id<DMVenueOpeningTimesProtocol>)opening_times;
- (void)setOpening_times:(id<DMVenueOpeningTimesProtocol>)opening_times;







- (id<DMVenueImageProtocol>)primary_image;
- (void)setPrimary_image:(id<DMVenueImageProtocol>)primary_image;







- (NSSet*)transactions;
- (void)setTransactions:(NSSet*)transactions;







- (NSSet*)updates;
- (void)setUpdates:(NSSet*)updates;






- (void)addCategories:(NSSet*)value_;
- (void)removeCategories:(NSSet*)value_;
- (void)addCategoriesObject:(id<DMVenueCategoryProtocol>)value_;
- (void)removeCategoriesObject:(id<DMVenueCategoryProtocol>)value_;

- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(id<DMVenueImageProtocol>)value_;
- (void)removeImagesObject:(id<DMVenueImageProtocol>)value_;

- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(id<DMTransactionProtocol>)value_;
- (void)removeTransactionsObject:(id<DMTransactionProtocol>)value_;

- (void)addUpdates:(NSSet*)value_;
- (void)removeUpdates:(NSSet*)value_;
- (void)addUpdatesObject:(id<DMUpdateItemProtocol>)value_;
- (void)removeUpdatesObject:(id<DMUpdateItemProtocol>)value_;


@end