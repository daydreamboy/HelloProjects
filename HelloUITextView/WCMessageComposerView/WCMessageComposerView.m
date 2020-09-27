//
//  WCMessageComposerView.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMessageComposerView.h"
#import "WCGrowingTextView.h"
#import "WCMessageInputItemView.h"
#import "WCKeyboardObserver.h"
#import "WCMacroTool.h"

@interface WCMessageComposerView () <WCGrowingTextViewDelegate>
@property (nonatomic, strong) WCGrowingTextView *textInputView;
@property (nonatomic, strong) UIView *textInputAreaView;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *leftItems;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *leftInItems;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *rightInItems;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *rightItems;

@property (nonatomic, strong) NSMutableArray<WCMessageInputItemView *> *leftViews;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItemView *> *leftInViews;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItemView *> *rightInViews;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItemView *> *rightViews;

@property (nonatomic, assign) CGFloat maximumItemHeight;
@property (nonatomic, assign) BOOL autoSetTextInputAreaCornerRadius;

@property (nonatomic, copy) NSComparisonResult (^itemsComparatorBlock)(WCMessageInputItem *item1, WCMessageInputItem *item2);

// Layout
@property (nonatomic, strong) NSLayoutConstraint *constraintSpaceBetweenBottomLayoutGuide;
@property (nonatomic, weak) UIViewController *viewController;

// Keyboard
@property (nonatomic, assign) BOOL isVisibleKeyboard;
@property (nonatomic, strong) WCKeyboardObserver *keyboardObserver;

@end

@implementation WCMessageComposerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentInsets = UIEdgeInsetsMake(11, 10, 11, 10);
        _textInputAreaMargins = UIEdgeInsetsMake(8, 10, 8, 10);
        _textInputAreaMinimumHeight = 36;
        
        _spaceBetweenOutterItems = 5;
        _spaceBetweenInnerItems = 5;
        _maximumItemHeight = 0;
        _autoSetTextInputAreaCornerRadius = YES;
        
        _leftItems = [NSMutableArray array];
        _leftInItems = [NSMutableArray array];
        _rightItems = [NSMutableArray array];
        _rightInItems = [NSMutableArray array];
        
        _leftViews = [NSMutableArray array];
        _leftInViews = [NSMutableArray array];
        _rightInViews = [NSMutableArray array];
        _rightViews = [NSMutableArray array];
        _itemsComparatorBlock = ^NSComparisonResult(WCMessageInputItem *item1, WCMessageInputItem *item2) {
            if (item1.order < item2.order) {
                return NSOrderedAscending;
            }
            else if (item1.order > item2.order) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        };
        
        [self addSubview:self.textInputAreaView];
        [self.textInputAreaView addSubview:self.textInputView];
    }
    return self;
}

