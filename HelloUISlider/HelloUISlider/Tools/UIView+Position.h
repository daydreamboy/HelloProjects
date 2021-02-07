//
//  UIView+Position.h
//  HelloUIView
//
//  Created by wesley_chen on 2018/8/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Position)

#pragma mark - Size (width, height)
// WARNING: always set width & height before positioning (x/y, cx/cy, edgeTop/edgeBottom/..., cornerPointTopLeft/..., middlePointLeft/..)
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;

#pragma mark - Origin Point (x, y)

@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

#pragma mark - Center Point (cx, cy)

@property (nonatomic, assign) CGFloat cx;
@property (nonatomic, assign) CGFloat cy;

#pragma mark - Edges (top/bottom/left/right)

@property (nonatomic, assign) CGFloat edgeTop;
@property (nonatomic, assign) CGFloat edgeBottom;
@property (nonatomic, assign) CGFloat edgeLeft;
@property (nonatomic, assign) CGFloat edgeRight;

#pragma mark - Corner Points (topLeft/topRight/bottomLeft/bottomRight)

@property (nonatomic, assign) CGPoint cornerPointTopLeft;
@property (nonatomic, assign) CGPoint cornerPointTopRight;
@property (nonatomic, assign) CGPoint cornerPointBottomLeft;
@property (nonatomic, assign) CGPoint cornerPointBottomRight;

#pragma mark - Middle Points (top middle/bottom middle/left middle/right middle)

@property (nonatomic, assign) CGPoint middlePointLeft;
@property (nonatomic, assign) CGPoint middlePointRight;
@property (nonatomic, assign) CGPoint middlePointTop;
@property (nonatomic, assign) CGPoint middlePointBottom;

@end
