//
//  JFTMainTableVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTDetailedJobVwCtrl.h"
#import "JFTMainTableVwCtrl.h"
#import "JFTImageCacheStore.h"
#import "JFTLocalJobsStore.h"
#import "JFTJobTypeStore.h"
#import "JFTUtilities.h"
#import "JFTJobCell.h"
#import "JFTUser.h"
#import "JFTJob.h"
@interface JFTMainTableVwCtrl ()
<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate, UINavigationControllerDelegate>
@end
@implementation JFTMainTableVwCtrl
#pragma mark - Event Handlers
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear: animated];
    self.navigationItem.title = @"";
}
-(void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationItem.title = @"";
    [[NSNotificationCenter defaultCenter] addObserver: self selector:@selector(refresh) name:@"updateParent" object:nil];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeOpenMapView];
}
-(IBAction)onFilterButtonTouchInside: (id)sender
{
    [self performSegueWithIdentifier: @"openFilterPage" sender: self];
}
-(IBAction)onToggleMapButtonTouch: (id)sender
{
    [self performSegueWithIdentifier: @"returnToMapViewSegue" sender: self];
}
-(IBAction)onOpenSidebarButtonTouch: (id)sender
{
    [self performSegueWithIdentifier: @"openSidebarSegue" sender: self];
}
#pragma mark - UITableView Delegate Methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFTJob *job = nil;
    if (self.MyJobsPage == YES)
        job = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] FavouriteJobs][indexPath.row]];
    else
        job = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] DisplayedJobs][indexPath.row]];
    JFTJobCell *jobCell = [tableView dequeueReusableCellWithIdentifier:@"JFTJobCell" forIndexPath:indexPath];
    UIColor* jobColor = [[JFTJobTypeStore sharedStore] getColorForJobType: job.Type];
    jobCell.jobSlentedView.slentColor = jobColor;
    jobCell.jobTitleLbl.text = job.Title;
    jobCell.jobTypeImg.image = [UIImage imageNamed: [NSString stringWithFormat: @"JobTypeIcon%@White.png", job.Type] inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
    jobCell.jobTypeImg.circleBackgroundColor = [JFTUtilities darkenColor: jobColor];
    jobCell.jobSummaryLbl.text = job.Summary;
    jobCell.jobImageImg.image = job.Image;
    jobCell.jobLocationLbl.text = job.LiteralLocation;
    return jobCell;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.MyJobsPage)
        return [[JFTLocalJobsStore sharedStore] FavouriteJobs].count;
    else
        return [[JFTLocalJobsStore sharedStore] DisplayedJobs].count;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFTJob *job = nil;
    if (self.MyJobsPage == YES)
        job = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] FavouriteJobs][indexPath.row]];
    else
        job = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] DisplayedJobs][indexPath.row]];
    [self performSegueWithIdentifier: @"detailedView" sender: job];
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    if (self.MyJobsPage == YES)
        return [UIView new];
    UIButton* filterPageButton = [UIButton new];
    filterPageButton.frame = CGRectMake( 0.0f, 0.0f, self.tableView.bounds.size.width, 50.0f);
    [filterPageButton setImage: [UIImage imageNamed: @"FilterBarv2" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] forState: UIControlStateNormal];
    [filterPageButton addTarget: self action: @selector(onFilterButtonTouchInside:) forControlEvents: UIControlEventTouchUpInside];
    return filterPageButton;
}

