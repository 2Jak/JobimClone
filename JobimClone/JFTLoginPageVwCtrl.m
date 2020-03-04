//
//  JFTLoginPageVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTLoginPageVwCtrl.h"
#import "JFTJobTypeStore.h"
#import "JFTImageCacheStore.h"
@implementation JFTLoginPageVwCtrl
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:(BOOL)animated];
    [[JFTJobTypeStore sharedStore] AllItems];
    [[JFTImageCacheStore sharedStore]loadLocalImages];
}
- (IBAction)onPhoneValueChange:(id)sender
{
}
- (IBAction)onAuthPassValueChange:(id)sender
{
}
@end
