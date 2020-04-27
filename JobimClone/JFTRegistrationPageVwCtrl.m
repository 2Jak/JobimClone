//
//  JFTRegistrationPageVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 05/04/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTRegistrationPageVwCtrl.h"
#import "JFTPersonalInfoVwCtrl.h"
@interface JFTRegistrationPageVwCtrl ()
@end
@implementation JFTRegistrationPageVwCtrl
#pragma mark - Event Handlers
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [((JFTPersonalInfoVwCtrl*)self.viewControllers.firstObject) asRegistrationPage];
}
@end