- (CGFloat)tableView:(UITableView *)aTableView heightForHeaderInSection:(NSInteger)section
{
    if (self.MyJobsPage == YES)
        return 0.0f;
    return 50.0f;
}
#pragma mark - Swipe Actions
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView leadingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableArray* actionArray = [NSMutableArray new];
    JFTJob *selectedJob = nil;
    if (self.MyJobsPage == YES)
        selectedJob = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] FavouriteJobs][indexPath.row]];
    else
        selectedJob = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] DisplayedJobs][indexPath.row]];
    UIContextualAction* emailAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleNormal title: @"Email" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setEditing: NO animated: YES];
        });
        [self openJobApplicationEmailDialogForJob: selectedJob];
    }];
    emailAction.backgroundColor = UIColor.lightGrayColor;
    emailAction.image = [JFTUtilities convertImage: [UIImage imageNamed: @"EmailButton.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] toSize: CGSizeMake(50.0f, 50.0f)];
    [actionArray addObject: emailAction];
    UIContextualAction* callAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleNormal title: @"Call" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setEditing: NO animated: YES];
        });
        [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [NSString stringWithFormat: @"tel:%@", selectedJob.PhoneNumber]]];
    }];
    callAction.backgroundColor = UIColor.lightGrayColor;
    callAction.image = [JFTUtilities convertImage: [UIImage imageNamed: @"CallButton.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] toSize: CGSizeMake(50.0f, 50.0f)];
    [actionArray addObject: callAction];
    UIContextualAction* favAction;
    if (self.MyJobsPage == YES)
    {
        if ([[JFTLocalJobsStore sharedStore] isUserCreatedJob: selectedJob.ID] == NO)
        {
            favAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleNormal title: @"UnFav" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                         {
                [[JFTLocalJobsStore sharedStore] removeFromFavourites: selectedJob.ID];
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.tableView reloadData];
                });
            }];
            favAction.backgroundColor = UIColor.lightGrayColor;
            favAction.image = [JFTUtilities convertImage: [UIImage imageNamed: @"UnFavButton.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] toSize: CGSizeMake(50.0f, 50.0f)];
            [actionArray addObject: favAction];
        }
    }
    else
    {
        favAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleNormal title: @"Fav" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
                                         {
            [[JFTLocalJobsStore sharedStore] addToFavourites: selectedJob.ID];
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.tableView setEditing: NO animated: YES];
            });
        }];
        favAction.backgroundColor = UIColor.lightGrayColor;
        favAction.image = [JFTUtilities convertImage: [UIImage imageNamed: @"FavButton.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] toSize: CGSizeMake(50.0f, 50.0f)];
        [actionArray addObject: favAction];
    }
    return [UISwipeActionsConfiguration configurationWithActions: actionArray];
}
-(UISwipeActionsConfiguration *)tableView:(UITableView *)tableView trailingSwipeActionsConfigurationForRowAtIndexPath:(NSIndexPath *)indexPath
{
    JFTJob *selectedJob = nil;
    if (self.MyJobsPage == YES)
        selectedJob = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] FavouriteJobs][indexPath.row]];
    else
        selectedJob = [[JFTLocalJobsStore sharedStore] getJobByID: [[JFTLocalJobsStore sharedStore] DisplayedJobs][indexPath.row]];
    UIContextualAction* deleteAction = [UIContextualAction contextualActionWithStyle: UIContextualActionStyleNormal title: @"Delete" handler:^(UIContextualAction * _Nonnull action, __kindof UIView * _Nonnull sourceView, void (^ _Nonnull completionHandler)(BOOL))
    {
        if (self.MyJobsPage == YES)
            [[JFTLocalJobsStore sharedStore] removeJobByID: selectedJob.ID];
        else
            [[JFTLocalJobsStore sharedStore] blacklistAJob: selectedJob.ID];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
    deleteAction.backgroundColor = UIColor.lightGrayColor;
    deleteAction.image = [JFTUtilities convertImage: [UIImage imageNamed: @"DeleteButton.png" inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil] toSize: CGSizeMake(50.0f, 50.0f)];
    return [UISwipeActionsConfiguration configurationWithActions: @[deleteAction]];
}
#pragma mark - Navigation Control
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString: @"detailedView"])
    {
        JFTJob* sentJob = (JFTJob*)sender;
        JFTDetailedJobVwCtrl* detailVC = segue.destinationViewController;
        [detailVC loadJob: sentJob];
    }
}
-(IBAction)unwindToMainTableViewController: (UIStoryboardSegue*)unwindSegue
{
    
}
#pragma mark - Helper Methods
-(void)asMyJobsPage
{
    self.MyJobsPage = YES;
}
-(void)openJobApplicationEmailDialogForJob: (JFTJob*)job
{
    if ([MFMailComposeViewController canSendMail] == YES)
    {
        MFMailComposeViewController* jobApplicationMail = [MFMailComposeViewController new];
        jobApplicationMail.delegate = self;
        jobApplicationMail.title = [NSString stringWithFormat: @"Applicant: %@ for %@ position at %@ - JobID: %@", [NSString stringWithFormat: @"%@ %@", LocalUser.Name, LocalUser.LastName], job.Type, job.CompanyName, job.ID];
        [jobApplicationMail setMessageBody: @"" isHTML: NO];
        [jobApplicationMail setToRecipients: [NSArray arrayWithObject: job.Email]];
        [self presentViewController: jobApplicationMail animated: YES completion: nil];
    }
    else
    {
        NSLog(@"No Active Email Account!");
    }
}
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    switch (result)
    {
        case MFMailComposeResultCancelled:
            NSLog(@"Mail cancelled");
            break;
        case MFMailComposeResultSaved:
            NSLog(@"Mail saved");
            break;
        case MFMailComposeResultSent:
            NSLog(@"Mail sent");
            break;
        case MFMailComposeResultFailed:
            NSLog(@"Mail sent failure: %@", [error localizedDescription]);
            break;
        default:
            break;
    }
    [self dismissViewControllerAnimated: YES completion: nil];
}
-(void)refresh
{
    [self.tableView reloadData];
}
@end
