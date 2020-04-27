//
//  JFTCircularImageView.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 25/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTCircularImageView.h"
#import "JFTUtilities.h"
#import "JFTUser.h"
@interface JFTCircularImageView()
@property (nonatomic, strong) CAShapeLayer* backgroundLayer;
@property (nonatomic, strong) CALayer* imageLayer;
@end
@implementation JFTCircularImageView
#pragma mark - Event Handlers
-(void)layoutSubviews
{
    [super layoutSubviews];
    if (self.image == nil)
        if (LocalUser.Image != nil)
            self.image = LocalUser.Image;
    [self buildBackgroundLayer];
    [self buildImageLayer];
    [self loadImageIntoView];
}
#pragma mark - Draw Methods
-(void)buildBackgroundLayer
{
    if (self.backgroundLayer == nil)
    {
        self.backgroundLayer = [CAShapeLayer new];
        [self.layer addSublayer: self.backgroundLayer];
        float dx = self.LineWidth / 2.0f;
        CGRect rect = CGRectInset(self.bounds, dx, dx);
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect: rect];
        self.backgroundLayer.path = path.CGPath;
        self.backgroundLayer.lineWidth = 1.0f;
        self.backgroundLayer.fillColor = self.circleBackgroundColor.CGColor;
        self.backgroundLayer.strokeColor = self.strokeColor.CGColor;
    }
    
    self.backgroundLayer.frame = self.bounds;
}
-(void)buildImageLayer
{
    if (self.imageLayer == nil)
    {
        CAShapeLayer* mask = [CAShapeLayer new];
        float dx = self.LineWidth + 3.0f;
        CGRect rect = CGRectInset(self.bounds, dx, dx);
        UIBezierPath* path = [UIBezierPath bezierPathWithOvalInRect: rect];
        mask.path = path.CGPath;
        mask.fillColor = UIColor.blackColor.CGColor;
        mask.frame = self.bounds;
        [self.layer addSublayer: mask];
        self.imageLayer = [CALayer new];
        self.imageLayer.frame = self.bounds;
        self.imageLayer.mask = mask;
        self.imageLayer.contentsGravity = kCAGravityResizeAspectFill;
        [self.layer addSublayer: self.imageLayer];
    }
}
#pragma mark - Data Controls
-(void)loadImageIntoView
{
    UIImage* contentImage = nil;
    if ((contentImage = self.image))
        self.imageLayer.contents = (__bridge id _Nullable)(contentImage.CGImage);
}
@end
