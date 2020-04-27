//
//  JFTNameTabVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTCompletionLocker.h"
#import "JFTNameTabVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
@interface JFTNameTabVwCtrl ()
<UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIGestureRecognizerDelegate, JFTCompletionLocker, UITextFieldDelegate>
@end
@implementation JFTNameTabVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    if (LocalUser.Image != nil)
        self.selfieImg.image = LocalUser.Image;
    UITapGestureRecognizer* tapOnImageRecognizer = [[UITapGestureRecognizer alloc] initWithTarget: self action: @selector(onImageTap:)];
    self.firstNameTF.text = LocalUser.Name;
    self.lastNameTF.text = LocalUser.LastName;
    self.firstNameTF.delegate = self;
    self.lastNameTF.delegate = self;
    tapOnImageRecognizer.numberOfTapsRequired = 1;
    tapOnImageRecognizer.numberOfTouchesRequired = 1;
    [self.selfieImg addGestureRecognizer: tapOnImageRecognizer];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
- (IBAction)onEditingEndFirstNameTF: (UITextField*)sender
{
    NSString* input = sender.text;
    if (![input isEqualToString: LocalUser.Name])
    {
        LocalUser.Name = input;
        [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyName withValue: LocalUser.Name from: self];
    }
}
- (IBAction)onEditingEndLastNameTF: (UITextField*)sender
{
    NSString* input = sender.text;
    if (![input isEqualToString: LocalUser.LastName])
    {
        LocalUser.LastName = ((UITextField*)sender).text;
        [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyLastName withValue: LocalUser.LastName from: self];
    }
}
#pragma mark - Gesture Recognizer Controls
-(void)onImageTap: (UITapGestureRecognizer*)recognizer
{
    UIImagePickerController *imgPicker = [UIImagePickerController new];
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    }
    else
    {
        imgPicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    imgPicker.delegate = self;
    imgPicker.allowsEditing = YES;
    [self presentViewController:imgPicker animated:YES completion:nil];
}
#pragma mark - ImagePicker Controls
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    UIImage *image = info[UIImagePickerControllerEditedImage];
    self.selfieImg.image = image;
    LocalUser.Image = image;
    [JFTUtilities passToDatabaseUpdateIfNotRegistrationPage: JFTUserPropertyName withValue: LocalUser.Image from: self];
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Completion Locker Controls
-(BOOL)pageFillingCompleted
{
    NSString* firstName = self.firstNameTF.text;
    NSString* lastName = self.lastNameTF.text;
    BOOL completeFirstName = firstName != nil && ![firstName isEqualToString: @""];
    BOOL completeLastName = lastName != nil && ![lastName isEqualToString: @""];
    if (completeFirstName == YES && completeLastName == YES)
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
