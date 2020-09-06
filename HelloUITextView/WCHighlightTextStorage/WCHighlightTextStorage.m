//
//  WCHighlightTextStorage.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCHighlightTextStorage.h"

@interface WCHighlightTextStorage ()
@property (nonatomic, strong) NSString *pattern;
@property (nonatomic, strong) NSDictionary *highlightAttributes;
@property (nonatomic, strong) NSRegularExpression *regExp;
@end

@implementation WCHighlightTextStorage {
    NSMutableAttributedString *_imp;
}

- (instancetype)initWithPattern:(NSString *)pattern highlightAttributes:(NSDictionary *)highlightAttributes {
    self = [super init];
    if (self) {
        _pattern = pattern;
        _highlightAttributes = highlightAttributes;
        _imp = [NSMutableAttributedString new];
    }
    return self;
}

#pragma mark - Reading Text

- (NSString *)string {
    return _imp.string;
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range {
    return [_imp attributesAtIndex:location effectiveRange:range];
}

#pragma mark - Text Editing

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)str {
    [_imp replaceCharactersInRange:range withString:str];
    // Note:
    // - NSTextStorageEditedCharacters, indicate the type of change
    // - range, the string range before the change
    // - changeInLength, the delta of the length after change
    [self edited:NSTextStorageEditedCharacters range:range changeInLength:(NSInteger)str.length - (NSInteger)range.length];
}

- (void)setAttributes:(NSDictionary<NSAttributedStringKey,id> *)attrs range:(NSRange)range {
    [_imp setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
}

#pragma mark - Syntax highlighting

- (void)processEditing {
    if (self.highlightAttributes.count == 0) {
        return;
    }
    
    NSRange paragraphRange = [self.string paragraphRangeForRange:self.editedRange];
    
    // Clear the attributes of edited range
    for (NSString *attributeName in self.highlightAttributes) {
        [self removeAttribute:attributeName range:paragraphRange];
    }
    
    [self.regExp enumerateMatchesInString:self.string options:kNilOptions range:paragraphRange usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
        // Add attributes for the found ranges
        [self addAttributes:self.highlightAttributes range:result.range];
    }];
    
    // Call super *after* changing the attributes, as it finalizes the attributes and calls the delegate methods.
    [super processEditing];
}

#pragma mark - Getter

- (NSRegularExpression *)regExp {
    if (!_regExp) {
        _regExp = [NSRegularExpression regularExpressionWithPattern:self.pattern options:kNilOptions error:NULL];
    }
    
    return _regExp;
}

@end
