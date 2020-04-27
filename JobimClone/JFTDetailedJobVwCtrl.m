//
//  JFTDetailedJobVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTDetailedJobVwCtrl.h"
#import "JFTImageCacheStore.h"
#import "JFTLocalJobsStore.h"
#import "JFTJobTypeStore.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
#import "JFTJob.h"
@interface JFTDetailedJobVwCtrl ()
<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UINavigationControllerDelegate, MKMapViewDelegate>
@property (weak, nonatomic) JFTJob* internalJob;
@end
@implementation JFTDetailedJobVwCtrl
#pragma mark - Event Handlers
-(void)viewDidLoad
{
    [super viewDidLoad];
    UIColor* jobColor = [[JFTJobTypeStore sharedStore] getColorForJobType: self.internalJob.Type];
    self.view.backgroundColor = jobColor;
    self.jobTypeImg.image = [UIImage imageNamed: [NSString stringWithFormat: @"JobTypeIcon%@White.png", self.internalJob.Type] inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
    self.jobTypeImg.circleBackgroundColor = [JFTUtilities darkenColor: jobColor];
    self.jobImg.image = self.internalJob.Image;
    self.jobDescriptionLbl.text = self.internalJob.Description;
    self.jobLocationLbl.text = self.internalJob.LiteralLocation;
    self.titleLbl.text = self.internalJob.Title;
    self.jobSlentedView.slentColor = [JFTUtilities lightenColor: jobColor];
    self.jobLocationMpVw.delegate = self;
    [JFTUtilities addJobPinToMKMapView: self.jobLocationMpVw theJob: self.internalJob];
    [JFTUtilities centerViewForMKMapView: self.jobLocationMpVw forLocation: self.internalJob.Location withSquareSizeOf: 100.0f];
}
-(void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//-----------Header Button Handlers----------//
-(IBAction)onExitButtonTouch: (UIButton*)sender
{
    [self performSegueWithIdentifier: @"returnToMainScreen" sender: self];
}
-(IBAction)onReportButtonTouch: (UIButton*)sender
{
    
}
//-----------Top Button Handlers-------------//
-(IBAction)onApplyByEmailButtonTouch: (UIButton*)sender
{
    [self openJobApplicationEmailDialogForJob: self.internalJob];
}
-(IBAction)onApplyByCallButtonTouch: (UIButton*)sender
{
    [[UIApplication sharedApplication] openURL: [NSURL URLWithString: [NSString stringWithFormat: @"tel:%@", self.internalJob.PhoneNumber]]];
}
-(IBAction)onApplyBySMSButtonTouch: (UIButton*)sender
{
    [self openJobApplicationSMSDialogForJob: self.internalJob];
}
//------------Lower Button Handlers----------//
-(IBAction)onDeleteButtonTouch: (UIButton*)sender
{
    [[JFTLocalJobsStore sharedStore] blacklistAJob: self.internalJob.ID];
    [self performSegueWithIdentifier: @"returnToMainScreen" sender: self];
}
-(IBAction)onShareButtonTouch: (UIButton*)sender
{
    //create a message
    NSURL* jobURL = [NSURL URLWithString: [NSString stringWithFormat: @"https://notjobim.co.il/jobid/%@", self.internalJob.ID]];
    // build an activity view controller
    UIActivityViewController *controller = [[UIActivityViewController alloc] initWithActivityItems: @[jobURL] applicationActivities:nil];
    // and present it
    [self presentActivityController: controller];
}
-(IBAction)onSimilarButtonTouch: (UIButton*)sender
{
}
-(IBAction)onFavButtonTouch: (UIButton*)sender
{
    [[JFTLocalJobsStore sharedStore] addToFavourites: self.internalJob.ID];
}
#pragma mark - Helper Methods
-(void)loadJob: (JFTJob*)job
{
    self.internalJob = job;
}
- (void)presentActivityController: (UIActivityViewController*)controller
{
    // for iPad: make the presentation a Popover
    controller.modalPresentationStyle = UIModalPresentationPopover;
    [self presentViewController: controller animated: YES completion: nil];
    UIPopoverPresentationController* popController = [controller popoverPresentationController];
    popController.permittedArrowDirections = UIPopoverArrowDirectionAny;
    popController.barButtonItem = self.navigationItem.leftBarButtonItem;
    // access the completion handler
    controller.completionWithItemsHandler = ^(NSString* activityType,
                                              BOOL completed,
                                              NSArray* returnedItems,
                                              NSError* error)
    {
        // react to the completion
        if (completed)
        {
            // user shared an item
            NSLog(@"We used activity type %@", activityType);
        }
        else
        {
            // user cancelled
            NSLog(@"We didn't want to share anything after all.");
        }

        if (error)
        {
            [JFTUtilities showErrorInAlert: error onView: self];
        }
    };
}
-(void)openJobApplicationSMSDialogForJob: (JFTJob*)job
{
    if ([MFMessageComposeViewController canSendText])
    {
       MFMessageComposeViewController* jobApplicationSMS = [MFMessageComposeViewController new];
       jobApplicationSMS.messageComposeDelegate = self;
       jobApplicationSMS.recipients = @[job.PhoneNumber];
       jobApplicationSMS.body = [NSString stringWithFormat: @"%@ here would like to apply as a %@ at %@ - JobID: %@"];
       // Present the view controller modally.
       [self presentViewController: jobApplicationSMS animated: YES completion: nil];
    }
    else
        NSLog(@"Message services are not available.");
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
#pragma mark - UIMessage Controls
-(void)mailComposeController: (MFMailComposeViewController*)controller didFinishWithResult: (MFMailComposeResult)result error: (NSError*)error
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
-(void)messageComposeViewController:(MFMessageComposeViewController*)controller
              didFinishWithResult: (MessageComposeResult)result
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark - Map Controls
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"JFTJobMKAnnotation";
    MKAnnotationView *annotationView = (MKAnnotationView *) [self.jobLocationMpVw dequeueReusableAnnotationViewWithIdentifier: identifier];
    if (annotationView == nil)
    {
        annotationView = [[MKAnnotationView alloc]initWithAnnotation: annotation reuseIdentifier: identifier];
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        annotationView.image = [UIImage imageNamed: [NSString stringWithFormat: @"JobMapPin%@.png", annotation.subtitle] inBundle: [NSBundle mainBundle] compatibleWithTraitCollection: nil];
    }
    else
    {
        annotationView.annotation = annotation;
    }
    
    return annotationView;
}
@end
