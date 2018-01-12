//
//  WCAttachedBubbleView.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 11/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WCAttachedBubbleArrowDirection) {
    WCAttachedBubbleArrowDirectionDefault,
    WCAttachedBubbleArrowDirectionUp,
    WCAttachedBubbleArrowDirectionDown,
    WCAttachedBubbleArrowDirectionLeft,
    WCAttachedBubbleArrowDirectionRight,
};

@interface WCAttachedBubbleView : UIView

@property (nonatomic, assign) CGPoint arrowPosition;

// bubble basic attributes
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGSize trianleSizeInHorizontal; // triangle on horizontal
@property (nonatomic, assign) CGSize trianleSizeInVertical; // triangle on vertical
@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets arrowOffsets; // arrow offset from edges (top, left, bottom, right). By Default, arrow is in middle on horizontal/vertical

// bubble extra attributes
@property (nonatomic, assign) CGSize shadowOffset;
@property (nonatomic, strong) UIColor *shadowColor;
@property (nonatomic, assign) CGFloat shadowOpacity;

+ (instancetype)viewWithContentView:(UIView *)contentView arrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection;

- (instancetype)initWithContentView:(UIView *)contentView
                     arrowDirection:(WCAttachedBubbleArrowDirection)arrowDirection
            trianleSizeInHorizontal:(CGSize)trianleSizeInHorizontal
              trianleSizeInVertical:(CGSize)trianleSizeInVertical
                      contentInsets:(UIEdgeInsets)contentInsets
                             radius:(CGFloat)radius;


@end
