//
//  JFTJobCell.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//
#import "JFTCircularImageView.h"
#import "JFTSlentedView.h"
#import <UIKit/UIKit.h>
@interface JFTJobCell : UITableViewCell
@property (weak, nonatomic) IBOutlet JFTCircularImageView* jobTypeImg;
@property (weak, nonatomic) IBOutlet JFTSlentedView* jobSlentedView;
@property (weak, nonatomic) IBOutlet UIImageView* locationIcon;
@property (weak, nonatomic) IBOutlet UIImageView* jobImageImg;
@property (weak, nonatomic) IBOutlet UILabel* jobLocationLbl;
@property (weak, nonatomic) IBOutlet UILabel* jobSummaryLbl;
@property (weak, nonatomic) IBOutlet UILabel* jobTitleLbl;
@end
