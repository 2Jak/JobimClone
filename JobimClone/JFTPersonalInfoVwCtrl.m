//
//  JFTPersonalInfoVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTPersonalInfoVwCtrl.h"
#import "JFTCompletionLocker.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
@interface JFTPersonalInfoVwCtrl ()
<UITabBarControllerDelegate>
@end
@implementation JFTPersonalInfoVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    self.isRegistrationPage = NO;
    self.delegate = self;
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if (self.isRegistrationPage == YES)
        [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
    else
        [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeNone];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0.0f, 60.0f, self.view.frame.size.width, 45.0f);
}
-(IBAction)onOpenSidebarButtonTouch: (id)sender
{
    if (self.isRegistrationPage == YES)
    {
        [JFTUtilities shoeAlertForText: @"Please Finish the Registeration First!" onView: self];
    }
    else
        [self performSegueWithIdentifier: @"openSidebarSegue" sender: self];
}
-(IBAction)onAddButtonTouch: (id)sender
{
    NSString* key = [[[JFTUtilities globalDatabaseReference] child:@"users"] child: LocalUser.ID].key;
    NSDictionary* jobServerPacket = @{[@"/users/" stringByAppendingString: key]:[JFTUser JSONFromUser: LocalUser]};
    [[JFTUtilities globalDatabaseReference] updateChildValues: jobServerPacket withCompletionBlock: ^(NSError * _Nullable error, FIRDatabaseReference * _Nonnull ref)
    {
        if (error)
        {
            [JFTUtilities showErrorInAlert: error onView: self];
        }
        else
        {
            [self performSegueWithIdentifier: @"finishRegistration" sender: self];
        }
    }];
}
#pragma mark - TabBar Controls
-(BOOL)tabBarController: (UITabBarController*)tabBarController shouldSelectViewController: (UIViewController*)viewController
{
    if (self.isRegistrationPage == YES)
    {
        UIViewController<JFTCompletionLocker>* castViewController = (UIViewController<JFTCompletionLocker>*)self.selectedViewController;
        if ([castViewController pageFillingCompleted] == NO)
            return NO;
        else
            return YES;
    }
    else
        return YES;
}
#pragma mark - Helper Methods
-(void)asRegistrationPage
{
    self.isRegistrationPage = YES;
}
-(BOOL)filledAllForms
{
    for (UIViewController<JFTCompletionLocker>* viewCtrl in self.viewControllers)
        if ([viewCtrl pageFillingCompleted] == NO)
            return NO;
    return YES;
}
@end
