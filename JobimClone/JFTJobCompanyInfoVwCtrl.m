//
//  JFTJobCompanyInfoVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobCompanyInfoVwCtrl.h"
#import "JFTJobInfoVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTJobCompanyInfoVwCtrl ()
<UITextFieldDelegate>
@end
@implementation JFTJobCompanyInfoVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.branchNameTF.delegate = self;
    self.companyNameTF.delegate = self;
    self.branchNameTF.text = LocalJob.BranchName;
    self.companyNameTF.text = LocalJob.CompanyName;
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
- (IBAction)onEditingEndCompanyNameTF:(id)sender
{
    LocalJob.CompanyName = ((UITextField*)sender).text;
}
- (IBAction)onEditingEndBranchNameTF:(id)sender
{
    LocalJob.BranchName = ((UITextField*)sender).text;
}
#pragma mark - TextField Controls
-(BOOL)textFieldShouldReturn: (UITextField*)textField
{
    return [textField endEditing: YES];
}
@end
