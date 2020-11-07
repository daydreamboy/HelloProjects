//
//  LabelBaseRenderManager.m
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import "LabelBaseRenderManager.h"


@interface LabelBaseRenderManager ()
@property (nonatomic, strong) NSLayoutManager *layoutManagerInternal;
@property (nonatomic, strong) NSTextStorage *textStorage;
@property (nonatomic, strong) NSTextContainer *textContainer;
@property (nonatomic, weak) UILabel *label;
@end

@implementation LabelBaseRenderManager

- (instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString {
    return [self initWithAttributedString:attributedString layoutManager:nil];
}

- (instancetype)initWithAttributedString:(nullable NSAttributedString *)attributedString layoutManager:(NSLayoutManager *)layoutManager {
    self = [super init];
    if (self) {
        _layoutManagerInternal = layoutManager;
        [self setAttributedString:attributedString];
    }
    return self;
}

- (void)setAttributedString:(NSAttributedString *)attributedString {
    if ([attributedString isKindOfClass:[NSAttributedString class]]) {
        [self.textStorage setAttributedString:attributedString];
    }
}

- (NSLayoutManager *)layoutManager {
    return _layoutManagerInternal;
}

- (void)configureTextContainerSizeWithLabel:(UILabel *)label {
    _label = label;
    _textContainer.size = label.bounds.size;
    _textContainer.maximumNumberOfLines = label.numberOfLines;
}

- (void)drawGlyphs {
    CGPoint textOffset;
    NSRange glyphRange = [_layoutManagerInternal glyphRangeForTextContainer:_textContainer];
    textOffset = [self textOffsetForGlyphRange:glyphRange];
    
    [_layoutManagerInternal drawGlyphsForGlyphRange:glyphRange atPoint:textOffset];
}

#pragma mark - Getter

- (NSTextStorage *)textStorage {
    if (!_textStorage) {
        _textStorage = [[NSTextStorage alloc] init];
        _textContainer = [[NSTextContainer alloc] init];
        _textContainer.lineFragmentPadding = 0;
        
        [_textStorage addLayoutManager:_layoutManagerInternal];
        [_layoutManagerInternal addTextContainer:_textContainer];
        
        [_layoutManagerInternal setTextStorage:_textStorage];
        [_textContainer setLayoutManager:_layoutManagerInternal];
    }
    
    return _textStorage;
}

#pragma mark - Utility

- (CGPoint)textOffsetForGlyphRange:(NSRange)glyphRange {
    CGPoint textOffset = CGPointZero;
  
    CGRect textBounds = [_layoutManagerInternal boundingRectForGlyphRange:glyphRange inTextContainer:_textContainer];
    CGFloat paddingHeight = (self.label.bounds.size.height - textBounds.size.height) / 2.0f;
    if (paddingHeight > 0) {
        textOffset.y = paddingHeight;
    }
  
    return textOffset;
}

@end
