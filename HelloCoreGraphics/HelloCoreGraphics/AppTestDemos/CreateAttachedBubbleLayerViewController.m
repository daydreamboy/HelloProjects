//
//  CreateAttachedBubbleLayerViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 10/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CreateAttachedBubbleLayerViewController.h"
#import "WCAttachedBubbleView.h"
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
    bubbleLayer.path = [WCAttachedBubbleView bubblePathWithContentSize:contentSize radius:radius borderWidth:BorderWidth triangleSize:triangleSize arrowDirection:direction arrowOffsets:arrowOffsets transitPointPtr:NULL].CGPath;
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
