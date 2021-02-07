//
//  UIView+Position.m
//  HelloUIView
//
//  Created by wesley_chen on 2018/8/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UIView+Position.h"

@implementation UIView (Position)

#pragma mark - Size (width, height)

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

#pragma mark - Origin Point (x, y)

- (void)setX:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)x {
    return self.frame.origin.x;
}

- (void)setY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)y {
    return self.frame.origin.y;
}

#pragma mark - Center Point (cx, cy)

- (void)setCx:(CGFloat)cx {
    CGPoint center = self.center;
    center.x = cx;
    self.center = center;
}

- (CGFloat)cx {
    return self.center.x;
}

- (void)setCy:(CGFloat)cy {
    CGPoint center = self.center;
    center.y = cy;
    self.center = center;
}

- (CGFloat)cy {
    return self.center.y;
}

#pragma mark - Edges (top/left/bottom/right)

- (void)setEdgeTop:(CGFloat)edgeTop {
    CGRect frame = self.frame;
    frame.origin.y = edgeTop;
    self.frame = frame;
}

- (CGFloat)edgeTop {
    return self.frame.origin.y;
}

- (void)setEdgeLeft:(CGFloat)edgeLeft {
    CGRect frame = self.frame;
    frame.origin.x = edgeLeft;
    self.frame = frame;
}

- (CGFloat)edgeLeft {
    return self.frame.origin.x;
}

- (void)setEdgeBottom:(CGFloat)edgeBottom {
    CGRect frame = self.frame;
    frame.origin.y = edgeBottom - self.frame.size.height;
    self.frame = frame;
}

- (CGFloat)edgeBottom {
    return self.frame.origin.y + self.frame.size.height;
}

- (void)setEdgeRight:(CGFloat)edgeRight {
    CGRect frame = self.frame;
    frame.origin.x = edgeRight - self.frame.size.width;
    self.frame = frame;
}

- (CGFloat)edgeRight {
    return self.frame.origin.x + self.frame.size.width;
}

#pragma mark - Corner Points (topLeft/topRight/bottomLeft/bottomRight)

- (void)setCornerPointTopLeft:(CGPoint)cornerPointTopLeft {
    CGRect frame = self.frame;
    frame.origin.x = cornerPointTopLeft.x;
    frame.origin.y = cornerPointTopLeft.y;
    self.frame = frame;
}

- (CGPoint)cornerPointTopLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

- (void)setCornerPointTopRight:(CGPoint)cornerPointTopRight {
    CGRect frame = self.frame;
    frame.origin.x = cornerPointTopRight.x - frame.size.width;
    frame.origin.y = cornerPointTopRight.y;
    self.frame = frame;
}

- (CGPoint)cornerPointTopRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

- (void)setCornerPointBottomLeft:(CGPoint)cornerPointBottomLeft {
    CGRect frame = self.frame;
    frame.origin.x = cornerPointBottomLeft.x;
    frame.origin.y = cornerPointBottomLeft.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)cornerPointBottomLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

- (void)setCornerPointBottomRight:(CGPoint)cornerPointBottomRight {
    CGRect frame = self.frame;
    frame.origin.x = cornerPointBottomRight.x - frame.size.width;
    frame.origin.y = cornerPointBottomRight.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)cornerPointBottomRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

#pragma mark - Middle Points (top middle/bottom middle/left middle/right middle)

- (void)setMiddlePointLeft:(CGPoint)middlePointLeft {
    CGRect frame = self.frame;
    frame.origin.x = middlePointLeft.x;
    frame.origin.y = middlePointLeft.y - frame.size.height / 2.0;
    self.frame = frame;
}

- (CGPoint)middlePointLeft {
    CGFloat x = self.frame.origin.x;
    CGFloat y = self.frame.origin.y + self.frame.size.height / 2.0;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

- (void)setMiddlePointRight:(CGPoint)middlePointRight {
    CGRect frame = self.frame;
    frame.origin.x = middlePointRight.x - frame.size.width;
    frame.origin.y = middlePointRight.y - frame.size.height / 2.0;
    self.frame = frame;
}

- (CGPoint)middlePointRight {
    CGFloat x = self.frame.origin.x + self.frame.size.width;
    CGFloat y = self.frame.origin.y + self.frame.size.height / 2.0;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

- (void)setMiddlePointTop:(CGPoint)middlePointTop {
    CGRect frame = self.frame;
    frame.origin.x = middlePointTop.x - frame.size.width / 2.0;
    frame.origin.y = middlePointTop.y;
    self.frame = frame;
}

- (CGPoint)middlePointTop {
    CGFloat x = self.frame.origin.x + self.frame.size.width / 2.0;
    CGFloat y = self.frame.origin.y;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}

- (void)setMiddlePointBottom:(CGPoint)middlePointBottom {
    CGRect frame = self.frame;
    frame.origin.x = middlePointBottom.x - frame.size.width / 2.0;
    frame.origin.y = middlePointBottom.y - frame.size.height;
    self.frame = frame;
}

- (CGPoint)middlePointBottom {
    CGFloat x = self.frame.origin.x + self.frame.size.width / 2.0;
    CGFloat y = self.frame.origin.y + self.frame.size.height;;
    
    CGPoint point = CGPointMake(x, y);
    
    return point;
}
@end
