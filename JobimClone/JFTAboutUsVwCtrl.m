//
//  JFTAboutUsVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 22/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTAboutUsVwCtrl.h"
#import "JFTUtilities.h"
@interface JFTAboutUsVwCtrl ()
@end
@implementation JFTAboutUsVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeNone];
}
-(IBAction)onOpenSidebarButtonTouch: (id)sender
{
    [self performSegueWithIdentifier: @"openSidebarSegue" sender: self];
}
@end
