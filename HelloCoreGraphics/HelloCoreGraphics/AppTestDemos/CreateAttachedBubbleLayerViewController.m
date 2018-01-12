//
//  CreateAttachedBubbleLayerViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CreateAttachedBubbleLayerViewController.h"
#import "WCAttachedBubbleView.h"

@interface CreateAttachedBubbleLayerViewController ()
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UILabel *labelWithArrowUp;
@property (nonatomic, strong) UILabel *labelWithArrowDown;
@property (nonatomic, strong) UILabel *labelWithArrow;
@end

@implementation CreateAttachedBubbleLayerViewController
#define BorderWidth 0
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.label];
    
    CGSize contentSize = self.label.frame.size;
    CGSize trianleSizeForHorizontal = CGSizeMake(15 * 2, 15);
    CGSize trianleSizeForVertical = CGSizeMake(8 * 2, 12);
    
    CGSize triangleSize = trianleSizeForVertical;
    triangleSize = trianleSizeForHorizontal;
    UIEdgeInsets arrowOffsets = UIEdgeInsetsZero;
    CGFloat radius = 10;
    
    // offset from left edge
    arrowOffsets = UIEdgeInsetsMake(0, 10, 0, -1);
    
    // offset from right edge
    arrowOffsets = UIEdgeInsetsMake(0, -1, 0, 40);
    
    // offset from bottom edge
    arrowOffsets = UIEdgeInsetsMake(-1, 0, 5, 0);
    
    // offset from top edge
    arrowOffsets = UIEdgeInsetsMake(3, 0, -1, 0);
    
    CGFloat horizontalOffsetOfMiddleArrow = (contentSize.width - triangleSize.width) / 2.0;
    CGFloat verticalOffsetOfMiddleArrow = (contentSize.height - triangleSize.width) / 2.0;
    
    arrowOffsets = UIEdgeInsetsMake(verticalOffsetOfMiddleArrow, horizontalOffsetOfMiddleArrow, -1, -1);
    
    WCAttachedBubbleArrowDirection direction = WCAttachedBubbleArrowDirectionUp;
    direction = WCAttachedBubbleArrowDirectionDown;
//    direction = WCAttachedBubbleArrowDirectionLeft;
//    direction = WCAttachedBubbleArrowDirectionRight;
    
    CAShapeLayer *bubbleLayer = [CAShapeLayer layer];
    bubbleLayer.path = [self bubblePathWithContentSize:contentSize radius:radius borderWidth:BorderWidth triangleSize:triangleSize arrowDirection:direction arrowOffsets:arrowOffsets].CGPath;
    bubbleLayer.fillColor = [UIColor yellowColor].CGColor;
    bubbleLayer.strokeColor = [UIColor orangeColor].CGColor;
    bubbleLayer.lineWidth = BorderWidth;
//    bubbleLayer.shadowOffset = CGSizeMake(0, 1);
//    bubbleLayer.shadowColor = [UIColor blackColor].CGColor;
//    bubbleLayer.shadowOpacity = 1.0;
    [self.label.layer addSublayer:bubbleLayer];
    
    CGRect frame = self.label.frame;
    if (direction == WCAttachedBubbleArrowDirectionUp ||
        direction == WCAttachedBubbleArrowDirectionDefault ||
        direction == WCAttachedBubbleArrowDirectionDown) {
        frame.size = CGSizeMake(frame.size.width + 2 * radius, frame.size.height + 2 * radius + triangleSize.height);
    }
    else {
        frame.size = CGSizeMake(frame.size.width + 2 * radius + triangleSize.height, frame.size.height + 2 * radius);
    }
    
    self.label.frame = frame;
}

/**
 Create an attached bubble shape layer

 @param contentSize     the size of content
 @param radius          the radius of bubble
 @param borderWidth     the border width of bubble
 @param triangleSize    the size of arrow
 @param arrowDirection  the direction of arrow
 @param arrowOffsets    offset from edges (top, left, bottom, right) of content. Specific Value: -1 for not use this value. value < -1, will treat as 0.
        - top,      vertical offset from top edge when arrowDirection is to left or right
        - left,     horizontal offset from left edge when arrowDirection is to up or down
        - bottom,   vertical offset from bottom edge when arrowDirection is to left or right
        - right,    horizontal offset from right edge when arrowDirection is to up or down
    [warning] top/bottom only use one, if use both (top > 0, bottom > 0), only top considered.
    [warning] left/right only use one, if use both (left > 0, right > 0), only left considered.
 @return UIBezierPath
 */
