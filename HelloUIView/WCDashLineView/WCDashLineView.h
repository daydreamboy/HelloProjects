//
//  WCDashLineView.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/7/1.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A dash line view supports dashes or dots
 
 @discussion The frame of the view is the container of the dash line which
 always ceneter vertically or horizontally in the view. The width or height of
 the view not affects the line width, set lineThickness instead.
 
 @see https://stackoverflow.com/a/12092002
 @see https://stackoverflow.com/a/26019806
 */
@interface WCDashLineView : UIView

/**
 The width of the line
 */
@property (nonatomic, assign) CGFloat lineThickness;

/**
 The direction of the line, horizontal or vertical
 
 Default is NO which is vertical
 */
@property (nonatomic, assign, getter=isHorizontal) BOOL horizontal;

/**
 The line color
 
 @discussion The lineColor is not backgroundColor of the view
 */
@property (nonatomic, strong) UIColor *lineColor;

/**
 The dash pattern in point, the format is [ dash, gap, dash, gap, ... ]
 */
@property (nonatomic, strong) NSArray<NSNumber *> *dashPattern;

/**
 The offset of the beginning of dashPattern in point
 
 @discussion For exmaple, dashPattern = [10, 5, 5, 5], dashPatternOffset = 10,
 so the beginning of dashPattern is the first 5, that's 5-5-5-10-5-5-5...
 */
@property (nonatomic, assign) CGFloat dashPatternOffset;

/**
 Configure the dash as round dot if set YES and `lineThickness` is the diameter
 of the dot
 
 Default is NO
 
 @discussion If set YES, the `dashPattern` property take no effect,
 use `roundDotGap` to set the gap between the dots
 */
@property (nonatomic, assign, getter=isDotRounded) BOOL dotRounded;

/**
 The gap between the dots
 */
@property (nonatomic, assign) CGFloat roundDotGap;

@end

NS_ASSUME_NONNULL_END
