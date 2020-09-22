// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to DMUser.h instead.

#import <CoreData/CoreData.h>
#import "DMBase.h"

extern const struct DMUserAttributes {
	__unsafe_unretained NSString *annual_points_balance;
	__unsafe_unretained NSString *annual_points_earned;
	__unsafe_unretained NSString *date_of_birth;
	__unsafe_unretained NSString *email_address;
	__unsafe_unretained NSString *facebook_id;
	__unsafe_unretained NSString *first_name;
	__unsafe_unretained NSString *gender;
	__unsafe_unretained NSString *is_email_verified;
    __unsafe_unretained NSString *is_gdpr_accepted;
	__unsafe_unretained NSString *last_name;
	__unsafe_unretained NSString *local_account;
	__unsafe_unretained NSString *notification_filter;
	__unsafe_unretained NSString *notification_frequency;
	__unsafe_unretained NSString *post_code;
	__unsafe_unretained NSString *profile_picture;
	__unsafe_unretained NSString *referred_points;
} DMUserAttributes;

extern const struct DMUserRelationships {
	__unsafe_unretained NSString *favourite_venues;
	__unsafe_unretained NSString *transactions;
} DMUserRelationships;

@class DMVenue;
@class DMTransaction;

@interface DMUserID : DMBaseID {}
@end

@interface _DMUser : DMBase {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) DMUserID* objectID;

@property (nonatomic, strong) NSNumber* annual_points_balance;

@property (atomic) int16_t annual_points_balanceValue;
- (int16_t)annual_points_balanceValue;
- (void)setAnnual_points_balanceValue:(int16_t)value_;

//- (BOOL)validateAnnual_points_balance:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* annual_points_earned;

@property (atomic) int16_t annual_points_earnedValue;
- (int16_t)annual_points_earnedValue;
- (void)setAnnual_points_earnedValue:(int16_t)value_;

//- (BOOL)validateAnnual_points_earned:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSDate* date_of_birth;

//- (BOOL)validateDate_of_birth:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email_address;

//- (BOOL)validateEmail_address:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* facebook_id;

//- (BOOL)validateFacebook_id:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* first_name;

//- (BOOL)validateFirst_name:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* gender;

@property (atomic) int16_t genderValue;
- (int16_t)genderValue;
- (void)setGenderValue:(int16_t)value_;

//- (BOOL)validateGender:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_email_verified;

@property (atomic) BOOL is_email_verifiedValue;
- (BOOL)is_email_verifiedValue;
- (void)setIs_email_verifiedValue:(BOOL)value_;

//- (BOOL)validateIs_email_verified:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* is_gdpr_accepted;

@property (atomic) BOOL is_gdpr_acceptedValue;
- (BOOL)is_gdpr_acceptedValue;
- (void)setIs_gdpr_acceptedValue:(BOOL)value_;

//- (BOOL)validateIs_gdpr_accepted:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* last_name;

//- (BOOL)validateLast_name:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* local_account;

@property (atomic) BOOL local_accountValue;
- (BOOL)local_accountValue;
- (void)setLocal_accountValue:(BOOL)value_;

//- (BOOL)validateLocal_account:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* notification_filter;

@property (atomic) int16_t notification_filterValue;
- (int16_t)notification_filterValue;
- (void)setNotification_filterValue:(int16_t)value_;

//- (BOOL)validateNotification_filter:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* notification_frequency;

@property (atomic) int16_t notification_frequencyValue;
- (int16_t)notification_frequencyValue;
- (void)setNotification_frequencyValue:(int16_t)value_;

//- (BOOL)validateNotification_frequency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* post_code;

//- (BOOL)validatePost_code:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* profile_picture;

//- (BOOL)validateProfile_picture:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* referred_points;

@property (atomic) int16_t referred_pointsValue;
- (int16_t)referred_pointsValue;
- (void)setReferred_pointsValue:(int16_t)value_;

//- (BOOL)validateReferred_points:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *favourite_venues;

- (NSMutableSet*)favourite_venuesSet;

@property (nonatomic, strong) NSSet *transactions;

- (NSMutableSet*)transactionsSet;

@end

