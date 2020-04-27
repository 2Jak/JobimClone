//
//  JFTCircularImageView.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 25/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN
IB_DESIGNABLE
@interface JFTCircularImageView : UIView
@property (nonatomic, strong) IBInspectable UIColor* circleBackgroundColor;
@property (nonatomic, strong) IBInspectable UIColor* strokeColor;
@property (nonatomic, strong) IBInspectable UIImage* image;
@property (nonatomic) IBInspectable float LineWidth;
@end

NS_ASSUME_NONNULL_END
