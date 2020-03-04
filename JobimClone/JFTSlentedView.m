//
//  JFTSlentedView.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 01/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTSlentedView.h"

@implementation JFTSlentedView
- (void)drawRect:(CGRect)rect
{
    [self drawSideSlint:rect];
}

-(void)drawSideSlint: (CGRect)frame
{
    UIBezierPath *path = [UIBezierPath new];
    CGPoint topLeft = frame.origin;
    CGPoint topRight = CGPointMake((float)frame.size.width  * (3.0f/5.0f), frame.origin.y);
    CGPoint bottomLeft = CGPointMake(frame.origin.x, frame.size.height);
    CGPoint bottomRight = CGPointMake(frame.size.width, frame.size.height);
    [path moveToPoint:topLeft];
    [path addLineToPoint:topRight];
    [path addLineToPoint:bottomRight];
    [path addLineToPoint:bottomLeft];
    [path addLineToPoint:topLeft];
    [[UIColor whiteColor] setFill];
    path.lineWidth = 1;
    [[UIColor whiteColor] setStroke];
    [path stroke];
}
@end
