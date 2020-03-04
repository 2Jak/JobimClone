//
//  JFTUser.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
@interface JFTUser : NSObject
@property NSString *Name;
@property NSString *LastName;
@property NSString *Email;
@property int BirthYear;
@property BOOL AcceptsPromo;
@property CLLocation *Location;
-(instancetype)init;
-(instancetype)initWithName: (NSString *)name andLastName: (NSString *)lastName andEmail: (NSString *)email andBirthYear: (int)year andIsAcceptingPromos: (BOOL)doesAccept andLocation: (CLLocation *)location;
+(JFTUser *)GetLocalUser;
+(void)Login: (JFTUser *)user;
+(void)Logout;
@end
