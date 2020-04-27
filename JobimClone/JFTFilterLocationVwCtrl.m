//
//  JFTFilterLocationVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 31/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTFilterLocationVwCtrl.h"
#import "JFTSimpleTextLableCell.h"
#import "JFTFilterQuerriable.h"
#import "JFTLocalJobsStore.h"
#import <MapKit/MapKit.h>
#import "JFTUtilities.h"
@interface JFTFilterLocationVwCtrl ()
<UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, JFTFilterQuerriable, MKLocalSearchCompleterDelegate>
@property (nonatomic, strong) NSMutableArray* autoCompletionLocations;
@property (nonatomic, strong) MKLocalSearchCompleter* searchCompleter;
@property (weak, nonatomic) IBOutlet UISearchBar* searchBar;
@property (weak, nonatomic) IBOutlet UITableView* tableView;
@property (nonatomic, strong) NSString* selectedLocation;
@end
@implementation JFTFilterLocationVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    self.autoCompletionLocations = [NSMutableArray new];
    self.searchCompleter = [MKLocalSearchCompleter new];
    self.selectedLocation =  @"";
    self.searchCompleter.delegate = self;
    self.searchBar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
}
#pragma mark - Table Controls
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.autoCompletionLocations.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* locationName = self.autoCompletionLocations[indexPath.row];
    JFTSimpleTextLableCell* locationNameCell = [tableView dequeueReusableCellWithIdentifier:@"JFTSimpleTextLableCell" forIndexPath:indexPath];
    locationNameCell.simpleLable.text = locationName;
    return locationNameCell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString* locationName = self.autoCompletionLocations[indexPath.row];
    self.selectedLocation = locationName;
}
#pragma mark - SearchBar Controls
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if (![searchText isEqualToString: @""])
        self.searchCompleter.queryFragment = searchText;
}
-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    self.selectedLocation = searchBar.text;
}
#pragma mark - MKSearch Completion Handler
-(void)completerDidUpdateResults:(MKLocalSearchCompleter *)completer
{
    self.autoCompletionLocations = [NSMutableArray new];
    for (MKLocalSearchCompletion* result in completer.results)
         [self.autoCompletionLocations addObject: result.title];
    [self.tableView reloadData];
}
-(void)completer:(MKLocalSearchCompleter *)completer didFailWithError:(NSError *)error
{
    [JFTUtilities showErrorInAlert: error onView: self];
}
#pragma mark - Run Filter Querry
- (void)runQuerry
{
    if ([self.selectedLocation isEqualToString: @""])
        [[JFTLocalJobsStore sharedStore] filterDisplayedJobs: JFTFilterJobsByNone forValue: nil];
    else
        [[JFTLocalJobsStore sharedStore] filterDisplayedJobs: JFTFilterJobsByLocation forValue: @[self.selectedLocation]];
}
@end
