//
//  WCGrowingTextView.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/25.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCGrowingTextView.h"
#import "WCStickySectionManager.h"

// >= `9.0`
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCGrowingTextView ()
@property (nonatomic, strong) NSLayoutManager *calculationLayoutManager;
@property (nonatomic, strong) NSTextContainer *calculationTextContainer;
@property (nonatomic, assign, readonly) CGFloat maxHeight;
@property (nonatomic, assign, readonly) CGFloat minHeight;
@property (nonatomic, weak) NSLayoutConstraint *heightConstraint;
@property (nonatomic, strong) WCStickySection *topMaskView;
@property (nonatomic, strong) WCStickySection *bottomMaskView;
@property (nonatomic, strong) WCStickySectionManager *stickyManager;
@end

@implementation WCGrowingTextView

#pragma mark - Public Methods

- (instancetype)initWithFrame:(CGRect)frame textContainer:(NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        commonInitializer(self);
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        commonInitializer(self);
    }
    return self;
}

#pragma mark ::

static void commonInitializer(WCGrowingTextView *self) {
    self->_maximumNumberOfLines = 5;
    self->_minimumNumberOfLines = 1;
    self->_heightChangeAnimationDuration = 0.35;
    self->_enableHeightChangeAnimation = YES;
    self->_stickyManager = [[WCStickySectionManager alloc] initWithScrollView:self];
    
    [self.calculationLayoutManager addTextContainer:self.calculationTextContainer];
    
    self.contentInset = UIEdgeInsetsMake(5, 5, 5, 5);
    // Note: disable left/right padding on each line
    self.textContainer.lineFragmentPadding = 0;
    self.textContainerInset = UIEdgeInsetsZero;
    self.scrollsToTop = NO;
    self.backgroundColor = [UIColor whiteColor];
    
    for (NSLayoutConstraint *contraint in self.constraints) {
        if (contraint.firstAttribute == NSLayoutAttributeHeight && contraint.relation == NSLayoutRelationEqual) {
            self->_heightConstraint = contraint;
            self->_heightConstraint.constant = [self calculatedHeight];
            break;
        }
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUITextViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark ::

#pragma mark > Setter

- (void)setMaximumNumberOfLines:(int)maximumNumberOfLines {
    if (maximumNumberOfLines < _minimumNumberOfLines) {
        _maximumNumberOfLines = _minimumNumberOfLines;
    }
    else {
        _maximumNumberOfLines = maximumNumberOfLines;
    }
    
    [self refreshHeightIfNeededAnimated:NO];
}

- (void)setMinimumNumberOfLines:(int)minimumNumberOfLines {
    if (minimumNumberOfLines < 1) {
        _minimumNumberOfLines = 1;
    }
    else if (minimumNumberOfLines > _maximumNumberOfLines) {
        _minimumNumberOfLines = _maximumNumberOfLines;
    }
    else {
        _minimumNumberOfLines = minimumNumberOfLines;
    }
    
    [self refreshHeightIfNeededAnimated:NO];
}

- (void)setGrowingTextViewDelegate:(id<WCGrowingTextViewDelegate>)growingTextViewDelegate {
    _growingTextViewDelegate = growingTextViewDelegate;
    [super setDelegate:growingTextViewDelegate];
}

- (void)setPlaceholder:(NSString *)placeholder {
    [super setPlaceholder:placeholder];
    
    [self refreshHeightIfNeededAnimated:NO];
}

- (void)setAttributedPlaceholder:(NSAttributedString *)attributedPlaceholder {
    [super setAttributedPlaceholder:attributedPlaceholder];
    
    [self refreshHeightIfNeededAnimated:NO];
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [self refreshHeightIfNeededAnimated:NO];
}

- (void)setContentSize:(CGSize)contentSize {
    if (CGSizeEqualToSize(self.contentSize, contentSize)) {
        return;
    }
    
    [super setContentSize:contentSize];
    
    if (self.window && self.isFirstResponder) {
        [self refreshHeightIfNeededAnimated:self.enableHeightChangeAnimation];
    }
    else {
        [self refreshHeightIfNeededAnimated:NO];
    }
}

- (void)setTextContainerInset:(UIEdgeInsets)textContainerInset {
    // Note: disable set other UIEdgeInsets
    [super setTextContainerInset:UIEdgeInsetsZero];
}

#pragma mark > Getter

- (int)numberOfLines {
    int numberOfLines = 0;
    NSUInteger index = 0;
    NSRange lineRange = NSMakeRange(0, 0);
    NSUInteger numberOfGlyphs = self.layoutManager.numberOfGlyphs;
    while (index < numberOfGlyphs) {
        if (IOS9_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
            [self.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange withoutAdditionalLayout:YES];
#pragma GCC diagnostic pop
        }
        else {
            [self.layoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange];
        }
        index = NSMaxRange(lineRange);
        numberOfLines += 1;
    }
    return numberOfLines;
}

- (CGSize)intrinsicContentSize {
    if (self.heightConstraint) {
        return CGSizeMake(UIViewNoIntrinsicMetric, UIViewNoIntrinsicMetric);
    }
    else {
        return CGSizeMake(UIViewNoIntrinsicMetric, [self calculatedHeight]);
    }
}

- (CGFloat)currentHeight {
    return [self calculatedHeight];
}

#pragma mark > Override

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    CGRect caretRect = [super caretRectForPosition:position];
    CGFloat lineHeight = [self heightForNumberOfLines:1] - [self insetHeight];
    // Note: make caret correct match one line height, and shift y more accurate
    return CGRectMake(caretRect.origin.x, ceil(caretRect.origin.y + 1), CGRectGetWidth(caretRect), lineHeight);
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.topMaskView.superview) {
        [self.stickyManager addStickySection:({
            UIEdgeInsets contentInsets = self.contentInset;
            
            WCStickySection *view = [[WCStickySection alloc] initWithFixedY:0 height:contentInsets.top];
            
            // Note: top mask view addSubview consider the contentInset, so use negative x and y
            view.frame = CGRectMake(-contentInsets.left, 0, CGRectGetWidth(self.bounds), 0);
            view.backgroundColor = self.backgroundColor;
            [self insertSubview:view atIndex:0];
            
            _topMaskView = view;
            view;
        }) atInitialY:-self.contentInset.top];
    }
    
    if (!self.bottomMaskView.superview) {
        UIEdgeInsets contentInsets = self.contentInset;
        CGFloat heightOfMaximumLines = [self maxHeight];
        CGFloat fixedY = heightOfMaximumLines - contentInsets.bottom;
        CGFloat initialY = heightOfMaximumLines - contentInsets.bottom - contentInsets.bottom;
        
        [self.stickyManager addStickySection:({
            WCStickySection *view = [[WCStickySection alloc] initWithFixedY:fixedY height:contentInsets.bottom];
            
            // Note: top mask view addSubview consider the contentInset, so use negative x and y
            view.frame = CGRectMake(-contentInsets.left, 0, CGRectGetWidth(self.bounds), 0);
            view.backgroundColor = self.backgroundColor;
            [self insertSubview:view atIndex:0];
            
            _bottomMaskView = view;
            view;
        }) atInitialY:initialY];
    }
}

