//
//  WCSegmentedSlider.m
//  HelloUISlider
//
//  Created by wesley_chen on 2020/10/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCSegmentedSlider.h"

// >= `13.0`
#ifndef IOS13_OR_LATER
#define IOS13_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"13.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCSegmentedSlider ()
@property (nonatomic, assign) NSUInteger numberOfSegments;
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
@property (nonatomic, assign, readwrite) CGSize thumbSize;
@property (nonatomic, strong) NSMutableArray<UIView *> *indexViews;
@property (nonatomic, strong) UIView *trackLine;
@property (nonatomic, assign) CGFloat trackLineHeight;
@property (nonatomic, assign) BOOL useTrackViewPaddings;
@end

@implementation WCSegmentedSlider

- (instancetype)initWithFrame:(CGRect)frame numberOfSegments:(NSUInteger)numberOfSegments {
    self = [super initWithFrame:frame];
    if (self) {
        _numberOfSegments = numberOfSegments;
        
        // Note: default values
        _indexViewSize = CGSizeMake(1.0, 9.0);
        _trackLineHeight = 1.0;
        _indexViewsBackgroundColor = [UIColor lightGrayColor];
        _trackLineBackgroundColor = [UIColor lightGrayColor];
        _trackLineProgressColor = [UIColor clearColor];
        _tapOnTrackLineAnimated = YES;
        _tapOnTrackLineEnabled = YES;
        
        self.minimumValue = 0;
        self.maximumValue = numberOfSegments;
        self.continuous = YES;
        self.value = 0;
        
        // Note: hide
        self.tintColor = [UIColor clearColor];
        self.minimumTrackTintColor = [UIColor clearColor];
        self.maximumTrackTintColor = [UIColor clearColor];
        
        if (IOS13_OR_LATER) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
            [self addGestureRecognizer:tapGesture];
        }
        [self addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _indexViews = [NSMutableArray arrayWithCapacity:_numberOfSegments];
        for (NSUInteger i = 0; i <= _numberOfSegments; ++i) {
            UIView *indexView = [UIView new];
            [_indexViews addObject:indexView];
            [self addSubview:indexView];
        }
        
        _trackLine = [UIView new];
        [self addSubview:_trackLine];
    }
    return self;
}

- (NSInteger)currentIndex {
    return self.value;
}

- (void)setCurrentIndex:(NSInteger)currentIndex animated:(BOOL)animated {
    [self changeSliderValueWithIndex:currentIndex animated:animated];
}

- (void)setTrackLinePaddings:(UIEdgeInsets)trackLinePaddings {
    _trackLinePaddings = trackLinePaddings;
    _useTrackViewPaddings = YES;
}

#pragma mark - Override

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_debugging) {
        [self sendSubviewToBack:_trackLine];
    }
    
    self.tintColor = _trackLineProgressColor;
    
    // Note: the segmentWidth is distance between the index view, and track line width include the index view width
    CGFloat segmentWidth = (_trackLine.bounds.size.width - (_numberOfSegments + 1) * _indexViewSize.width) / _numberOfSegments;
    CGFloat x = _trackLine.frame.origin.x;
    CGFloat y = (self.bounds.size.height - _indexViewSize.height) / 2.0;
    for (UIView *indexView in _indexViews) {
        indexView.frame = CGRectMake(x, y, _indexViewSize.width, _indexViewSize.height);
        x = CGRectGetMaxX(indexView.frame) + segmentWidth;
        indexView.backgroundColor = _indexViewsBackgroundColor;
        
        if (!_debugging) {
            [self sendSubviewToBack:indexView];
        }
    }
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    // Note: bounds for self.bounds
    CGRect trackRect = [super trackRectForBounds:bounds];
    
    if (_useTrackViewPaddings) {
        _trackLine.frame = CGRectMake(_trackLinePaddings.left, (CGRectGetHeight(bounds) - _trackLineHeight) / 2.0, bounds.size.width - _trackLinePaddings.left - _trackLinePaddings.right, _trackLineHeight);
    }
    else {
        _trackLine.frame = CGRectMake(trackRect.origin.x, (CGRectGetHeight(bounds) - _trackLineHeight) / 2.0, trackRect.size.width, _trackLineHeight);
    }
    
    _trackLine.backgroundColor = _trackLineBackgroundColor;
    
    return _trackLine.frame;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    _thumbSize = thumbRect.size;
    
    NSUInteger index = (NSUInteger)value;
    if (self.enableThumbOnEdgeIndex) {
        UIView *indexView = _indexViews[index];
        return CGRectMake(indexView.center.x - CGRectGetWidth(thumbRect) / 2.0, thumbRect.origin.y, thumbRect.size.width, thumbRect.size.height);
    }
    else {
        if (index == 0 || index == _numberOfSegments) {
            return thumbRect;
        }
        else {
            UIView *indexView = _indexViews[index];
            return CGRectMake(indexView.center.x - CGRectGetWidth(thumbRect) / 2.0, thumbRect.origin.y, thumbRect.size.width, thumbRect.size.height);
        }
    }
}

#pragma mark -

- (void)changeSliderToNearestIndexWithValue:(CGFloat)value animated:(BOOL)animated {
    // @see https://stackoverflow.com/questions/8219056/uislider-that-snaps-to-a-fixed-number-of-steps-like-text-size-in-the-ios-7-sett
    // Note: round the slider position to the nearest index
    NSUInteger index = (NSUInteger)(value + 0.5);
    [self changeSliderValueWithIndex:index animated:animated];
}

- (void)changeSliderValueWithIndex:(CGFloat)index animated:(BOOL)animated {
    if ([self.delegate respondsToSelector:@selector(segmentedSlider:willChangeValueToIndex:fromIndex:animated:)]) {
        [self.delegate segmentedSlider:self willChangeValueToIndex:index fromIndex:self.value animated:animated];
    }
    
    if (IOS13_OR_LATER) {
        [self setValue:index animated:animated];
    }
    else {
        if (animated) {
            // @see https://stackoverflow.com/a/28907133
            [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self setValue:index animated:YES];
            } completion:nil];
        }
        else {
            [self setValue:index animated:NO];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(segmentedSlider:didChangeValueToIndex:fromIndex:animated:)]) {
        [self.delegate segmentedSlider:self didChangeValueToIndex:index fromIndex:self.value animated:animated];
    }
}

#pragma mark - Action

- (void)sliderTapped:(UITapGestureRecognizer *)recognizer {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
    if (!self.tapOnTrackLineEnabled) {
        return;
    }
#pragma GCC diagnostic pop
    
    CGPoint touchPoint = [recognizer locationInView:self];
    
    CGRect trackRect = [self trackRectForBounds:self.bounds];
    CGRect thumbRect = [self thumbRectForBounds:self.bounds trackRect:trackRect value:self.value];
    if (CGRectContainsPoint(thumbRect, touchPoint)) {
        return;
    }
    
    UISlider *slider = (UISlider *)recognizer.view;
    
    // @see https://stackoverflow.com/questions/14356528/how-to-change-a-uislider-value-using-a-single-touch/14356751
    CGPoint point = [recognizer locationInView:slider];
    CGFloat percentage = point.x / slider.bounds.size.width;
    CGFloat delta = percentage * (slider.maximumValue - slider.minimumValue);
    CGFloat value = slider.minimumValue + delta;
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
    [self changeSliderToNearestIndexWithValue:value animated:self.tapOnTrackLineAnimated];
#pragma GCC diagnostic pop
}

- (void)sliderValueChanged:(UISlider *)sender {
    [self changeSliderToNearestIndexWithValue:sender.value animated:NO];
}

@end
