//
//  JFTMainMapVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 23/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTImageCacheStore.h"
#import "JFTJobMKAnnotation.h"
#import "JFTLocalJobsStore.h"
#import "JFTMainMapVwCtrl.h"
#import "JFTUtilities.h"
@interface JFTMainMapVwCtrl()
<MKMapViewDelegate>
@end
@implementation JFTMainMapVwCtrl
#pragma mark - Event Handlers
-(void)loadView
{
    [super loadView];
    self.mainMapView.delegate = self;
    for (JFTJob* job in [[JFTLocalJobsStore sharedStore] AllJobs])
        [JFTUtilities addJobPinToMKMapView: self.mainMapView theJob: job];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeOpenMapView];
}
- (IBAction)onTouchCenterToLocation:(id)sender
{
    [JFTUtilities centerViewForMKMapView: self.mainMapView forLocation: LocalLocation withSquareSizeOf: 500.0f];
}
-(IBAction)onToggleMapButtonTouch: (id)sender
{
    [self performSegueWithIdentifier: @"returnToMainViewSegue" sender: self];
}
-(IBAction)onOpenSidebarButtonTouch: (id)sender
{
    [self performSegueWithIdentifier: @"openSidebarSegue" sender: self];
}
#pragma mark - Map Controls
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation
{
    static NSString *identifier = @"JFTJobMKAnnotation";
    MKAnnotationView *annotationView = (MKAnnotationView *) [self.mainMapView dequeueReusableAnnotationViewWithIdentifier: identifier];
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
