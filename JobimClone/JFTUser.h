//
//  JFTUser.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
typedef enum
{
    JFTUserPropertyAcceptsPromo,
    JFTUserPropertyPhoneNumber,
    JFTUserPropertyBirthYear,
    JFTUserPropertyLastName,
    JFTUserPropertyLocation,
    JFTUserPropertyImage,
    JFTUserPropertyEmail,
    JFTUserPropertyName
} JFTUserProperty;
@interface JFTUser : NSObject
@property NSString* PhoneNumber;
@property CLLocation* Location;
@property NSString* LastName;
@property BOOL AcceptsPromo;
@property UIImage* Image;
@property NSString* Email;
@property NSString* Name;
@property int BirthYear;
@property NSString* ID;
-(instancetype)init;
-(instancetype)initWithName: (NSString*)name andLastName: (NSString*)lastName andEmail: (NSString*)email andBirthYear: (int)year andIsAcceptingPromos: (BOOL)doesAccept andLocation: (CLLocation*)location andImage: (UIImage*)img andWithPhoneNumber: (NSString*)phoneNumber;
+(JFTUser*)userFromJSON: (NSDictionary *)fireBaseUser andWithID: (NSString*)userID;
+(NSDictionary*)JSONFromUser: (JFTUser*)user;
+(void)updateUserInformation: (JFTUserProperty)property withValue: (id)value;
@end
