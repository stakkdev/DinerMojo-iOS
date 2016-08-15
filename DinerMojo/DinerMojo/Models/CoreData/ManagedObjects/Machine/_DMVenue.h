// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMVenue.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"



extern const struct DMVenueAttributes {
	__unsafe_unretained NSString *area;
	__unsafe_unretained NSString *email_address;
	__unsafe_unretained NSString *house_number_street_name;
	__unsafe_unretained NSString *in_wishlist;
	__unsafe_unretained NSString *latitude;
	__unsafe_unretained NSString *longitude;
	__unsafe_unretained NSString *menu_url;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *open_now;
	__unsafe_unretained NSString *phone_number;
	__unsafe_unretained NSString *post_code;
	__unsafe_unretained NSString *price_bracket;
	__unsafe_unretained NSString *state;
	__unsafe_unretained NSString *town;
	__unsafe_unretained NSString *trip_advisor_link;
	__unsafe_unretained NSString *user_last_viewed;
	__unsafe_unretained NSString *venue_description;
	__unsafe_unretained NSString *web_address;
} DMVenueAttributes;



extern const struct DMVenueRelationships {
	__unsafe_unretained NSString *categories;
	__unsafe_unretained NSString *favourite;
	__unsafe_unretained NSString *images;
	__unsafe_unretained NSString *opening_times;
	__unsafe_unretained NSString *primary_image;
	__unsafe_unretained NSString *transactions;
	__unsafe_unretained NSString *updates;
} DMVenueRelationships;





extern const struct DMVenueUserInfo {
	__unsafe_unretained NSString *relatedByAttribute;
} DMVenueUserInfo;


@class DMVenueCategory;
@class DMUser;
@class DMVenueImage;
@class DMVenueOpeningTimes;
@class DMVenueImage;
@class DMTransaction;
@class DMUpdateItem;






































@interface DMVenueID : DMBaseID {}
@end

@interface _DMVenue : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (DMVenueID*)objectID;





@property (nonatomic, strong) NSString* area;



//- (BOOL)validateArea:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email_address;



//- (BOOL)validateEmail_address:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* house_number_street_name;



//- (BOOL)validateHouse_number_street_name:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* in_wishlist;




@property (atomic) BOOL in_wishlistValue;
- (BOOL)in_wishlistValue;
- (void)setIn_wishlistValue:(BOOL)value_;


//- (BOOL)validateIn_wishlist:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* latitude;




@property (atomic) float latitudeValue;
- (float)latitudeValue;
- (void)setLatitudeValue:(float)value_;


//- (BOOL)validateLatitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* longitude;




@property (atomic) float longitudeValue;
- (float)longitudeValue;
- (void)setLongitudeValue:(float)value_;


//- (BOOL)validateLongitude:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* menu_url;



//- (BOOL)validateMenu_url:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* open_now;




@property (atomic) int16_t open_nowValue;
- (int16_t)open_nowValue;
- (void)setOpen_nowValue:(int16_t)value_;


//- (BOOL)validateOpen_now:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* phone_number;



//- (BOOL)validatePhone_number:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* post_code;



//- (BOOL)validatePost_code:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* price_bracket;




@property (atomic) int16_t price_bracketValue;
- (int16_t)price_bracketValue;
- (void)setPrice_bracketValue:(int16_t)value_;


//- (BOOL)validatePrice_bracket:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* state;




@property (atomic) int16_t stateValue;
- (int16_t)stateValue;
- (void)setStateValue:(int16_t)value_;


//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* town;



//- (BOOL)validateTown:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* trip_advisor_link;



//- (BOOL)validateTrip_advisor_link:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* user_last_viewed;



//- (BOOL)validateUser_last_viewed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* venue_description;



//- (BOOL)validateVenue_description:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* web_address;



//- (BOOL)validateWeb_address:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *categories;

- (NSMutableSet*)categoriesSet;




@property (nonatomic, strong) DMUser *favourite;

//- (BOOL)validateFavourite:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *images;

- (NSMutableSet*)imagesSet;




@property (nonatomic, strong) DMVenueOpeningTimes *opening_times;

//- (BOOL)validateOpening_times:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) DMVenueImage *primary_image;

//- (BOOL)validatePrimary_image:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;




@property (nonatomic, strong) NSSet *updates;

- (NSMutableSet*)updatesSet;





@end


