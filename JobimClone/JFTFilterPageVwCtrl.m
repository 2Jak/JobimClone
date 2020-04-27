//
//  JFTFilterPageVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 29/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTFilterPageVwCtrl.h"
#import "JFTFilterQuerriable.h"

@interface JFTFilterPageVwCtrl ()
@end
@implementation JFTFilterPageVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
}
-(void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.tabBar.frame = CGRectMake(0.0f, 0.0f, self.view.frame.size.width, 100.0f);
}
- (IBAction)cancelFilterQuerry:(id)sender
{
    [self dismissViewControllerAnimated: YES completion: nil];
}
- (IBAction)runFilterQuerryForCurrentPage:(id)sender
{
    [((UIViewController<JFTFilterQuerriable>*)self.selectedViewController) runQuerry];
    [self dismissViewControllerAnimated: YES completion:^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:@"updateParent" object:nil];
        });
    }];
}
@end
