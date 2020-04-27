//
//  JFTUser.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTUtilities.h"
#import "JFTUser.h"
#import "JFTJob.h"
@implementation JFTUser
#pragma mark - Constructors
-(instancetype)init
{
    if (self = [super init])
    {
        self.Name = @"";
        self.LastName = @"";
        self.Email = @"";
        self.BirthYear = 1900;
        self.AcceptsPromo = NO;
        self.Location = [CLLocation new];
        self.Image = [UIImage new];
        self.PhoneNumber = @"";
    }
    return self;
}
-(instancetype)initWithName: (NSString*)name andLastName: (NSString*)lastName andEmail: (NSString*)email andBirthYear: (int)year andIsAcceptingPromos: (BOOL)doesAccept andLocation: (CLLocation*)location andImage: (UIImage*)img andWithPhoneNumber: (NSString*)phoneNumber
{
    if (self = [super init])
    {
        self.Name = name;
        self.LastName = lastName;
        self.Email = email;
        self.BirthYear = year;
        self.AcceptsPromo = doesAccept;
        self.Location = location;
        self.Image = img;
        self.PhoneNumber = phoneNumber;
    }
    return self;
}
#pragma mark - Base Class Overrides
-(NSString*)description
{
    NSString* description = [NSString stringWithFormat: @"[Name | %@]\n[LastName | %@]\n[Email | %@]\n[Year | %d]\n[Promo? | %@]\n[Phone#: %@]", self.Name, self.LastName, self.Email, self.BirthYear, (self.AcceptsPromo) ? @"YES" : @"NO", self.PhoneNumber];
    return description;
}
#pragma mark - Class Functions
#pragma mark - Converters
+(JFTUser*)userFromJSON: (NSDictionary *)fireBaseUser andWithID: (NSString*)userID
{
    JFTUser *newUser = [JFTUser new];
    newUser.Name = [fireBaseUser objectForKey: @"name"];
    newUser.LastName = [fireBaseUser objectForKey: @"lastName"];
    newUser.BirthYear = [[fireBaseUser objectForKey: @"birthYear"] intValue];
    newUser.Email = [fireBaseUser objectForKey: @"email"];
    newUser.Location = [JFTUtilities locationFromJSON: [fireBaseUser objectForKey: @"location"]];
    newUser.AcceptsPromo = [[fireBaseUser objectForKey: @"acceptsPromo"] boolValue];
    NSString* imageString = [fireBaseUser objectForKey: @"image"];
    if (imageString)
        newUser.Image = [[UIImage alloc] initWithData:[[NSData alloc] initWithBase64EncodedString:imageString options:NSDataBase64DecodingIgnoreUnknownCharacters]];
    else
        newUser.Image = [UIImage new];
    newUser.PhoneNumber = [fireBaseUser objectForKey: @"phoneNumber"];
    newUser.ID = userID;
    return newUser;
}
+(NSDictionary*)JSONFromUser: (JFTUser*)user
{
    return
    @{
        @"name":user.Name,
        @"lastName":user.LastName,
        @"birthYear":[NSNumber numberWithInt: user.BirthYear],
        @"email":user.Email,
        @"location":[JFTUtilities JSONFromLocation: user.Location],
        @"acceptsPromo":[NSNumber numberWithBool: user.AcceptsPromo],
        @"image":[UIImagePNGRepresentation(user.Image) base64EncodedStringWithOptions: 0],
        @"phoneNumber":user.PhoneNumber
    };
}
#pragma mark - Firebase Utilities
+(void)updateUserInformation: (JFTUserProperty)property withValue: (id)value
{
    NSString* key = [[[JFTUtilities globalDatabaseReference] child:@"users"] child: LocalUser.ID].key;
    NSString* fullPath = [@"/users/" stringByAppendingString: key];
    NSDictionary* updateUserServerPacket = [self prepareUserUpdatePacket: property withValue: value andFullPath: fullPath];
    [[JFTUtilities globalDatabaseReference] updateChildValues: updateUserServerPacket withCompletionBlock: ^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref)
    {
        if (error)
        {
            NSLog(@"Error: %@", error);
        }
    }];
}
+(NSDictionary*)prepareUserUpdatePacket: (JFTUserProperty)property withValue: (id)value andFullPath: (NSString*)path
{
    NSMutableDictionary* packetHolder = [NSMutableDictionary new];
    switch (property)
    {
        case JFTUserPropertyAcceptsPromo:
            [packetHolder setObject: value forKey: [path stringByAppendingString: @"/acceptsPromo"]];
            break;
        case JFTUserPropertyPhoneNumber:
            [packetHolder setObject: value forKey: [path stringByAppendingString: @"/phoneNumber"]];
            break;
        case JFTUserPropertyBirthYear:
            [packetHolder setObject: value forKey: [path stringByAppendingString: @"/birthYear"]];
            break;
        case JFTUserPropertyLastName:
            [packetHolder setObject: value forKey: [path stringByAppendingString: @"/lastName"]];
            break;
        case JFTUserPropertyLocation:
            [packetHolder setObject: [JFTUtilities JSONFromLocation: value] forKey: [path stringByAppendingString: @"/location"]];
            break;
        case JFTUserPropertyImage:
            [packetHolder setObject: [UIImagePNGRepresentation(value) base64EncodedDataWithOptions: 0] forKey: [path stringByAppendingString: @"/image"]];
            break;
        case JFTUserPropertyEmail:
            [packetHolder setObject: value forKey: [path stringByAppendingString: @"/email"]];
            break;
        case JFTUserPropertyName:
            [packetHolder setObject: value forKey: [path stringByAppendingString: @"/name"]];
            break;
        default:
            break;
    }
    return [packetHolder copy];
}
@end
