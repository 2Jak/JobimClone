//
//  JFTDetailedJobVwCtrl.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTCircularImageView.h"
#import <MessageUI/MessageUI.h>
#import "JFTSlentedView.h"
#import <MapKit/MapKit.h>
#import <UIKit/UIKit.h>
@class JFTJob;
@interface JFTDetailedJobVwCtrl : UIViewController
@property (weak, nonatomic) IBOutlet JFTCircularImageView* jobTypeImg;
@property (weak, nonatomic) IBOutlet JFTSlentedView* jobSlentedView;
@property (weak, nonatomic) IBOutlet UILabel* jobDescriptionLbl;
@property (weak, nonatomic) IBOutlet MKMapView* jobLocationMpVw;
@property (weak, nonatomic) IBOutlet UILabel* jobLocationLbl;
@property (weak, nonatomic) IBOutlet UIImageView* jobImg;
@property (weak, nonatomic) IBOutlet UILabel* titleLbl;
-(void)loadJob: (JFTJob*)job;
@end
