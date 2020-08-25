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

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer {
    self = [super initWithFrame:frame textContainer:textContainer];
    if (self) {
        [self commonInitializer];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super initWithCoder:coder];
    if (self) {
        [self commonInitializer];
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
    
    _placeholderAttributes[NSFontAttributeName] = font;
}

- (void)setTextAlignment:(NSTextAlignment)textAlignment {
    [super setTextAlignment:textAlignment];
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = textAlignment;
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    _placeholderAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
}

- (void)setPlaceholderColor:(UIColor *)placeholderColor {
    _placeholderColor = placeholderColor;
    
    _placeholderAttributes[NSForegroundColorAttributeName] = placeholderColor;
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
            break;
        default:
            caretRect.origin.x = placeholderInsets.left + CGRectGetMinX(placeholderUsedRect) + self.textContainer.lineFragmentPadding;
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

- (UIEdgeInsets)placeholderInsets {
    UIEdgeInsets insets = UIEdgeInsetsMake(self.contentInset.top + self.textContainerInset.top, self.contentInset.left + self.textContainerInset.left, self.contentInset.bottom + self.textContainerInset.bottom, self.contentInset.right + self.textContainerInset.right);
    
    return insets;
}

#pragma mark -

- (void)commonInitializer {
    self.contentMode = UIViewContentModeTop;
    _placeholderColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:1];
    
    _placeholderAttributes = [NSMutableDictionary dictionary];
    _placeholderAttributes[NSForegroundColorAttributeName] = _placeholderColor;
    _placeholderAttributes[NSFontAttributeName] = self.font;
    
    NSMutableParagraphStyle *paragraphStyle = [NSMutableParagraphStyle new];
    paragraphStyle.alignment = self.textAlignment;
    paragraphStyle.lineBreakMode = self.textContainer.lineBreakMode;
    _placeholderAttributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    _placeholderLayoutManager = [NSLayoutManager new];
    _placeholderTextContainer = [NSTextContainer new];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleUITextViewTextDidChangeNotification:) name:UITextViewTextDidChangeNotification object:self];
}

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

- (void)handleUITextViewTextDidChangeNotification:(NSNotification *)notification {
    if (notification.object == self) {
        [self setNeedsDisplay];
    }
}

@end
