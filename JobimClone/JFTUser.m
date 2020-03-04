//
//  JFTUser.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTUser.h"

@implementation JFTUser
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
    }
    return self;
}
-(instancetype)initWithName: (NSString *)name andLastName: (NSString *)lastName andEmail: (NSString *)email andBirthYear: (int)year andIsAcceptingPromos: (BOOL)doesAccept andLocation: (CLLocation *)location
{
    if (self = [super init])
    {
        self.Name = name;
        self.LastName = lastName;
        self.Email = email;
        self.BirthYear = year;
        self.AcceptsPromo = doesAccept;
        self.Location = location;
    }
    return self;
}


+(JFTUser *)GetLocalUser
{
    return [[NSUserDefaults standardUserDefaults] objectForKey:@"LocalUser"];
}
+(void)Login: (JFTUser *)user
{
    [[NSUserDefaults standardUserDefaults] setObject:user forKey:@"LocalUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];

}
+(void)Logout
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"LocalUser"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