#pragma mark - Getter

- (NSLayoutManager *)calculationLayoutManager {
    if (!_calculationLayoutManager) {
        _calculationLayoutManager = [[NSLayoutManager alloc] init];
    }
    
    return _calculationLayoutManager;
}

- (NSTextContainer *)calculationTextContainer {
    if (!_calculationTextContainer) {
        _calculationTextContainer = [[NSTextContainer alloc] init];
    }
    
    return _calculationTextContainer;
}

#pragma mark -

- (CGFloat)calculatedHeight {
    NSTextStorage *textStorage;
    
    if (self.attributedText.length) {
        textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedText];
    }
    else if (self.attributedPlaceholder.length) {
        textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedPlaceholder];
    }
    else {
        textStorage = nil;
    }
    
    CGFloat height;
    
    if (textStorage) {
        [textStorage addLayoutManager:self.calculationLayoutManager];
        
        self.calculationTextContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
        self.calculationTextContainer.size = CGSizeMake(self.textContainer.size.width, 0.0);
        
        [self.calculationLayoutManager ensureLayoutForTextContainer:self.calculationTextContainer];
        
        height = [self.calculationLayoutManager usedRectForTextContainer:self.calculationTextContainer].size.height + self.contentInset.top + self.contentInset.bottom + self.textContainerInset.top + self.textContainerInset.bottom;
        
        if (height < self.minHeight) {
            height = self.minHeight;
        }
        else if (height > self.maxHeight) {
            height = self.maxHeight;
        }
    }
    else {
        height = self.minHeight;
    }
    
    // Note: fix UITextView appears a gray hairline when text reaches 3rd line while set maximumNumberOfLines = 3
    return ceil(height);
}

