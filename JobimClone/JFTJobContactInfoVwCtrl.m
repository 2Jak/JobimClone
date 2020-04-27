//
//  JFTJobContactInfoVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 25/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobContactInfoVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
#import "JFTJob.h"
@interface JFTJobContactInfoVwCtrl ()
<UITextFieldDelegate>
@end
@implementation JFTJobContactInfoVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    self.emailTF.delegate = self;
    self.phoneNumberTF.delegate = self;
    self.emailTF.text = LocalUser.Email;
    self.phoneNumberTF.text = LocalUser.PhoneNumber;
}
- (IBAction)onEmailDoneEditing:(id)sender
{
    LocalJob.Email = ((UITextField*)sender).text;
}
- (IBAction)onPhoneNumberDoneEditing:(id)sender
{
    LocalJob.PhoneNumber = ((UITextField*)sender).text;
}
-(void)viewWillDisappear:(BOOL)animated
{
    LocalJob.Email = self.emailTF.text;
    LocalJob.PhoneNumber = self.phoneNumberTF.text;
}
#pragma mark - TextField Controls
-(BOOL)textFieldShouldReturn: (UITextField*)textField
{
    return [textField endEditing: YES];
}
@end