- (UIBezierPath *)bubblePathWithContentSize:(CGSize)contentSize radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth triangleSize:(CGSize)triangleSize arrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection arrowOffsets:(UIEdgeInsets)arrowOffsets {
    
    CGFloat triangleHeight = triangleSize.height;
    CGFloat triangleWidth = triangleSize.width;
    CGFloat radiusInFact = radius - borderWidth / 2.0;
    
    CGRect rectForContent = CGRectMake(0, 0, contentSize.width, contentSize.height);
    CGPoint startPoint = CGPointZero;
    CGPoint transitPoint = CGPointZero;
    CGPoint endPoint = CGPointZero;
    
    if (arrowDirection == WCAttachedBubbleArrowDirectionDefault || arrowDirection == WCAttachedBubbleArrowDirectionUp) {
        // Note: CGRectOffset(CGRectMake(x, y, width, height), dx, dy) => CGRectMake(x + dx, y + dy, width, height)
        rectForContent = CGRectOffset(rectForContent, radius, radius + triangleHeight);
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionDown) {
        rectForContent = CGRectOffset(rectForContent, radius, radius);
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionLeft) {
        rectForContent = CGRectOffset(rectForContent, radius + triangleHeight, radius);
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionRight) {
        rectForContent = CGRectOffset(rectForContent, radius, radius);
    }
    
    
    CGFloat maxX = CGRectGetMaxX(rectForContent);
    CGFloat minX = CGRectGetMinX(rectForContent);
    CGFloat maxY = CGRectGetMaxY(rectForContent);
    CGFloat minY = CGRectGetMinY(rectForContent);
    
    if (arrowDirection == WCAttachedBubbleArrowDirectionUp ||
        arrowDirection == WCAttachedBubbleArrowDirectionDefault) {
        // If: arrowOffsets.left == -1
        // x for start point/end point offset from right edge
        // Else:
        // x for start point/end point offset from left edge
        startPoint.x = (arrowOffsets.left == -1) ? (maxX - MAX(arrowOffsets.right, 0) - triangleWidth) : (minX + MAX(arrowOffsets.left, 0));
        transitPoint.x = startPoint.x + triangleWidth / 2.0;
        endPoint.x = transitPoint.x + triangleWidth / 2.0;
        
        startPoint.y = minY - radiusInFact;
        transitPoint.y = startPoint.y - triangleHeight;
        endPoint.y = startPoint.y;
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionDown) {
        // If: arrowOffsets.left == -1
        // x for start point/end point offset from right edge
        // Else:
        // x for start point/end point offset from left edge
        startPoint.x = (arrowOffsets.left == -1) ? (maxX - MAX(arrowOffsets.right, 0)) : (minX + MAX(arrowOffsets.left, 0) + triangleWidth);
        transitPoint.x = startPoint.x - triangleWidth / 2.0;
        endPoint.x = transitPoint.x - triangleWidth / 2.0;
        
        startPoint.y = maxY + radiusInFact;
        transitPoint.y = startPoint.y + triangleHeight;
        endPoint.y = startPoint.y;
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionLeft) {
        // If: arrowOffsets.top == -1
        // y for start point/end point offset from bottom edge
        // Else:
        // y for start point/end point offset from top edge
        startPoint.y = (arrowOffsets.top == -1) ? (maxY - MAX(arrowOffsets.bottom, 0)) : (minY + MAX(arrowOffsets.top, 0) + triangleWidth);
        transitPoint.y = startPoint.y - triangleWidth / 2.0;
        endPoint.y = transitPoint.y - triangleWidth / 2.0;
        
        startPoint.x = minX - radiusInFact;
        transitPoint.x = startPoint.x - triangleHeight;
        endPoint.x = startPoint.x;
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionRight) {
        // If: arrowOffsets.top == -1
        // y for start point/end point offset from bottom edge
        // Else:
        // y for start point/end point offset from top edge
        startPoint.y = (arrowOffsets.top == -1) ? (maxY - MAX(arrowOffsets.bottom, 0) - triangleWidth) : (minY + MAX(arrowOffsets.top, 0));
        transitPoint.y = startPoint.y + triangleWidth / 2.0;
        endPoint.y = transitPoint.y + triangleWidth / 2.0;
        
        startPoint.x = maxX + radiusInFact;
        transitPoint.x = startPoint.x + triangleHeight;
        endPoint.x = startPoint.x;
    }
    
    // Note: UIKit coordinate system and draw points and arcs by clockwise
    UIBezierPath *path = [UIBezierPath bezierPath];
    // Note: draw a line base on `arrowDirection`
    //  - up, draw order: '/' + '\' => '/\'
    //  - down, draw order: '/' + '\' => '\/'
    [path moveToPoint:startPoint];
    [path addLineToPoint:transitPoint];
    [path addLineToPoint:endPoint];
    
    if (arrowDirection == WCAttachedBubbleArrowDirectionUp) {
        // Note: arc for top-right corner
        [path addArcWithCenter:CGPointMake(maxX, minY) radius:radiusInFact startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        // Note: arc for bottom-right corner
        [path addArcWithCenter:CGPointMake(maxX, maxY) radius:radiusInFact startAngle:0 endAngle:M_PI_2 clockwise:YES];
        // Note: arc for bottom-left corner
        [path addArcWithCenter:CGPointMake(minX, maxY) radius:radiusInFact startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        // Note: arc for top-left corner
        [path addArcWithCenter:CGPointMake(minX, minY) radius:radiusInFact startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionDown) {
        // Note: arc for bottom-left corner
        [path addArcWithCenter:CGPointMake(minX, maxY) radius:radiusInFact startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        // Note: arc for top-left corner
        [path addArcWithCenter:CGPointMake(minX, minY) radius:radiusInFact startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
        // Note: arc for top-right corner
        [path addArcWithCenter:CGPointMake(maxX, minY) radius:radiusInFact startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        // Note: arc for bottom-right corner
        [path addArcWithCenter:CGPointMake(maxX, maxY) radius:radiusInFact startAngle:0 endAngle:M_PI_2 clockwise:YES];
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionLeft) {
        // Note: arc for top-left corner
        [path addArcWithCenter:CGPointMake(minX, minY) radius:radiusInFact startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
        // Note: arc for top-right corner
        [path addArcWithCenter:CGPointMake(maxX, minY) radius:radiusInFact startAngle:-M_PI_2 endAngle:0 clockwise:YES];
        // Note: arc for bottom-right corner
        [path addArcWithCenter:CGPointMake(maxX, maxY) radius:radiusInFact startAngle:0 endAngle:M_PI_2 clockwise:YES];
        // Note: arc for bottom-left corner
        [path addArcWithCenter:CGPointMake(minX, maxY) radius:radiusInFact startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
    }
    else if (arrowDirection == WCAttachedBubbleArrowDirectionRight) {
        // Note: arc for bottom-right corner
        [path addArcWithCenter:CGPointMake(maxX, maxY) radius:radiusInFact startAngle:0 endAngle:M_PI_2 clockwise:YES];
        // Note: arc for bottom-left corner
        [path addArcWithCenter:CGPointMake(minX, maxY) radius:radiusInFact startAngle:M_PI_2 endAngle:M_PI clockwise:YES];
        // Note: arc for top-left corner
        [path addArcWithCenter:CGPointMake(minX, minY) radius:radiusInFact startAngle:M_PI endAngle:-M_PI_2 clockwise:YES];
        // Note: arc for top-right corner
        [path addArcWithCenter:CGPointMake(maxX, minY) radius:radiusInFact startAngle:-M_PI_2 endAngle:0 clockwise:YES];
    }
    
    [path closePath];
    
    return path;
}

#pragma mark - Getters

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.layer.borderColor = [UIColor grayColor].CGColor;
        label.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        _label = label;
    }
    
    return _label;
}


@end
