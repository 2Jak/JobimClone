//
//  JFTPersonalEmailVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTPersonalEmailVwCtrl.h"
#import "JFTPersonalInfoVwCtrl.h"
#import "JFTCompletionLocker.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
@interface JFTPersonalEmailVwCtrl ()
<JFTCompletionLocker, UITextFieldDelegate>
@end
@implementation JFTPersonalEmailVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.emailTF.text = LocalUser.Email;
    self.emailTF.delegate = self;
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
- (IBAction)onEditingEndEmailTF: (UITextField*)sender
{
    NSString* input = sender.text;
    if (![input isEqualToString: LocalUser.Email])
    {
        LocalUser.Email = input;
        [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyEmail withValue: LocalUser.Email from: self];
    }
}
- (IBAction)onValueChangedAcceptSwitch: (UISwitch*)sender
{
    LocalUser.AcceptsPromo = sender.on;
    [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyAcceptsPromo withValue: [NSNumber numberWithBool: LocalUser.AcceptsPromo] from: self];
}
#pragma mark - Completion Locker Controls
-(BOOL)pageFillingCompleted
{
    NSString* email = self.emailTF.text;
    if (email != nil && ![email isEqualToString: @""])
        return YES;
    else
        return NO;
}
#pragma mark - TextField Controls
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    return [textField endEditing: YES];
}
@end
