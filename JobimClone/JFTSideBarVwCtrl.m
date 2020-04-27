//
//  JFTSideBarVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTMainTableVwCtrl.h"
#import "JFTSideBarVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
@interface JFTSideBarVwCtrl ()
@end
@implementation JFTSideBarVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    if ([LocalUser.Name isEqualToString: @""])
        self.greetingLabel.text = @"Hello Guest";
    else
        self.greetingLabel.text = [NSString stringWithFormat: @"Hello %@", LocalUser.Name];
    UIPanGestureRecognizer* panLeftGestureRec = [[UIPanGestureRecognizer alloc] initWithTarget: self action: @selector(dismissOnPanLeft:)];
    panLeftGestureRec.maximumNumberOfTouches = 1;
    [self.view addGestureRecognizer: panLeftGestureRec];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    if ([LocalUser.Name isEqualToString: @""])
        self.greetingLabel.text = @"Hello Guest";
    else
        self.greetingLabel.text = [NSString stringWithFormat: @"Hello %@", LocalUser.Name];
}
#pragma mark - Navigation Controls
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"myJobsSegue"])
    {
        UINavigationController* mainNavController = (UINavigationController*)segue.destinationViewController;
        JFTMainTableVwCtrl* findJobsAsMyJobs = (JFTMainTableVwCtrl*)mainNavController.viewControllers.firstObject;
        [findJobsAsMyJobs asMyJobsPage];
    }
}
-(void)dismissOnPanLeft: (UIPanGestureRecognizer*)gestureRecognizer
{
    CGPoint velocity = [gestureRecognizer velocityInView: self.view];
    if (velocity.x < 0 && velocity.y == 0)
        [self dismissViewControllerAnimated: YES completion: nil];
}
@end
