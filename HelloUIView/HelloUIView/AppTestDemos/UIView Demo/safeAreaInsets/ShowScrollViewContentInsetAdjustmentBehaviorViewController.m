//
//  ShowScrollViewContentInsetAdjustmentBehaviorViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/13.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ShowScrollViewContentInsetAdjustmentBehaviorViewController.h"
#import "TouchView.h"
#import "WCViewTool.h"

// use for initializing frame/size/point when change it afterward
#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

#define SPACE_V 10

@interface ShowScrollViewContentInsetAdjustmentBehaviorViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *label;
@property (nonatomic, strong) UIVisualEffectView *toolbarView;
@property (nonatomic, strong) UISegmentedControl *segmentedControlScrollAxisType;
@property (nonatomic, strong) UISegmentedControl *segmentedControlBehavior;
@end

@implementation ShowScrollViewContentInsetAdjustmentBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.label];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toolbarView];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tapGesture.delegate = self;
    [self.view addGestureRecognizer:tapGesture];
    
    UITapGestureRecognizer *doubleTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewDoubleTapped:)];
    doubleTapGesture.delegate = self;
    doubleTapGesture.numberOfTapsRequired = 2;
    [self.view addGestureRecognizer:doubleTapGesture];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    UIEdgeInsets safeAreaInsets = [WCViewTool safeAreaInsetsWithView:self.view];
    
    self.scrollView.frame = self.view.bounds;
    
    CGFloat height = safeAreaInsets.bottom + self.segmentedControlScrollAxisType.frame.size.height + self.segmentedControlBehavior.frame.size.height + 2 * SPACE_V;
    ViewFrameSet(self.toolbarView, NAN, CGRectGetMaxY(self.view.frame) - height, self.view.bounds.size.width, height);
    ViewCenterSet(self.segmentedControlScrollAxisType, self.view.bounds.size.width / 2.0, NAN);
    ViewCenterSet(self.segmentedControlBehavior, self.view.bounds.size.width / 2.0, NAN);
    
    [self updateScrollViewContentSize];
    [self updateBehavior];
}

#pragma mark -

- (void)updateScrollViewContentSize {
    switch (self.scrollAxisType) {
        case ScrollAxisTypeVertical:
        default: {
            self.scrollView.contentSize = CGSizeMake(1.0 * self.scrollView.bounds.size.width, 1.5 * self.scrollView.bounds.size.height);
            break;
        }
        case ScrollAxisTypeHorizontal: {
            self.scrollView.contentSize = CGSizeMake(1.5 * self.scrollView.bounds.size.width, 1.0 * self.scrollView.bounds.size.height);
            break;
        }
        case ScrollAxisTypeAll: {
            self.scrollView.contentSize = CGSizeMake(1.5 * self.scrollView.bounds.size.width, 1.5 * self.scrollView.bounds.size.height);
            break;
        }
    }
    
    self.label.frame = CGRectMake(self.label.frame.origin.x, self.label.frame.origin.y, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)updateBehavior {
    self.scrollView.contentInsetAdjustmentBehavior = self.behavior;
}

#pragma mark - Getter

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
        scrollView.backgroundColor = [[UIColor orangeColor] colorWithAlphaComponent:0.5];
        
        _scrollView = scrollView;
    }
    
    return _scrollView;
}

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor darkGrayColor];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.text = LONG_TEXT;
        label.backgroundColor = [UIColor whiteColor];
        
        _label = label;
    }
    
    return _label;
}

- (UIVisualEffectView *)toolbarView {
    if (!_toolbarView) {
        
        _segmentedControlScrollAxisType = [[UISegmentedControl alloc] initWithItems:@[ @"Vertical", @"Horizontal", @"All"]];
        _segmentedControlBehavior = [[UISegmentedControl alloc] initWithItems:@[ @"Automatic", @"ScrollableAxes", @"Never", @"Always"]];
        
        _segmentedControlScrollAxisType.selectedSegmentIndex = 0;
        _segmentedControlBehavior.selectedSegmentIndex = 0;
        
        [_segmentedControlScrollAxisType sizeToFit];
        [_segmentedControlBehavior sizeToFit];
        
        [_segmentedControlScrollAxisType addTarget:self action:@selector(segmentedControlScrollAxisTypeChanged:) forControlEvents:UIControlEventValueChanged];
        [_segmentedControlBehavior addTarget:self action:@selector(segmentedControlBehaviorChanged:) forControlEvents:UIControlEventValueChanged];
        
        ViewFrameSet(_segmentedControlScrollAxisType, UNSPECIFIED, SPACE_V, NAN, NAN);
        ViewFrameSet(_segmentedControlBehavior, UNSPECIFIED, CGRectGetMaxY(_segmentedControlScrollAxisType.frame) + SPACE_V, NAN, NAN);
        
        UIBlurEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *view = [[UIVisualEffectView alloc] initWithEffect:effect];
        view.frame = CGRectMake(0, 0, 0, _segmentedControlScrollAxisType.frame.size.height + 2 * SPACE_V + _segmentedControlBehavior.frame.size.height);
        view.userInteractionEnabled = YES;
        [view.contentView addSubview:_segmentedControlScrollAxisType];
        [view.contentView addSubview:_segmentedControlBehavior];
        
        _toolbarView = view;
    }
    
    return _toolbarView;
}

#pragma mark - Action

- (void)viewTapped:(id)sender {
    self.toolbarView.hidden = !self.toolbarView.hidden;
}

- (void)viewDoubleTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)segmentedControlScrollAxisTypeChanged:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    self.scrollAxisType = (ScrollAxisType)segmentedControl.selectedSegmentIndex;
    
    [self updateScrollViewContentSize];
}

- (void)segmentedControlBehaviorChanged:(id)sender {
    UISegmentedControl *segmentedControl = sender;
    self.behavior = (UIScrollViewContentInsetAdjustmentBehavior)segmentedControl.selectedSegmentIndex;
    
    [self.view setNeedsLayout];
    [self.view layoutIfNeeded];
}

#pragma mark - UIGestureRecognizerDelegate

// @see https://stackoverflow.com/a/15814834
- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if ([touch.view isDescendantOfView:self.toolbarView]) {
        return NO;
    }
    
    return YES;
}

@end
