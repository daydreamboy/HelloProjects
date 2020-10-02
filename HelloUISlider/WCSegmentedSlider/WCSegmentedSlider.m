//
//  WCSegmentedSlider.m
//  HelloUISlider
//
//  Created by wesley_chen on 2020/10/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCSegmentedSlider.h"

@interface WCSegmentedSlider ()
@property (nonatomic, assign) NSUInteger numberOfSegments;
@property (nonatomic, assign, readwrite) NSInteger currentIndex;
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
        _indexViewSize = CGSizeMake(1.0, 9);
        _trackLineHeight = 1.0;
        _indexViewsBackgroundColor = [UIColor lightGrayColor];
        _trackLineBackgroundColor = [UIColor lightGrayColor];
        _trackLineProgressColor = [UIColor clearColor];
        _tapOnTrackLineAnimated = YES;
        
        self.minimumValue = 0;
        self.maximumValue = numberOfSegments;
        self.continuous = YES;
        self.value = 0;
        
        // Note: hide
//        self.tintColor = [UIColor clearColor];
//        self.minimumTrackTintColor = [UIColor clearColor];
//        self.maximumTrackTintColor = [UIColor clearColor];
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sliderTapped:)];
        [self addGestureRecognizer:tapGesture];
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

- (void)setTrackViewPaddings:(UIEdgeInsets)trackViewPaddings {
    _trackViewPaddings = trackViewPaddings;
    _useTrackViewPaddings = YES;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!_debugging) {
        [self sendSubviewToBack:_trackLine];
    }
    
    self.tintColor = _trackLineProgressColor;
    
    CGFloat segmentWidth = (_trackLine.bounds.size.width - _indexViewSize.width) / _numberOfSegments;
    CGFloat x = _trackLine.frame.origin.x;
    CGFloat y = (self.bounds.size.height - _indexViewSize.height) / 2.0;
    for (UIView *indexView in _indexViews) {
        indexView.frame = CGRectMake(x, y, _indexViewSize.width, _indexViewSize.height);
        x += segmentWidth;
        indexView.backgroundColor = _indexViewsBackgroundColor;
        
        if (!_debugging) {
            [self sendSubviewToBack:indexView];
        }
    }
}

- (CGRect)trackRectForBounds:(CGRect)bounds {
    // Note: bounds for self.bounds
    CGRect rect = [super trackRectForBounds:bounds];
    
    if (_useTrackViewPaddings) {
        _trackLine.frame = CGRectMake(_trackViewPaddings.left, (CGRectGetHeight(bounds) - _trackLineHeight) / 2.0, rect.size.width - _trackViewPaddings.left - _trackViewPaddings.right, _trackLineHeight);
    }
    else {
        _trackLine.frame = CGRectMake(rect.origin.x, (CGRectGetHeight(bounds) - _trackLineHeight) / 2.0, rect.size.width, _trackLineHeight);
    }
    
    _trackLine.backgroundColor = _trackLineBackgroundColor;
    
    return _trackLine.frame;
}

- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value {
    CGRect thumbRect = [super thumbRectForBounds:bounds trackRect:rect value:value];
    
    NSUInteger index = (NSUInteger)value;
    if (index == 0 || index == _numberOfSegments) {
        return thumbRect;
    }
    else {
        UIView *indexView = _indexViews[index];
        return CGRectMake(indexView.center.x - CGRectGetWidth(thumbRect) / 2.0, thumbRect.origin.y, thumbRect.size.width, thumbRect.size.height);
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
    
    [self setValue:index animated:animated];
    
    if ([self.delegate respondsToSelector:@selector(segmentedSlider:didChangeValueToIndex:fromIndex:animated:)]) {
        [self.delegate segmentedSlider:self didChangeValueToIndex:index fromIndex:self.value animated:animated];
    }
}

#pragma mark - Action

- (void)sliderTapped:(UITapGestureRecognizer *)recognizer {
    UISlider *slider = (UISlider *)recognizer.view;
    
    // @see https://stackoverflow.com/questions/14356528/how-to-change-a-uislider-value-using-a-single-touch/14356751
    CGPoint point = [recognizer locationInView:slider];
    CGFloat percentage = point.x / slider.bounds.size.width;
    CGFloat delta = percentage * (slider.maximumValue - slider.minimumValue);
    CGFloat value = slider.minimumValue + delta;
    
    [self changeSliderToNearestIndexWithValue:value animated:YES];
}

- (void)sliderValueChanged:(UISlider *)sender {
    [self changeSliderToNearestIndexWithValue:sender.value animated:NO];
}

@end
