//
//  DrawUnderlineStyleLabelByOverrideUnderlineLayoutManager.m
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import "DrawUnderlineStyleLabelByOverrideUnderlineLayoutManager.h"
#import "UseOverrideUnderlineLayoutManager.h"

@interface DrawUnderlineStyleLabelByOverrideUnderlineLayoutManager ()
@property (nonatomic, strong) UseOverrideUnderlineLayoutManager *renderManager;
@end

@implementation DrawUnderlineStyleLabelByOverrideUnderlineLayoutManager

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _renderManager = [[UseOverrideUnderlineLayoutManager alloc] initWithAttributedString:nil];
    }
    
    return self;
}

- (void)setAttributedText:(NSAttributedString *)attributedText {
    [super setAttributedText:attributedText];
    
    [_renderManager setAttributedString:attributedText];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [_renderManager configureTextContainerSizeWithLabel:self];
}

- (void)drawTextInRect:(CGRect)rect {
    [_renderManager drawGlyphs];
    
    // Note: use NSLayoutManager to draw instead of super method
    //[super drawTextInRect:rect];
}

@end
