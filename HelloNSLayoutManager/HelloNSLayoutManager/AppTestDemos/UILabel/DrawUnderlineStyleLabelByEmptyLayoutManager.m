//
//  DrawUnderlineStyleLabel.m
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import "DrawUnderlineStyleLabelByEmptyLayoutManager.h"
#import "UseEmptyLayoutManager.h"

@interface DrawUnderlineStyleLabelByEmptyLayoutManager ()
@property (nonatomic, strong) UseEmptyLayoutManager *renderManager;
@end

@implementation DrawUnderlineStyleLabelByEmptyLayoutManager

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _renderManager = [[UseEmptyLayoutManager alloc] initWithAttributedString:nil];
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
