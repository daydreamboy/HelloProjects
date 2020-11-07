//
//  OverrideUnderlineLayoutManager.m
//  HelloNSLayoutManager
//
//  Created by wesley_chen on 2020/11/7.
//

#import "OverrideUnderlineLayoutManager.h"

@implementation OverrideUnderlineLayoutManager

// @see https://stackoverflow.com/a/61493344
- (void)drawUnderlineForGlyphRange:(NSRange)glyphRange
                     underlineType:(NSUnderlineStyle)underlineVal
                    baselineOffset:(CGFloat)baselineOffset
                  lineFragmentRect:(CGRect)lineRect
            lineFragmentGlyphRange:(NSRange)lineGlyphRange
                   containerOrigin:(CGPoint)containerOrigin {
    CGFloat firstPosition = [self locationForGlyphAtIndex:glyphRange.location].x;
    CGFloat lastPosition;

    if (NSMaxRange(glyphRange) < NSMaxRange(lineGlyphRange)) {
        lastPosition = [self locationForGlyphAtIndex:NSMaxRange(glyphRange)].x;
    }
    else {
        lastPosition = [self lineFragmentUsedRectForGlyphAtIndex:NSMaxRange(glyphRange) - 1 effectiveRange:NULL].size.width;
    }

    CGRect lineRectL = lineRect;
    CGFloat height = lineRectL.size.height * 3.5 / 4.0;
    lineRectL.origin.x += firstPosition;
    lineRectL.size.width = lastPosition - firstPosition;
    lineRectL.size.height = height;

    lineRectL.origin.x += containerOrigin.x;
    lineRectL.origin.y += containerOrigin.y;

    lineRectL = CGRectOffset(CGRectIntegral(lineRectL), 0.5, 0.5);

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:lineRectL cornerRadius:3];

    [path stroke];
}

@end
