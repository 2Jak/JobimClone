//
//  Utilities.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import <FirebaseDatabase/FirebaseDatabase.h>
#import <CoreLocation/CoreLocation.h>
#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
#import "JFTUser.h"
@class JFTUser;
@class JFTJob;
extern CLLocation* LocalLocation;
extern JFTUser* LocalUser;
extern JFTJob* LocalJob;
typedef enum
{
    JFTNavBarLeftButtonTypeX,
    JFTNavBarLeftButtonTypeOpenSideBar
} JFTNavBarLeftButtonTypes;
typedef enum
{
    JFTNavBarRightButtonTypeAdd,
    JFTNavBarRightButtonTypeOpenMapView,
    JFTNavBarRightButtonTypeNone
} JFTNavBarRightButtonTypes;
@interface JFTUtilities : NSObject
+(FIRDatabaseReference*)globalDatabaseReference;
+(CLLocation*)locationFromJSON: (NSDictionary*)jsonLocation;
+(NSDictionary*)JSONFromLocation: (CLLocation*)location;
+(void)addressFromLocation: (CLLocation*)location andSender: (id)sender;
+(void)addressFromLocation: (CLLocation*)location andSender: (id)sender onCompletion: (nullable void (^)(void))completionBlock;
+(void)locationFromAddress: (NSString*)address andSender: (CLLocation*)sender;
+(void)locationFromAddress: (NSString*)address andSender: (CLLocation*)sender onCompletion: (nullable void (^)(void))completionBlock;
+(void)centerViewForMKMapView: (MKMapView*)mapView forLocation: (CLLocation*)location withSquareSizeOf: (float)edgeLength;
+(void)addJobPinToMKMapView: (MKMapView*)mapView theJob: (JFTJob*)job;
+(void)showErrorInAlert: (NSError*)error onView: (UIViewController*)caller;
+(void)shoeAlertForText: (NSString*)text onView: (UIViewController*)caller;
+(void)setViewControllerNavigationBarFor: (UIViewController*)viewController with: (JFTNavBarLeftButtonTypes)leftButton and: (JFTNavBarRightButtonTypes)rightButton;
+(void)passToDatabaseUpdateIfNotRegistrationPage: (JFTUserProperty)property withValue: (id)value from: (UIViewController*)viewController;
+(BOOL)verifyInputForPhoneNumber: (NSString*)input;
+(NSString*)appendAreaCodeToPhoneNumber: (NSString*)phoneNumber;
+(UIImage*)convertImage: (UIImage*)image toSize: (CGSize)size;
+(UIColor*)lightenColor: (UIColor*)color;
+(UIColor*)darkenColor: (UIColor*)color;
@end