@interface _DMVenue (CategoriesCoreDataGeneratedAccessors)
- (void)addCategories:(NSSet*)value_;
- (void)removeCategories:(NSSet*)value_;
- (void)addCategoriesObject:(DMVenueCategory*)value_;
- (void)removeCategoriesObject:(DMVenueCategory*)value_;
@end

@interface _DMVenue (ImagesCoreDataGeneratedAccessors)
- (void)addImages:(NSSet*)value_;
- (void)removeImages:(NSSet*)value_;
- (void)addImagesObject:(DMVenueImage*)value_;
- (void)removeImagesObject:(DMVenueImage*)value_;
@end

@interface _DMVenue (TransactionsCoreDataGeneratedAccessors)
- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(DMTransaction*)value_;
- (void)removeTransactionsObject:(DMTransaction*)value_;
@end

@interface _DMVenue (UpdatesCoreDataGeneratedAccessors)
- (void)addUpdates:(NSSet*)value_;
- (void)removeUpdates:(NSSet*)value_;
- (void)addUpdatesObject:(DMUpdateItem*)value_;
- (void)removeUpdatesObject:(DMUpdateItem*)value_;
@end


@interface _DMVenue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveArea;
- (void)setPrimitiveArea:(NSString*)value;




- (NSString*)primitiveEmail_address;
- (void)setPrimitiveEmail_address:(NSString*)value;




- (NSString*)primitiveHouse_number_street_name;
- (void)setPrimitiveHouse_number_street_name:(NSString*)value;




- (NSNumber*)primitiveIn_wishlist;
- (void)setPrimitiveIn_wishlist:(NSNumber*)value;

- (BOOL)primitiveIn_wishlistValue;
- (void)setPrimitiveIn_wishlistValue:(BOOL)value_;




- (NSNumber*)primitiveLatitude;
- (void)setPrimitiveLatitude:(NSNumber*)value;

- (float)primitiveLatitudeValue;
- (void)setPrimitiveLatitudeValue:(float)value_;




- (NSNumber*)primitiveLongitude;
- (void)setPrimitiveLongitude:(NSNumber*)value;

- (float)primitiveLongitudeValue;
- (void)setPrimitiveLongitudeValue:(float)value_;




- (NSString*)primitiveMenu_url;
- (void)setPrimitiveMenu_url:(NSString*)value;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveOpen_now;
- (void)setPrimitiveOpen_now:(NSNumber*)value;

- (int16_t)primitiveOpen_nowValue;
- (void)setPrimitiveOpen_nowValue:(int16_t)value_;




- (NSString*)primitivePhone_number;
- (void)setPrimitivePhone_number:(NSString*)value;




- (NSString*)primitivePost_code;
- (void)setPrimitivePost_code:(NSString*)value;




- (NSNumber*)primitivePrice_bracket;
- (void)setPrimitivePrice_bracket:(NSNumber*)value;

- (int16_t)primitivePrice_bracketValue;
- (void)setPrimitivePrice_bracketValue:(int16_t)value_;




- (NSNumber*)primitiveState;
- (void)setPrimitiveState:(NSNumber*)value;

- (int16_t)primitiveStateValue;
- (void)setPrimitiveStateValue:(int16_t)value_;




- (NSString*)primitiveTown;
- (void)setPrimitiveTown:(NSString*)value;




- (NSString*)primitiveTrip_advisor_link;
- (void)setPrimitiveTrip_advisor_link:(NSString*)value;




- (NSDate*)primitiveUser_last_viewed;
- (void)setPrimitiveUser_last_viewed:(NSDate*)value;




- (NSString*)primitiveVenue_description;
- (void)setPrimitiveVenue_description:(NSString*)value;




- (NSString*)primitiveWeb_address;
- (void)setPrimitiveWeb_address:(NSString*)value;





- (NSMutableSet*)primitiveCategories;
- (void)setPrimitiveCategories:(NSMutableSet*)value;



- (DMUser*)primitiveFavourite;
- (void)setPrimitiveFavourite:(DMUser*)value;



- (NSMutableSet*)primitiveImages;
- (void)setPrimitiveImages:(NSMutableSet*)value;



- (DMVenueOpeningTimes*)primitiveOpening_times;
- (void)setPrimitiveOpening_times:(DMVenueOpeningTimes*)value;



- (DMVenueImage*)primitivePrimary_image;
- (void)setPrimitivePrimary_image:(DMVenueImage*)value;



- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;



- (NSMutableSet*)primitiveUpdates;
- (void)setPrimitiveUpdates:(NSMutableSet*)value;


@end
