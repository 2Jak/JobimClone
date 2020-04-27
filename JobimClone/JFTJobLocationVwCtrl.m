//
//  JFTJobLocationVwCtrl.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 19/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTJobLocationVwCtrl.h"
#import "JFTJobInfoVwCtrl.h"
#import "JFTUtilities.h"
#import "JFTJob.h"
@interface JFTJobLocationVwCtrl ()
<UISearchBarDelegate>
@end
@implementation JFTJobLocationVwCtrl
#pragma mark - Event Handlers
- (void)viewDidLoad
{
    [super viewDidLoad];
    self.jobAddressSrchBr.delegate = self;
    [JFTUtilities addressFromLocation: LocalJob.Location andSender: self.jobAddressSrchBr];
    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTouchMap:)];
    tapRecognizer.numberOfTapsRequired = 1;
    tapRecognizer.numberOfTouchesRequired = 1;
    [self.jobLocationMpVw addGestureRecognizer:tapRecognizer];
    [JFTUtilities setViewControllerNavigationBarFor: self with: JFTNavBarLeftButtonTypeOpenSideBar and: JFTNavBarRightButtonTypeAdd];
}
#pragma mark - SearchBar Controls
-(void)searchBarTextDidEndEditing:(UISearchBar *) searchBar
{
    LocalJob.LiteralLocation = searchBar.text;
    [JFTUtilities locationFromAddress: searchBar.text andSender: LocalJob.Location];
}
#pragma mark - Gesture Recognizer Controls
-(IBAction)didTouchMap:(UITapGestureRecognizer*) recognizer
{
    CGPoint touchPoint = [recognizer locationInView: self.jobLocationMpVw];
    CLLocationCoordinate2D touchLocation = [self.jobLocationMpVw convertPoint: touchPoint toCoordinateFromView: self.view];
    [JFTUtilities addressFromLocation: [[CLLocation alloc] initWithLatitude: touchLocation.latitude longitude: touchLocation.longitude] andSender: self.jobAddressSrchBr];
    LocalJob.Location = [[CLLocation alloc] initWithLatitude: touchLocation.latitude longitude: touchLocation.longitude];
    NSLog(@"%@", LocalJob.LiteralLocation);
    NSLog(@"%@", [LocalJob.LiteralLocation class]);
    [JFTUtilities addressFromLocation: LocalJob.Location andSender: LocalJob.LiteralLocation];
    [self.view setNeedsDisplay];
}
@end