- (CGFloat)heightForNumberOfLines:(int)numberOfLines {
    CGFloat height = [self insetHeight];
    
    NSUInteger numberOfNonEmptyLines = 0;
    NSUInteger index = 0;
    NSUInteger numberOfGlyphs = self.calculationLayoutManager.numberOfGlyphs;
    while (index < numberOfGlyphs && numberOfNonEmptyLines < numberOfLines) {
        NSRange lineRange = {0, 0};
        if (IOS9_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
            height += [self.calculationLayoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange withoutAdditionalLayout:YES].size.height;
#pragma GCC diagnostic pop
        }
        else {
            height += [self.calculationLayoutManager lineFragmentRectForGlyphAtIndex:index effectiveRange:&lineRange].size.height;
        }
        
        index = NSMaxRange(lineRange);
        numberOfNonEmptyLines += 1;
    }
    
    NSInteger numberOfEmptyLines = numberOfLines - numberOfNonEmptyLines;
    if (numberOfEmptyLines > 0) {
        UIFont *font = self.typingAttributes[NSFontAttributeName] ?: self.font;
        font = font ?: [UIFont systemFontOfSize:[UIFont systemFontSize]];
        
        CGFloat lineHeight = font.lineHeight;
        NSParagraphStyle *paragraphStyle = self.typingAttributes[NSParagraphStyleAttributeName];
        if (paragraphStyle) {
            if (paragraphStyle.lineHeightMultiple > 0) {
                lineHeight *= paragraphStyle.lineHeightMultiple;
            }
            
            if (paragraphStyle.minimumLineHeight > 0 && lineHeight < paragraphStyle.minimumLineHeight) {
                lineHeight = paragraphStyle.minimumLineHeight;
            }
            else if (paragraphStyle.maximumLineHeight > 0 && lineHeight > paragraphStyle.maximumLineHeight) {
                lineHeight = paragraphStyle.maximumLineHeight;
            }
            
            lineHeight += paragraphStyle.lineSpacing;
        }
        height += lineHeight * numberOfEmptyLines;
    }
    
    return ceil(height);
}

- (CGFloat)insetHeight {
    return self.contentInset.top + self.contentInset.bottom + self.textContainerInset.top + self.textContainerInset.bottom;
}

- (CGFloat)maxHeight {
    if (self.useHeightForNumberOfLines) {
        return self.maximumHeight;
    }
    else {
        return [self heightForNumberOfLines:self.maximumNumberOfLines];
    }
}

- (CGFloat)minHeight {
    if (self.useHeightForNumberOfLines) {
        return self.minimumHeight;
    }
    else {
        return [self heightForNumberOfLines:self.minimumNumberOfLines];
    }
}

