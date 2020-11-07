//
//  WCLinkLabel_LayoutManager.m
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCLinkLabel_LayoutManager.h"

@implementation WCLinkLabel_LayoutManager

- (void)drawUnderlineForGlyphRange:(NSRange)glyphRange
                     underlineType:(NSUnderlineStyle)underlineVal
                    baselineOffset:(CGFloat)baselineOffset
                  lineFragmentRect:(CGRect)lineRect
            lineFragmentGlyphRange:(NSRange)lineGlyphRange
                   containerOrigin:(CGPoint)containerOrigin {
    // ignore underlines
}

- (void)showCGGlyphs:(const CGGlyph *)glyphs
           positions:(const CGPoint *)positions
               count:(NSUInteger)glyphCount
                font:(UIFont *)font
              matrix:(CGAffineTransform)textMatrix
          attributes:(NSDictionary *)attributes
           inContext:(CGContextRef)graphicsContext {
   UIColor *foregroundColor = attributes[NSForegroundColorAttributeName];
 
   if (foregroundColor) {
      CGContextSetFillColorWithColor(graphicsContext, foregroundColor.CGColor);
   }
 
   [super showCGGlyphs:glyphs
             positions:positions
                 count:glyphCount
                  font:font
                matrix:textMatrix
            attributes:attributes
             inContext:graphicsContext];
}

- (void)fillBackgroundRectArray:(const CGRect *)rectArray count:(NSUInteger)rectCount forCharacterRange:(NSRange)charRange color:(UIColor *)color {
    // @see https://stackoverflow.com/questions/21857408/how-to-set-nsstrings-background-cornerradius-on-ios7
    // @see https://stackoverflow.com/questions/16362407/nsattributedstring-background-color-and-rounded-corners
    CGFloat halfLineWidth = self.backgroundCornerRadius; // change this to change corners radius

    CGMutablePathRef path = CGPathCreateMutable();

    if (rectCount == 1 || (rectCount == 2 && (CGRectGetMaxX(rectArray[1]) < CGRectGetMinX(rectArray[0])))) {
        // 1 rect or 2 rects without edges in contact

         CGPathAddRect(path, NULL, CGRectInset(rectArray[0], halfLineWidth, halfLineWidth));
         if (rectCount == 2)
             CGPathAddRect(path, NULL, CGRectInset(rectArray[1], halfLineWidth, halfLineWidth));
    }
    else {
        // 2 or 3 rects
        NSUInteger lastRect = rectCount - 1;

        CGPathMoveToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[0]) + halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[0]) + halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[0]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMinY(rectArray[lastRect]) - halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMaxX(rectArray[lastRect]) - halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);
        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[lastRect]) - halfLineWidth);

        CGPathAddLineToPoint(path, NULL, CGRectGetMinX(rectArray[lastRect]) + halfLineWidth, CGRectGetMaxY(rectArray[0]) + halfLineWidth);

        CGPathCloseSubpath(path);
    }

    [color set]; // set fill and stroke color

    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetLineWidth(ctx, halfLineWidth * 2.0);
    CGContextSetLineJoin(ctx, kCGLineJoinRound);

    CGContextAddPath(ctx, path);
    CGPathRelease(path);

    CGContextDrawPath(ctx, kCGPathFillStroke);
}

@end
