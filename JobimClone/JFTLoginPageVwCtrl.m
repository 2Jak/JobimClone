//
//  JFTLoginPageVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTPersonalInfoVwCtrl.h"
#import "JFTLoginPageVwCtrl.h"
#import "JFTImageCacheStore.h"
#import "JFTLocalJobsStore.h"
#import "JFTJobTypeStore.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
#import "JFTJob.h"
@interface JFTLoginPageVwCtrl()
<CLLocationManagerDelegate>
@property (nonatomic, strong) CLLocationManager* locationManager;
@property (nonatomic, strong) NSString* userID;
@end
@implementation JFTLoginPageVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    [[JFTLocalJobsStore sharedStore] AllJobs];
    [[JFTJobTypeStore sharedStore] AllItems];
    LocalUser = [JFTUser new];
    LocalJob = [JFTJob new];
    self.locationManager = [CLLocationManager new];
    self.locationManager.delegate = self;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if ([[NSUserDefaults standardUserDefaults] objectForKey: @"UserSavedPhoneNumber"] != nil)
        [self identifyByPhone: [[NSUserDefaults standardUserDefaults] objectForKey: @"UserSavedPhoneNumber"]];
}
- (IBAction)onPhoneNumberTextFieldValueChange: (id)sender
{
    UITextField* castSender = (UITextField *)sender;
    if ([JFTUtilities verifyInputForPhoneNumber: castSender.text])
    {
        [self identifyByPhone: [JFTUtilities appendAreaCodeToPhoneNumber: castSender.text]];
    }
}
- (IBAction)onAuthPassTextFieldValueChange: (id)sender
{
    UITextField* castSender = (UITextField*)sender;
    if ([castSender.text length] >= 6)
    {
        [self loginWithAuthCode: castSender.text];
    }
}
#pragma mark - Location Event Handlers
-(void)locationManager: (CLLocationManager*)manager didUpdateLocations: (NSArray<CLLocation*>*)locations
{
    LocalLocation = locations[0];
    [self.locationManager stopUpdatingLocation];
}
#pragma mark - Login Methods
-(void)identifyByPhone: (NSString*)phoneNumber
{
        [FIRAuth auth].settings.appVerificationDisabledForTesting = YES;
    [[FIRPhoneAuthProvider provider] verifyPhoneNumber: phoneNumber UIDelegate: nil completion: ^(NSString* _Nullable verificationID, NSError* _Nullable error)
    {
        if (error)
        {
            [JFTUtilities showErrorInAlert: error onView: self];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject: verificationID forKey: @"authVerificationID"];
            [[NSUserDefaults standardUserDefaults] setObject: phoneNumber forKey: @"UserSavedPhoneNumber"];
            if ([[NSUserDefaults standardUserDefaults] objectForKey: @"UserSavedAuthCode"] != nil)
                [self loginWithAuthCode: [[NSUserDefaults standardUserDefaults] objectForKey: @"UserSavedAuthCode"]];
            else
                self.authPassTF.hidden = NO;
        }
    }];
}
-(void)loginWithAuthCode: (NSString*)code
{
    NSString* verificationID = [[NSUserDefaults standardUserDefaults] objectForKey: @"authVerificationID"];
    FIRAuthCredential* credentials = [[FIRPhoneAuthProvider provider] credentialWithVerificationID: verificationID verificationCode: code];
    [[FIRAuth auth] signInWithCredential: credentials completion: ^(FIRAuthDataResult* _Nullable authResult, NSError* _Nullable error)
     {
        if (error)
        {
            [JFTUtilities showErrorInAlert: error onView: self];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject: code forKey: @"UserSavedAuthCode"];
            if (authResult == nil)
                return;
            FIRUser* user = authResult.user;
            [[[[JFTUtilities globalDatabaseReference] child: @"users"] child: user.uid] observeSingleEventOfType: FIRDataEventTypeValue withBlock: ^(FIRDataSnapshot* _Nonnull snapshot)
             {
                if ([snapshot exists])
                {
                    LocalUser = [JFTUser userFromJSON: snapshot.value andWithID: user.uid];
                    [self performSegueWithIdentifier: @"loginSeg" sender: self];
                }
                else
                {
                    LocalUser.ID = user.uid;
                    LocalUser.PhoneNumber = user.phoneNumber;
                    [self performSegueWithIdentifier: @"openRegistrationPage" sender: self];
                }
            } withCancelBlock: ^(NSError* _Nonnull error)
            {
                [JFTUtilities showErrorInAlert: error onView: self];
            }];
        }
    }];
}
@end
