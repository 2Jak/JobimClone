//
//  JFTJobTypeTblVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobTypeTblVwCtrl.h"
#import "JFTImageCacheStore.h"
#import "JFTJobInfoVwCtrl.h"
#import "JFTJobTypeStore.h"
#import "JFTJobTypeCell.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTJobTypeTblVwCtrl ()
@end
@implementation JFTJobTypeTblVwCtrl
#pragma mark - Event Handlers
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    [self.tableView reloadData];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
/*-(void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    //self.tableView.frame = CGRectMake(0.0f, 40.0f, self.tableView.frame.size.width, self.tableView.frame.size.height);
    [self.tableView layoutIfNeeded];
}*/
#pragma mark - Table view data source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[JFTJobTypeStore sharedStore] AllItems].count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* jobType = [[JFTJobTypeStore sharedStore] AllItems][indexPath.row];
    JFTJobTypeCell* jobTypeCell = [tableView dequeueReusableCellWithIdentifier:@"JFTJobTypeCell" forIndexPath:indexPath];
    jobTypeCell.jobTypeNameLbl.text = jobType;
    jobTypeCell.jobTypeImg.image = [UIImage imageNamed: [NSString stringWithFormat: @"JobTypeIcon%@Color.png", jobType] inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
    return jobTypeCell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* jobType = [[JFTJobTypeStore sharedStore] AllItems][indexPath.row];
    if ([LocalJob.Type isEqualToString: jobType])
    {
        [tableView cellForRowAtIndexPath: indexPath].accessoryType = UITableViewCellAccessoryNone;
        LocalJob.Type = @"";
    }
    else
    {
        [tableView cellForRowAtIndexPath: indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        LocalJob.Type = jobType;
    }
}
@end
