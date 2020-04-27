//
//  JFTFilterCompanyVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 31/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTFilterCompanyVwCtrl.h"
#import "JFTSimpleTextLableCell.h"
#import "JFTFilterQuerriable.h"
#import "JFTLocalJobsStore.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTFilterCompanyVwCtrl ()
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, JFTFilterQuerriable>
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (strong, nonatomic) NSMutableArray* companies;
@property (strong, nonatomic) NSString* selectedCompany;
@end
@implementation JFTFilterCompanyVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    self.companies = [NSMutableArray new];
    self.selectedCompany = @"";
    for (JFTJob* job in [[JFTLocalJobsStore sharedStore] AllJobs])
        if (![self.companies containsObject: job.CompanyName])
            [self.companies addObject: job.CompanyName];
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark - Table Controls
-(NSInteger)tableView: (UITableView*)tableView numberOfRowsInSection: (NSInteger)section
{
    return self.companies.count;
}
-(UITableViewCell*)tableView: (UITableView*)tableView cellForRowAtIndexPath: (NSIndexPath*)indexPath
{
    NSString* companyName = self.companies[indexPath.row];
    JFTSimpleTextLableCell* companyNameCell = [tableView dequeueReusableCellWithIdentifier: @"JFTSimpleTextLableCell" forIndexPath: indexPath];
    companyNameCell.simpleLable.text = companyName;
    return companyNameCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* companyName = self.companies[indexPath.row];
    self.selectedCompany = companyName;
}
#pragma mark - SearchBar Controls
-(void)searchBar: (UISearchBar*)searchBar textDidChange: (NSString*)searchText
{
    if ([searchText isEqualToString: @""])
    {
        for (JFTJob* job in [[JFTLocalJobsStore sharedStore] AllJobs])
            if (![self.companies containsObject: job.CompanyName])
                [self.companies addObject: job.CompanyName];
    }
    else
    {
        self.companies = [NSMutableArray new];
        for (JFTJob* job in [[JFTLocalJobsStore sharedStore] AllJobs])
            if ([job.CompanyName containsString: searchText])
                [self.companies addObject: job.CompanyName];
    }
    [self.tableView reloadData];
}
#pragma mark - Run Filter Querry
- (void)runQuerry
{
    if ([self.selectedCompany isEqualToString: @""])
        [[JFTLocalJobsStore sharedStore] filterDisplayedJobs: JFTFilterJobsByNone forValue: nil];
    else
        [[JFTLocalJobsStore sharedStore] filterDisplayedJobs: JFTFilterJobsByCompanyName forValue: @[self.selectedCompany]];
}
@end
