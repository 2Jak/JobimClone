//
//  JFTSlentedView.m
//  JobimClone
//
//  Created by hyperactive hi-tech ltd on 01/03/2020.
//  Copyright © 2020 hyperactive hi-tech ltd. All rights reserved.
//

#import "JFTSlentedView.h"
@implementation JFTSlentedView
#pragma mark - Event Handlers
-(instancetype)init
{
    if (self = [super init])
    {
        [super setBackgroundColor: [UIColor clearColor]];
        [super setTintColor: [UIColor clearColor]];
        [self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}
-(instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame: frame])
    {
        [super setBackgroundColor: [UIColor clearColor]];
        [super setTintColor: [UIColor clearColor]];
        [self setBackgroundColor: [UIColor clearColor]];
    }
    return self;
}
- (void)drawRect:(CGRect)rect
{
    [self drawSlope: rect];
}
#pragma mark - Property Setters
-(void)setTopLeftSlope: (BOOL)TopLeftSlope
{
    if (TopLeftSlope == YES)
    {
        [self setAllSlopesToFalse];
        _TopLeftSlope = YES;
    }
}
-(void)setTopRightSlope: (BOOL)TopRightSlope
{
    if (TopRightSlope == YES)
    {
        [self setAllSlopesToFalse];
        _TopRightSlope = YES;
    }
}
-(void)setBottomRightSlope: (BOOL)BottomRightSlope
{
    if (BottomRightSlope == YES)
    {
        [self setAllSlopesToFalse];
        _BottomRightSlope = YES;
    }
}
-(void)setBottomLeftSlope: (BOOL)BottomLeftSlope
{
    if (BottomLeftSlope == YES)
    {
        [self setAllSlopesToFalse];
        _BottomLeftSlope = YES;
    }
}
-(void)setMagnitude: (float)Magnitude
{
    if (Magnitude > 100.0f)
    {
        _Magnitude = 100.0f;
        return;
    }
    if (Magnitude < 1.0f)
    {
        _Magnitude = 1.0f;
        return;
    }
    _Magnitude = Magnitude;
}
#pragma mark - Draw Functions
-(void)drawSlope: (CGRect)frame
{
    UIBezierPath *path = [UIBezierPath new];
    NSArray* viewCorners = [self calculatePointsForCurrentBounds: frame];
    [path moveToPoint: [viewCorners[0] CGPointValue]];
    [path addLineToPoint: [viewCorners[1] CGPointValue]];
    [path addLineToPoint: [viewCorners[3] CGPointValue]];
    [path addLineToPoint: [viewCorners[2] CGPointValue]];
    [path addLineToPoint: [viewCorners[0] CGPointValue]];
    [self.slentColor setFill];
    path.lineWidth = 1;
    [self.slentColor setStroke];
    [path stroke];
    [path fill];
}
#pragma mark - Helper Methods
-(void)setAllSlopesToFalse
{
    _TopLeftSlope = NO;
    _TopRightSlope = NO;
    _BottomRightSlope = NO;
    _BottomLeftSlope = NO;
}
-(NSArray*)calculatePointsForCurrentBounds: (CGRect)bounds
{
    NSMutableArray* pointsArray = [NSMutableArray new];
    CGPoint topLeft = bounds.origin;
    CGPoint topRight = CGPointMake(bounds.size.width, bounds.origin.y);
    CGPoint bottomLeft = CGPointMake(bounds.origin.x, bounds.size.height);
    CGPoint bottomRight = CGPointMake(bounds.size.width, bounds.size.height);
    CGPoint* changedCorner = [self returnCorrectPointFromPoints: &topLeft andPointB: &topRight andPointC: &bottomLeft andPointD: &bottomRight];
    *changedCorner = (self.Horizontal) ? CGPointMake([self calculateNewAxisPositionFor: ((CGPoint)*changedCorner).x], ((CGPoint)*changedCorner).y) : CGPointMake(((CGPoint)*changedCorner).x, [self calculateNewAxisPositionFor: ((CGPoint)*changedCorner).y]);
    [pointsArray addObject: [NSValue valueWithCGPoint: topLeft]];
    [pointsArray addObject: [NSValue valueWithCGPoint: topRight]];
    [pointsArray addObject: [NSValue valueWithCGPoint: bottomLeft]];
    [pointsArray addObject: [NSValue valueWithCGPoint: bottomRight]];
    return [pointsArray copy];
}
-(CGFloat)calculateNewAxisPositionFor: (CGFloat)position
{
    if (position == 0.0f)
        position = 1;
    return position * (self.Magnitude / 100);
}
-(CGPoint*)returnCorrectPointFromPoints: (CGPoint*)topLeft andPointB: (CGPoint*)topRight andPointC: (CGPoint*)bottomLeft andPointD: (CGPoint*)bottomRight
{
    CGPoint* changedCorner = nil;
    if (self.TopLeftSlope == YES)
    {
        changedCorner = topLeft;
    }
    else if (self.TopRightSlope == YES)
    {
        changedCorner = topRight;
    }
    else if (self.BottomRightSlope == YES)
    {
        changedCorner = bottomRight;
    }
    else if (self.BottomLeftSlope == YES)
    {
        changedCorner = bottomLeft;
    }
    return changedCorner;
}
@end
