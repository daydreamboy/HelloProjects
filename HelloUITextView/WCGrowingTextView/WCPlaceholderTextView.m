//
//  WCPlaceholderTextView.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCPlaceholderTextView.h"

// >= `10.0`
#ifndef IOS10_OR_LATER
#define IOS10_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"10.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@interface WCPlaceholderTextView ()
//@property (nonatomic, strong) NSDictionary *typingAttributes;
@property (nonatomic, assign, readonly) UIEdgeInsets placeholderInsets;
@property (nonatomic, strong, readwrite) NSMutableDictionary *placeholderAttributes;
@property (nonatomic, strong) NSLayoutManager *placeholderLayoutManager;
@property (nonatomic, strong) NSTextContainer *placeholderTextContainer;
@end

@implementation WCPlaceholderTextView

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        // @see https://stackoverflow.com/questions/12547823/preventing-subclasses-overriding-methods
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

- (BOOL)isEmpty {
    return self.text.length == 0;
}

- (nullable NSAttributedString *)attributedPlaceholder {
    if (_attributedPlaceholder) {
        return _attributedPlaceholder;
    }
    
    if (!self.placeholder) {
        return nil;
    }
    
    NSAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.placeholder attributes:self.placeholderAttributes];
    
    return attributedString;
}

#pragma mark - Override Methods

- (void)setFont:(UIFont *)font {
    [super setFont:font];
    
    self.placeholderAttributes[NSFontAttributeName] = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    self.placeholderAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    self.placeholderAttributes[NSForegroundColorAttributeName] = placeholderColor;
}

#pragma mark -

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextViewTextDidChangeNotification object:self];
}

- (CGRect)caretRectForPosition:(UITextPosition *)position {
    if (!self.isEmpty || self.attributedPlaceholder.length == 0) {
        return [super caretRectForPosition:position];
    }
    
    CGRect caretRect = [super caretRectForPosition:position];
    CGRect placeholderUsedRect = [self placeholderUsedRectWithAttributedString:self.attributedPlaceholder];
    
    UIUserInterfaceLayoutDirection userInterfaceLayoutDirection;

    if (IOS10_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
        userInterfaceLayoutDirection = self.effectiveUserInterfaceLayoutDirection;
#pragma GCC diagnostic pop
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
        userInterfaceLayoutDirection = [UIView userInterfaceLayoutDirectionForSemanticContentAttribute:self.semanticContentAttribute];
#pragma GCC diagnostic pop
    }
    
    UIEdgeInsets placeholderInsets = self.placeholderInsets;
    switch (userInterfaceLayoutDirection) {
        case UIUserInterfaceLayoutDirectionRightToLeft:
            caretRect.origin.x = placeholderInsets.left + CGRectGetMaxX(placeholderUsedRect) - self.textContainer.lineFragmentPadding;
            break;
        case UIUserInterfaceLayoutDirectionLeftToRight:
        default:
            caretRect.origin.x = placeholderInsets.left - self.contentInset.left + CGRectGetMinX(placeholderUsedRect) + self.textContainer.lineFragmentPadding;
            break;
    }
    
    return caretRect;
}

- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    
    if (![self isEmpty]) {
        return;
    }
    
    if (self.attributedPlaceholder.length == 0) {
        return;
    }
    
    UIEdgeInsets insets = [self placeholderInsets];
    insets.left += self.textContainer.lineFragmentPadding;
    insets.right += self.textContainer.lineFragmentPadding;
    
    CGRect placeholderRect = UIEdgeInsetsInsetRect(rect, insets);
    
    [self.attributedPlaceholder drawInRect:placeholderRect];
}

#pragma mark ::

- (UIEdgeInsets)placeholderInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.contentInset.top + self.textContainerInset.top, self.contentInset.left + self.textContainerInset.left, self.contentInset.bottom + self.textContainerInset.bottom, self.contentInset.right + self.textContainerInset.right);
    
    return insets;
}

static void commonInitializer(WCPlaceholderTextView *self) {
    self.contentMode = UIViewContentModeTop;
    self.placeholderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    
    self.placeholderAttributes = [NSMutableDictionary dictionary];
    self.placeholderAttributes[NSForegroundColorAttributeName] = self.placeholderColor;
    self.placeholderAttributes[NSFontAttributeName] = self.font;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    self.placeholderAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    self.placeholderLayoutManager = [NSLayoutManager new];
    self.placeholderTextContainer = [NSTextContainer new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUITextViewTextDidChangeNotification_WCPlaceholderTextView:) name:UITextViewTextDidChangeNotification object:self];
}

#pragma mark ::


#pragma mark -

- (CGRect)placeholderUsedRectWithAttributedString:(NSAttributedString *)attributedString {
    if (self.placeholderTextContainer.layoutManager == nil) {
        [self.placeholderLayoutManager addTextContainer:self.placeholderTextContainer];
    }
    
    NSTextStorage *textStorage = [[NSTextStorage alloc] initWithAttributedString:self.attributedPlaceholder];
    [textStorage addLayoutManager:self.placeholderLayoutManager];
    
    self.placeholderTextContainer.lineFragmentPadding = self.textContainer.lineFragmentPadding;
    self.placeholderTextContainer.size = CGSizeMake(self.textContainer.size.width, 0.0);
    
    [self.placeholderLayoutManager ensureLayoutForTextContainer:self.placeholderTextContainer];
    
    return [self.placeholderLayoutManager usedRectForTextContainer:self.placeholderTextContainer];
}

#pragma mark - NSNotification

- (void)handleUITextViewTextDidChangeNotification_WCPlaceholderTextView:(NSNotification *)notification {
    if (notification.object == self) {
        [self setNeedsDisplay];
    }
}

@end
