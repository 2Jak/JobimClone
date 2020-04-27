//
//  JFTNavControllerSegue.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 17/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTNavControllerSegue.h"
#import "JFTSideBarVwCtrl.h"
@implementation JFTNavControllerSegue
-(void)perform
{
    if ([self.sourceViewController isKindOfClass: [JFTSideBarVwCtrl class]])
    {
        JFTSideBarVwCtrl* castSource = self.sourceViewController;
        [castSource.ParentCallerReference.navigationController pushViewController: self.destinationViewController animated:YES];
        [castSource dismissViewControllerAnimated: NO completion: nil];
    }
    else
        [self.sourceViewController.navigationController pushViewController: self.destinationViewController animated: YES];
}
@end
