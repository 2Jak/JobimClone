//
//  JFTFilterJobTypeVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 29/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTFilterJobTypeVwCtrl.h"
#import "JFTFilterQuerriable.h"
#import "JFTImageCacheStore.h"
#import "JFTLocalJobsStore.h"
#import "JFTJobTypeStore.h"
#import "JFTJobTypeCell.h"
@interface JFTFilterJobTypeVwCtrl ()
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, JFTFilterQuerriable>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (nonatomic) NSMutableArray* jobTypes;
@property (nonatomic) NSMutableArray* selectedJobs;
@end
@implementation JFTFilterJobTypeVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.searchBar.delegate = self;
    self.jobTypes = [[NSMutableArray alloc] initWithArray: [[JFTJobTypeStore sharedStore] AllItems]];
    self.selectedJobs = [NSMutableArray new];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
#pragma mark - Table Controls
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.jobTypes.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* jobType = self.jobTypes[indexPath.row];
    JFTJobTypeCell* jobTypeCell = [tableView dequeueReusableCellWithIdentifier:@"JFTJobTypeCell" forIndexPath:indexPath];
    jobTypeCell.jobTypeNameLbl.text = jobType;
    jobTypeCell.jobTypeImg.image = [UIImage imageNamed: [NSString stringWithFormat: @"JobTypeIcon%@Color.png", jobType] inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
    return jobTypeCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* jobType = self.jobTypes[indexPath.row];
    if ([self.selectedJobs containsObject: jobType])
    {
        [tableView cellForRowAtIndexPath: indexPath].accessoryType = UITableViewCellAccessoryNone;
        [self.selectedJobs removeObject: jobType];
    }
    else
    {
        [tableView cellForRowAtIndexPath: indexPath].accessoryType = UITableViewCellAccessoryCheckmark;
        [self.selectedJobs addObject: jobType];
    }
}
#pragma mark - SearchBar Controls
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([searchText isEqualToString: @""])
        self.jobTypes = [[NSMutableArray alloc] initWithArray: [[JFTJobTypeStore sharedStore] AllItems]];
    else
    {
        self.jobTypes = [NSMutableArray new];
        for (NSString* type in [[JFTJobTypeStore sharedStore] AllItems])
            if ([type localizedCaseInsensitiveContainsString: searchText])
            {
                [self.jobTypes addObject: type];
            }
    }
    [self.tableView reloadData];
}
#pragma mark - Run Filter Querry
- (void)runQuerry
{
    if (self.selectedJobs.count == 0)
        [[JFTLocalJobsStore sharedStore] filterDisplayedJobs: JFTFilterJobsByNone forValue: nil];
    else
        [[JFTLocalJobsStore sharedStore] filterDisplayedJobs: JFTFilterJobsByJobType forValue: self.selectedJobs];
}
@end
