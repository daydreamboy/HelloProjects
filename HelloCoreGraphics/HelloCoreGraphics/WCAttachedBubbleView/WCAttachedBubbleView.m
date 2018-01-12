//
//  WCAttachedBubbleView.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 11/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCAttachedBubbleView.h"

@interface WCAttachedBubbleView ()

@property (nonatomic, assign) WCAttachedBubbleArrowDirection arrowDirection;
@property (nonatomic, assign) CGPoint arrowPoint; // the point of arrow

@property (nonatomic, strong) UIView *contentView;
@property (nonatomic, assign) CGSize contentSize;

@property (nonatomic, strong) CAShapeLayer *bubbleLayer;

// state flags
@property (nonatomic, assign) BOOL needLayoutSubviews;
@property (nonatomic, assign) BOOL useArrowPosition;
@end

@implementation WCAttachedBubbleView

#pragma mark - Public Methods

- (instancetype)initWithContentView:(UIView *)contentView
                     arrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection
            trianleSizeInHorizontal:(CGSize)trianleSizeInHorizontal
              trianleSizeInVertical:(CGSize)trianleSizeInVertical
                      contentInsets:(UIEdgeInsets)contentInsets
                             radius:(CGFloat)radius {
    
    // set properties firstly to calculate frame
    _contentView = contentView;
    _contentSize = contentView.bounds.size;
    _arrowDirection = arrowDirection;
    _trianleSizeInVertical = trianleSizeInVertical;
    _trianleSizeInHorizontal = trianleSizeInHorizontal;
    _contentInsets = contentInsets;
    _radius = radius;
    
    CGRect frame = [self frameOfAttachedBubbleView];
    
    self = [super initWithFrame:frame];
    if (self) {
        //  set arrow offset to middle in horizontal/vertical by default
        CGSize contentSizeForBubbleLayer = [self contentSizeForBubbleLayer];
        
        CGFloat middleOffsetInHorizontal = (contentSizeForBubbleLayer.width - trianleSizeInHorizontal.width) / 2.0;
        CGFloat middleOffsetInVertical = (contentSizeForBubbleLayer.height - trianleSizeInVertical.width) / 2.0;
        
        _arrowOffsets = UIEdgeInsetsMake(middleOffsetInVertical, middleOffsetInHorizontal, -1, -1);
        
        _needLayoutSubviews = YES;
    }
    return self;
}

+ (instancetype)viewWithContentView:(UIView *)contentView arrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection {
    CGSize trianleSizeInHorizontal = CGSizeMake(15 * 2, 15);
    CGSize trianleSizeInVertical = CGSizeMake(8 * 2, 12);
    CGFloat radius = 10;
    
    WCAttachedBubbleView *container = [[WCAttachedBubbleView alloc] initWithContentView:contentView arrowDirection:arrowDirection trianleSizeInHorizontal:trianleSizeInHorizontal trianleSizeInVertical:trianleSizeInVertical contentInsets:UIEdgeInsetsZero radius:radius];
    
    container.backgroundColor = [UIColor yellowColor];
    container.borderColor = [UIColor orangeColor];
    
    return container;
}

- (void)setArrowPosition:(CGPoint)arrowPosition {
    _arrowPosition = arrowPosition;
    _useArrowPosition = YES;
}

#pragma mark - Getter

- (CAShapeLayer *)bubbleLayer {
    if (!_bubbleLayer) {
        CAShapeLayer *layer = [CAShapeLayer layer];
        
        CGSize contentSizeForBubbleLayer = [self contentSizeForBubbleLayer];
        CGSize triangleSize = [self triangleSize];
        
        CGPoint transitPoint = CGPointZero;
        UIBezierPath *path = [self.class bubblePathWithContentSize:contentSizeForBubbleLayer radius:self.radius borderWidth:self.borderWidth triangleSize:triangleSize arrowDirection:self.arrowDirection arrowOffsets:self.arrowOffsets transitPointPtr:&transitPoint];
        self.arrowPoint = transitPoint;
        
        layer.path = path.CGPath;
        layer.fillColor = self.backgroundColor.CGColor;
        layer.strokeColor = self.borderColor.CGColor;
        layer.lineWidth = self.borderWidth;

        // extra settings
        layer.shadowOffset = self.shadowOffset;
        layer.shadowColor = self.shadowColor.CGColor;
        layer.shadowOpacity = self.shadowOpacity;
        
        _bubbleLayer = layer;
    }
    
    return _bubbleLayer;
}