- (void)addMessageInputItem:(WCMessageInputItem *)item {
    if (item.size.height > self.maximumItemHeight) {
        self.maximumItemHeight = item.size.height;
    }
    
    switch (item.type) {
        case WCMessageInputItemPositionLeft: {
            [self.leftItems addObject:item];
            [self.leftItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        case WCMessageInputItemPositionLeftIn: {
            [self.leftInItems addObject:item];
            [self.leftInItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        case WCMessageInputItemPositionRight: {
            [self.rightItems addObject:item];
            [self.rightItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        case WCMessageInputItemPositionRightIn: {
            [self.rightInItems addObject:item];
            [self.rightInItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        default:
            break;
    }
}

- (CGFloat)currentTextInputHeight {
    return [self.textInputView currentHeight];
}

- (void)setupBottomAutoLayoutWithViewController:(UIViewController *)viewController keyboardWillAnimate:(nullable WCMessageComposerViewKeyboardWillAnimateBlock)keyboardWillAnimate keyboardInAnimate:(nullable WCMessageComposerViewKeyboardInAnimateBlock)keyboardInAnimate keyboardDidAnimate:(nullable WCMessageComposerViewKeyboardDidAnimateBlock)keyboardDidAnimate {
    
    _viewController = viewController;
    
//    self.translatesAutoresizingMaskIntoConstraints = NO;
//
//    [self.keyboardObserver registerObserverWithKeyboardWillAnimate:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow) {
//
//        !keyboardWillAnimate ?: keyboardWillAnimate(keyboardRectEnd, duration, isToShow);
//    } inAnimate:^(CGRect keyboardRectEnd, NSTimeInterval duration, BOOL isToShow) {
//        self.isVisibleKeyboard = isToShow;
//        [self adjustContentWithKeyboardRect:keyboardRectEnd];
//
//        !keyboardInAnimate ?: keyboardInAnimate(keyboardRectEnd, duration, isToShow);
//    } didAnimate:^(BOOL finished, BOOL isToShow) {
//        self.isVisibleKeyboard = isToShow;
//
//        !keyboardDidAnimate ?: keyboardDidAnimate(finished, isToShow);
//    }];
//
//    [viewController.view addConstraint:({
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:viewController.bottomLayoutGuide attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:0];
//        _constraintSpaceBetweenBottomLayoutGuide = constraint;
//        constraint;
//    })];
//
//    [viewController.view addConstraint:({
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeLeading multiplier:1 constant:0];
//        constraint;
//    })];
//
//    [viewController.view addConstraint:({
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:viewController.view attribute:NSLayoutAttributeTrailing multiplier:1 constant:0];
//        constraint;
//    })];
//
//    CGFloat height = self.maximumItemHeight + self.contentInsets.top + self.contentInsets.bottom;
//
//    [viewController.view addConstraint:({
//        NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:height];
//        constraint;
//    })];
}

- (void)adjustContentWithKeyboardRect:(CGRect)rect {
    CGFloat keyboardHeight = CGRectGetHeight(rect);

    self.constraintSpaceBetweenBottomLayoutGuide.constant = self.isVisibleKeyboard ? keyboardHeight - self.viewController.bottomLayoutGuide.length : 0.0;
    [self.viewController.view layoutIfNeeded];
}

- (void)setTextInputAreaCornerRadius:(CGFloat)textInputAreaCornerRadius {
    _textInputAreaCornerRadius = textInputAreaCornerRadius;
    _autoSetTextInputAreaCornerRadius = NO;
}

- (void)setTextFont:(UIFont *)textFont {
    _textFont = textFont;
    _textInputView.font = textFont;
}

- (void)setMaximumNumberOfLines:(int)maximumNumberOfLines {
    _maximumNumberOfLines = maximumNumberOfLines;
    _textInputView.maximumNumberOfLines = maximumNumberOfLines;
}

- (void)setMinimumNumberOfLines:(int)minimumNumberOfLines {
    _minimumNumberOfLines = minimumNumberOfLines;
    _textInputView.minimumNumberOfLines = minimumNumberOfLines;
}

#pragma mark -

- (void)willMoveToSuperview:(UIView *)newSuperview {
    if (newSuperview) {
        CGFloat leftItemsTotalWidth = 0;
        CGPoint originOfLastItem = CGPointMake(self.contentInsets.left, self.contentInsets.top);
        for (WCMessageInputItem *item in self.leftItems) {
            WCMessageInputItemView *itemView = [[WCMessageInputItemView alloc] initWithItem:item];
            itemView.origin = originOfLastItem;
            [self addSubview:itemView];
            [self.leftViews addObject:itemView];
            
            originOfLastItem = CGPointMake(CGRectGetMaxX(itemView.frame) + self.spaceBetweenOutterItems, self.contentInsets.top);
            
            leftItemsTotalWidth += CGRectGetWidth(itemView.bounds);
        }
        
        CGFloat rightItemsTotalWidth = 0;
        CGPoint originOfFirstItem = CGPointMake(CGRectGetWidth(self.bounds), self.contentInsets.top);
        for (WCMessageInputItem *item in self.rightItems) {
            WCMessageInputItemView *itemView = [[WCMessageInputItemView alloc] initWithItem:item];
            
            originOfFirstItem = CGPointMake(originOfFirstItem.x - self.spaceBetweenOutterItems - CGRectGetWidth(itemView.frame), self.contentInsets.top);
            itemView.origin = originOfFirstItem;
            [self addSubview:itemView];
            [self.rightViews addObject:itemView];
            
            rightItemsTotalWidth += CGRectGetWidth(itemView.bounds);
        }
        
        NSInteger numberOfLeftItems = MAX((int)(self.leftItems.count - 1), 0);
        NSInteger numberOfRightItems = MAX((int)(self.rightItems.count - 1), 0);
        
        CGFloat x = self.contentInsets.left + leftItemsTotalWidth + numberOfLeftItems * self.spaceBetweenOutterItems + self.textInputAreaMargins.left;
        CGFloat width = CGRectGetWidth(self.bounds) - self.contentInsets.right - self.textInputAreaMargins.right - rightItemsTotalWidth - numberOfRightItems * self.spaceBetweenOutterItems - x;
        CGFloat y = self.textInputAreaMargins.top;
        
        _textInputAreaView.frame = CGRectMake(x, y, width, UNSPECIFIED);
        _textInputView.frame = CGRectMake(0, 0, width - self.textInputAreaInsets.left - self.textInputAreaInsets.right, 0);
        
        [self adjustHeightBaseOnTextInputView:_textInputView.bounds.size.height];
        
        _textInputView.frame = ({
            CGRect frame = _textInputView.frame;
            frame.origin.x = _textInputAreaInsets.left;
            frame.origin.y = _textInputAreaInsets.top;
            frame.size.width = CGRectGetWidth(_textInputAreaView.bounds) - _textInputAreaInsets.left - _textInputAreaInsets.right;
            frame;
        });
        
        if (self.autoSetTextInputAreaCornerRadius) {
            _textInputAreaView.layer.cornerRadius = CGRectGetHeight(_textInputAreaView.bounds) / 2.0;
        }
        else {
            _textInputAreaView.layer.cornerRadius = self.textInputAreaCornerRadius;
        }
    }
}

- (void)adjustHeightBaseOnTextInputView:(CGFloat)textInputViewHeight {
    CGFloat textInputAreaViewHeight = DOUBLE_SAFE_MAX(_textInputAreaMinimumHeight, textInputViewHeight + _textInputAreaInsets.top + _textInputAreaInsets.bottom);
    
    CGFloat candidateHeight1 = textInputAreaViewHeight + _textInputAreaMargins.top + _textInputAreaMargins.bottom;
    CGFloat candidateHeight2 = _maximumItemHeight + _contentInsets.top + _contentInsets.bottom;
    
    CGFloat height = DOUBLE_SAFE_MAX(candidateHeight1, candidateHeight2);
    
    self.frame = FrameSetSize(self.frame, NAN, height);
    _textInputAreaView.frame = FrameSetSize(_textInputAreaView.frame, NAN, textInputAreaViewHeight);
}

#pragma mark - Getter

- (UIView *)textInputAreaView {
    if (!_textInputAreaView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
        view.backgroundColor = [UIColor whiteColor];
        
        _textInputAreaView = view;
    }
    
    return _textInputAreaView;
}

- (WCGrowingTextView *)textInputView {
    if (!_textInputView) {
        WCGrowingTextView *textView = [[WCGrowingTextView alloc] initWithFrame:CGRectMake(18, 7.5, 299, 0) textContainer:nil];
        textView.backgroundColor = [UIColor yellowColor];
        textView.font = [UIFont systemFontOfSize:17];
        textView.growingTextViewDelegate = self;
        textView.enableHeightChangeAnimation = NO;
        textView.contentInset = UIEdgeInsetsZero;
        textView.translatesAutoresizingMaskIntoConstraints = NO;
        
        weakify(self);
        textView.heightChangeUserActionsBlock = ^(CGFloat oldHeight, CGFloat newHeight) {
            strongifyWithReturn(self, return;);
            [self adjustHeightBaseOnTextInputView:newHeight];
        };
        
        _textInputView = textView;
    }
    
    return _textInputView;
}

- (WCKeyboardObserver *)keyboardObserver {
    if (!_keyboardObserver) {
        _keyboardObserver = [[WCKeyboardObserver alloc] initWithObservee:nil];
    }
    
    return _keyboardObserver;
}

#pragma mark - WCGrowingTextViewDelegate

//- (void)growingTextViewDidChangeHeight:(WCGrowingTextView *)growingTextView from:(CGFloat)from to:(CGFloat)to {
//    [self adjustHeightBaseOnTextInputView];
//}

@end
