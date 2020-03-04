//
//  JFTJobCell.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 03/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JFTJobCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *jobTitleLbl;
@property (weak, nonatomic) IBOutlet UIImageView *jobTypeImg;
@property (weak, nonatomic) IBOutlet UILabel *jobSummaryLbl;
@property (weak, nonatomic) IBOutlet UIImageView *jobImageImg;
@property (weak, nonatomic) IBOutlet UIImageView *locationIcon;
@property (weak, nonatomic) IBOutlet UILabel *jobLocationLbl;
@end
