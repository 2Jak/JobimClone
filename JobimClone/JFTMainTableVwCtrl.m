//
//  JFTMainTableVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTMainTableVwCtrl.h"
#import "JFTLocalJobsStore.h"
#import "JFTImageCacheStore.h"
#import "JFTJobCell.h"
#import "JFTJob.h"
@interface JFTMainTableVwCtrl ()
<UITableViewDataSource,UITableViewDelegate>
@end
@implementation JFTMainTableVwCtrl
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFTJob *job = [JFTLocalJobsStore sharedStore].AllItems[indexPath.row];
    JFTJobCell *jobCell = [tableView dequeueReusableCellWithIdentifier:@"JFTJobCell" forIndexPath:indexPath];
    jobCell.jobTitleLbl.text = job.Title;
    jobCell.jobTypeImg.image = [[JFTImageCacheStore sharedStore] imageForKey:job.Type];
    jobCell.jobSummaryLbl.text = job.Summary;
    jobCell.jobImageImg.image = job.Image;
    jobCell.locationIcon.image = [[JFTImageCacheStore sharedStore] imageForKey:@"LocationIcon"];
    jobCell.jobLocationLbl.text = job.LiteralLocation;
    return jobCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[JFTLocalJobsStore sharedStore]AllItems]count];
}
@end