@interface _DMUser (Favourite_venuesCoreDataGeneratedAccessors)
- (void)addFavourite_venues:(NSSet*)value_;
- (void)removeFavourite_venues:(NSSet*)value_;
- (void)addFavourite_venuesObject:(DMVenue*)value_;
- (void)removeFavourite_venuesObject:(DMVenue*)value_;

@end

@interface _DMUser (TransactionsCoreDataGeneratedAccessors)
- (void)addTransactions:(NSSet*)value_;
- (void)removeTransactions:(NSSet*)value_;
- (void)addTransactionsObject:(DMTransaction*)value_;
- (void)removeTransactionsObject:(DMTransaction*)value_;

@end

@interface _DMUser (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAnnual_points_balance;
- (void)setPrimitiveAnnual_points_balance:(NSNumber*)value;

- (int16_t)primitiveAnnual_points_balanceValue;
- (void)setPrimitiveAnnual_points_balanceValue:(int16_t)value_;

- (NSNumber*)primitiveAnnual_points_earned;
- (void)setPrimitiveAnnual_points_earned:(NSNumber*)value;

- (int16_t)primitiveAnnual_points_earnedValue;
- (void)setPrimitiveAnnual_points_earnedValue:(int16_t)value_;

- (NSDate*)primitiveDate_of_birth;
- (void)setPrimitiveDate_of_birth:(NSDate*)value;

- (NSString*)primitiveEmail_address;
- (void)setPrimitiveEmail_address:(NSString*)value;

- (NSString*)primitiveFacebook_id;
- (void)setPrimitiveFacebook_id:(NSString*)value;

- (NSString*)primitiveFirst_name;
- (void)setPrimitiveFirst_name:(NSString*)value;

- (NSNumber*)primitiveGender;
- (void)setPrimitiveGender:(NSNumber*)value;

- (int16_t)primitiveGenderValue;
- (void)setPrimitiveGenderValue:(int16_t)value_;

- (NSNumber*)primitiveIs_email_verified;
- (void)setPrimitiveIs_email_verified:(NSNumber*)value;

- (BOOL)primitiveIs_email_verifiedValue;
- (void)setPrimitiveIs_email_verifiedValue:(BOOL)value_;

- (NSNumber*)primitiveIs_gdpr_accepted;
- (void)setPrimitiveIs_gdpr_accepted:(NSNumber*)value;

- (BOOL)primitiveIs_gdpr_acceptedValue;
- (void)setPrimitiveIs_gdpr_acceptedValue:(BOOL)value_;

- (NSString*)primitiveLast_name;
- (void)setPrimitiveLast_name:(NSString*)value;

- (NSNumber*)primitiveLocal_account;
- (void)setPrimitiveLocal_account:(NSNumber*)value;

- (BOOL)primitiveLocal_accountValue;
- (void)setPrimitiveLocal_accountValue:(BOOL)value_;

- (NSNumber*)primitiveNotification_filter;
- (void)setPrimitiveNotification_filter:(NSNumber*)value;

- (int16_t)primitiveNotification_filterValue;
- (void)setPrimitiveNotification_filterValue:(int16_t)value_;

- (NSNumber*)primitiveNotification_frequency;
- (void)setPrimitiveNotification_frequency:(NSNumber*)value;

- (int16_t)primitiveNotification_frequencyValue;
- (void)setPrimitiveNotification_frequencyValue:(int16_t)value_;

- (NSString*)primitivePost_code;
- (void)setPrimitivePost_code:(NSString*)value;

- (NSString*)primitiveProfile_picture;
- (void)setPrimitiveProfile_picture:(NSString*)value;

- (NSNumber*)primitiveReferred_points;
- (void)setPrimitiveReferred_points:(NSNumber*)value;

- (int16_t)primitiveReferred_pointsValue;
- (void)setPrimitiveReferred_pointsValue:(int16_t)value_;

- (NSMutableSet*)primitiveFavourite_venues;
- (void)setPrimitiveFavourite_venues:(NSMutableSet*)value;

- (NSMutableSet*)primitiveTransactions;
- (void)setPrimitiveTransactions:(NSMutableSet*)value;

@end
