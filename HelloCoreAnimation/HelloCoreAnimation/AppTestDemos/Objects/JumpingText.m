//
//  JumpingText.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/5.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "JumpingText.h"

@implementation JumpingText

@synthesize topOfString;

- (void)addTextLayersTo:(CALayer *)layer {
    if (!letters) {
        letters = [[NSMutableArray alloc] initWithCapacity:1];
    }
    
    for (CALayer *letter in letters) {
        [letter removeFromSuperlayer];
    }
    [letters removeAllObjects];
    
    CGFontRef font = CGFontCreateWithFontName(CFSTR("Courier"));
    NSString *text = @"The quick brown fox";
    CGFloat fontSize = 28;
    // We are using a mono-spaced font, so
    CGFloat textWidth = text.length * fontSize;
    // We want to center the text
    CGFloat xStart = CGRectGetMidX(layer.bounds) - textWidth / 2.0;
    for (NSUInteger i = 0; i < 1; ++i) {
        CGPoint pos = CGPointMake(xStart, CGRectGetMaxY(layer.bounds) - 50);
        
        for (NSUInteger k = 0; k < text.length; ++k) {
            CATextLayer *letter = [CATextLayer layer];
            [letters addObject:letter];
            
            letter.foregroundColor = [UIColor blueColor].CGColor;
            letter.bounds = CGRectMake(0, 0, fontSize, fontSize);
            letter.position = pos;
            letter.font = font;
            letter.fontSize = fontSize;
            letter.string = [text substringWithRange:NSMakeRange(k, 1)];
            [layer addSublayer:letter];
            
            pos.x += fontSize;
        }
    }
    CGFontRelease(font);
    topOfString = CGRectGetMaxY(layer.bounds) - 50;
}

- (void)removeTextLayers {
    for (CALayer *l in letters) {
        [l removeFromSuperlayer];
    }
}

- (void)dealloc {
	for (CALayer *letter in letters) {
		[letter removeFromSuperlayer];
	}
}

#pragma mark - NSFastEnumeration

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(__unsafe_unretained id [])buffer count:(NSUInteger)len {
    return [letters countByEnumeratingWithState:state objects:buffer count:len];
}

@end
