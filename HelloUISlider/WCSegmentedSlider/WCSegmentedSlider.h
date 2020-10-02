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

@interface WCSegmentedSlider : UISlider

@property (nonatomic, assign, readonly) NSInteger currentIndex;
@property (nonatomic, weak) id<WCSegmentedSliderDelegate> delegate;
@property (nonatomic, assign) CGSize indexViewSize;
@property (nonatomic, assign) UIEdgeInsets trackViewPaddings;
@property (nonatomic, strong) UIColor *indexViewsBackgroundColor;
@property (nonatomic, strong) UIColor *trackLineBackgroundColor;
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
