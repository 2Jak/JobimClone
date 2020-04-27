//
//  JFTJobInfoVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTLocalJobsStore.h"
#import "JFTJobInfoVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTJobInfoVwCtrl ()
@end
@implementation JFTJobInfoVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0.0f, 60.0f, self.view.frame.size.width, 45.0f);
    self.moreNavigationController.view.backgroundColor = self.tabBar.backgroundColor;
}
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear: animated];
    NSLog(@"%@", LocalJob.description);
}
-(IBAction)onOpenSidebarButtonTouch: (id)sender
{
    [self performSegueWithIdentifier: @"openSidebarSegue" sender: self];
}
-(IBAction)onAddButtonTouch: (id)sender
{
    [[JFTLocalJobsStore sharedStore] addLocalJob];
}
@end