- (void)refreshHeightIfNeededAnimated:(BOOL)animated {
    CGFloat oldHeight = self.bounds.size.height;
    CGFloat newHeight = [self calculatedHeight];
    
    if (oldHeight != newHeight) {
        void (^heightChangeSetHeightBlock)(CGFloat, CGFloat) = ^(CGFloat oldHeight, CGFloat newHeight) {
            [self setHeight:newHeight];
            
            if (self.window) {
                !self.heightChangeUserActionsBlock ?: self.heightChangeUserActionsBlock(oldHeight, newHeight);
            }
            
            if (self.superview) {
                [self layoutIfNeeded];
            }
        };
        
        void (^heightChangeCompletionBlock)(CGFloat, CGFloat) = ^(CGFloat oldHeight, CGFloat newHeight) {
            [self.layoutManager ensureLayoutForTextContainer:self.textContainer];
            [self scrollToVisibleCaretIfNeeded];
            
            // Note: only when this view showing on screen to call delegate
            if (self.window && [self.growingTextViewDelegate respondsToSelector:@selector(growingTextViewDidChangeHeight:from:to:)]) {
                [self.growingTextViewDelegate growingTextViewDidChangeHeight:self from:oldHeight to:newHeight];
            }
        };
        
        // Note: only when this view showing on screen to call delegate
        if (self.window && [self.growingTextViewDelegate respondsToSelector:@selector(growingTextViewWillChangeHeight:from:to:)]) {
            [self.growingTextViewDelegate growingTextViewWillChangeHeight:self from:oldHeight to:newHeight];
        }
        
        if (animated) {
            [UIView animateWithDuration:self.heightChangeAnimationDuration delay:0 options:UIViewAnimationOptionAllowUserInteraction | UIViewAnimationOptionBeginFromCurrentState animations:^{
                heightChangeSetHeightBlock(oldHeight, newHeight);
            } completion:^(BOOL finished) {
                heightChangeCompletionBlock(oldHeight, newHeight);
            }];
        }
        else {
            heightChangeSetHeightBlock(oldHeight, newHeight);
            heightChangeCompletionBlock(oldHeight, newHeight);
        }
    }
    else {
        [self scrollToVisibleCaretIfNeeded];
    }
}

- (void)setHeight:(CGFloat)height {
    if (self.heightConstraint) {
        self.heightConstraint.constant = height;
    }
    else if (self.constraints.count != 0) {
        [self invalidateIntrinsicContentSize];
        [self setNeedsLayout];
    }
    else {
        CGRect frame = self.frame;
        frame.size.height = height;
        self.frame = frame;
    }
}

- (void)scrollToVisibleCaretIfNeeded {
    UITextPosition *textPosition = self.selectedTextRange.end;
    if (!textPosition) {
        return;
    }
    
    if (self.textStorage.editedRange.location == NSNotFound && !self.isDragging && !self.isDecelerating) {
        CGRect caretRect = [self caretRectForPosition:textPosition];
        // ???: height and width is 0 ？
        CGRect caretCenterRect = CGRectMake(CGRectGetMidX(caretRect), CGRectGetMidY(caretRect), 0, 0);
        
        // @see https://stackoverflow.com/a/31864330
        [self scrollRectToVisible:caretCenterRect animated:NO];
        //[self scrollRectToVisibleConsideringInsets:caretCenterRect];
    }
}

- (void)scrollRectToVisibleConsideringInsets:(CGRect)rect {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.contentInset.top + self.textContainerInset.top, self.contentInset.left + self.textContainerInset.left + self.textContainer.lineFragmentPadding, self.contentInset.bottom + self.textContainerInset.bottom, self.contentInset.right + self.textContainerInset.right);
    // @see https://stackoverflow.com/a/27741676
    CGRect visibleRect = UIEdgeInsetsInsetRect(self.bounds, insets);
    
    if (CGRectContainsRect(visibleRect, rect)) {
        return;
    }
    
    CGPoint contentOffset = self.contentOffset;
    if (CGRectGetMinY(rect) < CGRectGetMinY(visibleRect)) {
        contentOffset.y = CGRectGetMinY(rect) - insets.top * 2;
    }
    else {
        contentOffset.y = CGRectGetMaxY(rect) + insets.bottom * 2 - self.bounds.size.height;
    }
    
    [self setContentOffset:contentOffset animated:NO];
}

#pragma mark - NSNotification

- (void)handleUITextViewTextDidChangeNotification:(NSNotification *)notification {
    [self refreshHeightIfNeededAnimated:self.enableHeightChangeAnimation];
}

@end
