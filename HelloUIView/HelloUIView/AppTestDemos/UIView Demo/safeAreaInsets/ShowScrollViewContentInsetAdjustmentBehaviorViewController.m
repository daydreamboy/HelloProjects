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
#import "WCScrollViewTool.h"

// use for initializing frame/size/point when change it afterward
#ifndef UNSPECIFIED
#define UNSPECIFIED 0
#endif

#define SPACE_V 10

@interface ShowScrollViewContentInsetAdjustmentBehaviorViewController () <UIGestureRecognizerDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UILabel *labelContentInset;
@property (nonatomic, strong) UILabel *labelAdjustedContentInset;
@property (nonatomic, strong) UIVisualEffectView *toolbarView;
@property (nonatomic, strong) UISegmentedControl *segmentedControlScrollAxisType;
@property (nonatomic, strong) UISegmentedControl *segmentedControlBehavior;
@end

@implementation ShowScrollViewContentInsetAdjustmentBehaviorViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.scrollView addSubview:self.labelText];
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.toolbarView];
    [self.view addSubview:self.labelContentInset];
    [self.view addSubview:self.labelAdjustedContentInset];
    
    
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
    [self updateLabels];
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
    
    self.labelText.frame = CGRectMake(self.labelText.frame.origin.x, self.labelText.frame.origin.y, self.scrollView.contentSize.width, self.scrollView.contentSize.height);
}

- (void)updateBehavior {
    [WCScrollViewTool safeSetContentInsetAdjustmentBehaviorWithScrollView:self.scrollView behavior:self.behavior];
}

- (void)updateLabels {
    self.labelContentInset.text = NSStringFromUIEdgeInsets(self.scrollView.contentInset);
    self.labelAdjustedContentInset.text = NSStringFromUIEdgeInsets([WCScrollViewTool actualContentInsetsWithScrollView:self.scrollView]);
    
    [self.labelContentInset sizeToFit];
    [self.labelAdjustedContentInset sizeToFit];
    
    CGFloat maxWidth = MAX(self.labelContentInset.frame.size.width, self.labelAdjustedContentInset.frame.size.width);
    self.labelContentInset.center = CGPointMake(ABS((maxWidth - self.labelContentInset.frame.size.width)) / 2.0 + self.labelContentInset.frame.size.width / 2.0, self.labelContentInset.frame.size.height / 2.0);
    self.labelAdjustedContentInset.center = CGPointMake(ABS((maxWidth - self.labelAdjustedContentInset.frame.size.width)) / 2.0 + self.labelAdjustedContentInset.frame.size.width / 2.0, self.labelAdjustedContentInset.frame.size.height / 2.0 + self.labelContentInset.frame.size.height);
    
    CGPoint groupCenter = self.view.center;
    
    [WCViewTool makeSubviewsIntoGroup:@[self.labelContentInset, self.labelAdjustedContentInset] centeredAtPoint:groupCenter groupViewsRect:nil];
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

- (UILabel *)labelText {
    if (!_labelText) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [[UIColor darkGrayColor] colorWithAlphaComponent:0.5];
        label.numberOfLines = 0;
        label.font = [UIFont systemFontOfSize:16];
        label.text = LONG_TEXT;
        label.backgroundColor = [UIColor whiteColor];
        
        _labelText = label;
    }
    
    return _labelText;
}

- (UILabel *)labelContentInset {
    if (!_labelContentInset) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor blueColor];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:18];
        label.layer.borderColor = [UIColor blueColor].CGColor;
        label.layer.borderWidth = 1;
        
        _labelContentInset = label;
    }
    
    return _labelContentInset;
}

- (UILabel *)labelAdjustedContentInset {
    if (!_labelAdjustedContentInset) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor brownColor];
        label.numberOfLines = 1;
        label.font = [UIFont systemFontOfSize:18];
        label.layer.borderColor = [UIColor brownColor].CGColor;
        label.layer.borderWidth = 1;
        
        _labelAdjustedContentInset = label;
    }
    
    return _labelAdjustedContentInset;
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
    self.behavior = (WCScrollViewContentInsetAdjustmentBehavior)segmentedControl.selectedSegmentIndex;
    
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