#pragma mark -

- (void)layoutSubviews {
    NSLog(@"layoutSubviews");
    [super layoutSubviews];
    
    if (self.needLayoutSubviews) {
        [self.layer addSublayer:self.bubbleLayer];
        
        [self layoutSelfViewIfNeeded];
        [self layoutContentView];
        
        self.needLayoutSubviews = NO;
    }
}

- (void)layoutSelfViewIfNeeded {
    if (self.useArrowPosition) {
        CGRect frame = self.frame;
        frame.origin.x = _arrowPosition.x - self.arrowPoint.x;
        frame.origin.y = _arrowPosition.y - self.arrowPoint.y;
        self.frame = frame;
    }
}

- (void)layoutContentView {
    CGRect frame = [self frameOfAttachedBubbleView];
    CGPoint center = CGPointZero;
    
    if (self.arrowDirection == WCAttachedBubbleArrowDirectionUp ||
        self.arrowDirection == WCAttachedBubbleArrowDirectionDown ||
        self.arrowDirection == WCAttachedBubbleArrowDirectionDefault) {
        
        center.x = CGRectGetWidth(frame) / 2.0;
        center.y = (self.arrowDirection == WCAttachedBubbleArrowDirectionUp)
                    ? (CGRectGetHeight(frame) - self.trianleSizeInHorizontal.height) / 2.0 +  self.trianleSizeInHorizontal.height
                    : (CGRectGetHeight(frame) - self.trianleSizeInHorizontal.height) / 2.0;
    }
    else if (self.arrowDirection == WCAttachedBubbleArrowDirectionLeft ||
             self.arrowDirection == WCAttachedBubbleArrowDirectionRight) {
        center.x = (self.arrowDirection == WCAttachedBubbleArrowDirectionLeft)
                    ? (CGRectGetWidth(frame) - self.trianleSizeInVertical.height) / 2.0 + self.trianleSizeInVertical.height
                    : (CGRectGetWidth(frame) - self.trianleSizeInVertical.height) / 2.0;
        center.y = CGRectGetHeight(frame) / 2.0;
    }

    self.contentView.center = center;
    [self addSubview:self.contentView];
}

#pragma mark - Calculations

- (CGSize)triangleSize {
    if (self.arrowDirection == WCAttachedBubbleArrowDirectionDefault ||
        self.arrowDirection == WCAttachedBubbleArrowDirectionUp ||
        self.arrowDirection == WCAttachedBubbleArrowDirectionDown) {
        return self.trianleSizeInHorizontal;
    }
    else {
        return self.trianleSizeInVertical;
    }
}

- (CGSize)contentSizeForBubbleLayer {
    return CGSizeMake(self.contentSize.width + self.contentInsets.left + self.contentInsets.right, self.contentSize.height + self.contentInsets.top + self.contentInsets.bottom);
}

- (CGRect)frameOfAttachedBubbleView {
    if (self.arrowDirection == WCAttachedBubbleArrowDirectionDefault ||
        self.arrowDirection == WCAttachedBubbleArrowDirectionUp ||
        self.arrowDirection == WCAttachedBubbleArrowDirectionDown) {
        return CGRectMake(0,
                          0,
                          self.contentSize.width + self.contentInsets.left + self.contentInsets.right + 2 * self.radius,
                          self.contentSize.height + self.contentInsets.top + self.contentInsets.bottom + 2 * self.radius + [self triangleSize].height);
    }
    else {
        return CGRectMake(0,
                          0,
                          self.contentSize.width + self.contentInsets.left + self.contentInsets.right + 2 * self.radius + [self triangleSize].height,
                          self.contentSize.height + self.contentInsets.top + self.contentInsets.bottom + 2 * self.radius);
    }
}

#pragma mark -

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
 
 @see https://stackoverflow.com/questions/4442126/how-to-draw-a-speech-bubble-on-an-iphone
 */
+ (UIBezierPath *)bubblePathWithContentSize:(CGSize)contentSize radius:(CGFloat)radius borderWidth:(CGFloat)borderWidth triangleSize:(CGSize)triangleSize arrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection arrowOffsets:(UIEdgeInsets)arrowOffsets transitPointPtr:(CGPoint *)transitPointPtr {

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
    
    if (transitPointPtr != NULL) {
        *transitPointPtr = transitPoint;
    }

    return path;
}

@end
