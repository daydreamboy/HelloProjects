//
//  WCSegmentedSlider.h
//  HelloUISlider
//
//  Created by wesley_chen on 2020/10/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@class WCSegmentedSlider;

@protocol WCSegmentedSliderDelegate <NSObject>

@optional
- (void)segmentedSlider:(WCSegmentedSlider *)slider willChangeValueToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex animated:(BOOL)animated;
- (void)segmentedSlider:(WCSegmentedSlider *)slider didChangeValueToIndex:(NSUInteger)toIndex fromIndex:(NSUInteger)fromIndex animated:(BOOL)animated;

@end

/**
 A slider with multiple segments which behaviors like the slider located in `Display & Brightness` > `Text Size`
 */
@interface WCSegmentedSlider : UISlider

/**
 The current index which is started by 0
 */
@property (nonatomic, assign, readonly) NSInteger currentIndex;
/**
 The delegate
 */
@property (nonatomic, weak) id<WCSegmentedSliderDelegate> delegate;
/**
 The size of index view (little stick)
 
 Default is CGSizeMake(1.0, 9.0)
 */
@property (nonatomic, assign) CGSize indexViewSize;
/**
 The track line paddings only for left and right padding
 
 Default is determined by system, which left and right padding is 3
 */
@property (nonatomic, assign) UIEdgeInsets trackLinePaddings;
/**
 The background color of the index views
 
 Default is [UIColor lightGrayColor]
 */
@property (nonatomic, strong) UIColor *indexViewsBackgroundColor;
/**
 The background color of the track line
 
 Default is [UIColor lightGrayColor]
 */
@property (nonatomic, strong) UIColor *trackLineBackgroundColor;
/**
 The background color of the progress
 
 Default is [UIColor clearColor]
 */
@property (nonatomic, strong) UIColor *trackLineProgressColor;
/**
 Default is YES
 */
@property (nonatomic, assign) BOOL tapOnTrackLineAnimated;
@property (nonatomic, assign) BOOL debugging;

- (instancetype)initWithFrame:(CGRect)frame numberOfSegments:(NSUInteger)numberOfSegments;
- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
