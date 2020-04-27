//
//  JFTPersonalLocationVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTPersonalLocationVwCtrl.h"
#import "JFTPersonalInfoVwCtrl.h"
#import "JFTCompletionLocker.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
@interface JFTPersonalLocationVwCtrl ()
<JFTCompletionLocker, UITextFieldDelegate>
@end
@implementation JFTPersonalLocationVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.addressTF.delegate = self;
    [JFTUtilities addressFromLocation: LocalUser.Location andSender: self.addressTF];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
- (IBAction)onEditingEndAddressTF:(id)sender
{
    [JFTUtilities locationFromAddress: ((UITextField*)sender).text andSender: LocalUser.Location onCompletion: ^{
        [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyLocation withValue: LocalUser.Location from: self];
    }];
}
#pragma mark - Completion Locker Controls
-(BOOL)pageFillingCompleted
{
    NSString* address = self.addressTF.text;
    if (address != nil && ![address isEqualToString: @""])
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
