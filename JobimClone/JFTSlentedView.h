//
//  JFTSlentedView.h
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 01/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
IB_DESIGNABLE
@interface JFTSlentedView : UIView
@property (nonatomic) IBInspectable BOOL BottomRightSlope;
@property (nonatomic) IBInspectable BOOL BottomLeftSlope;
@property (nonatomic) IBInspectable UIColor* slentColor;
@property (nonatomic) IBInspectable BOOL TopRightSlope;
@property (nonatomic) IBInspectable BOOL TopLeftSlope;
@property (nonatomic) IBInspectable BOOL Horizontal;
@property (nonatomic) IBInspectable float Magnitude;
@end
