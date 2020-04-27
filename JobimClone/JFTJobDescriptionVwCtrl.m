//
//  JFTJobDescriptionVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobDescriptionVwCtrl.h"
#import "JFTJobInfoVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTJobDescriptionVwCtrl ()
<UITextViewDelegate, UITextFieldDelegate>
@end
@implementation JFTJobDescriptionVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jobDescriptionTxtVw.delegate = self;
    self.jobTitleTF.delegate = self;
    self.jobTitleTF.text = LocalJob.Title;
    self.jobDescriptionTxtVw.text = LocalJob.Description;
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
- (IBAction)onEditingEndJobTitleTF:(id)sender
{
    LocalJob.Title = ((UITextField*)sender).text;
}
#pragma mark - TextView Controls
-(void)textViewDidEndEditing:(UITextView *)textView
{
    LocalJob.Description = textView.text;
}
- (BOOL)textView: (UITextView*)textView shouldChangeTextInRange: (NSRange)range replacementText: (NSString*)text
{

    if([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }

    return YES;
}
#pragma mark - TextField Controls
-(BOOL)textFieldShouldReturn: (UITextField*)textField
{
    return [textField endEditing: YES];
}
@end
