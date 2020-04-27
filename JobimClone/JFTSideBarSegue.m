//
//  JFTSideBarSegue.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTSideBarVwCtrl.h"
#import "JFTSideBarSegue.h"
@implementation JFTSideBarSegue
-(void)perform
{
    JFTSideBarVwCtrl* sideBar = self.destinationViewController;
    sideBar.ParentCallerReference = self.sourceViewController;
    [self.sourceViewController presentViewController: self.destinationViewController animated: YES completion: ^{
        [self.sourceViewController.view setNeedsDisplay];
    }];
}
@end
