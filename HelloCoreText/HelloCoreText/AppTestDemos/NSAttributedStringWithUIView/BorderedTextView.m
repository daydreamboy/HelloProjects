//
//  BorderedTextView.m
//  HelloCoreText
//
//  Created by wesley_chen on 14/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "BorderedTextView.h"
#import <CoreText/CoreText.h>

const NSAttributedStringKey NSBorderAttributeName = @"NSBorderAttributeName";

@implementation NSTextBorder
- (instancetype)init {
    self = [super init];
    if (self) {
        _color = UIColor.redColor;
        _width = 1.0;
        _radius = 2.0;
        _paddings = UIEdgeInsetsZero;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"color: %@, width: %f, radius: %f", _color, _width, _radius];
}
@end

@interface BorderedTextView ()

@end

@implementation BorderedTextView

- (instancetype)initWithAttributedString:(NSAttributedString *)attrStr {
    self = [super init];
    if (self) {
        _attrString = attrStr;
    }
    return self;
}

#define CFRangeZero CFRangeMake(0, 0)

- (void)drawRect:(CGRect)rect {
    // @see https://stackoverflow.com/questions/16362407/nsattributedstring-background-color-and-rounded-corners
    CGContextRef context = UIGraphicsGetCurrentContext();
//    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)self.attrString);
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, self.attrString.length), path, NULL);
    
    CFArrayRef lines = CTFrameGetLines(frame);
    CFIndex countOfLines = CFArrayGetCount(lines);
    CGPoint origins[countOfLines];
    CTFrameGetLineOrigins(frame, CFRangeZero, origins);
    
    for (NSInteger i = 0; i < countOfLines; i++) {
        CTLineRef line = CFArrayGetValueAtIndex(lines, i);
        CFArrayRef runs = CTLineGetGlyphRuns(line);
        CFIndex countOfRuns = CFArrayGetCount(runs);
        
        for (NSInteger j = 0; j < countOfRuns; j++) {
            CTRunRef run = CFArrayGetValueAtIndex(runs, j);
            CFRange runRange = CTRunGetStringRange(run);
            
            CGRect runBounds = CGRectZero;
            
            CGFloat ascent;
            CGFloat descent;
            double width = CTRunGetTypographicBounds(run, CFRangeZero, &ascent, &descent, NULL);
            
            runBounds.size.width = width;
            runBounds.size.height = ascent;
            
            runBounds.origin.x = CTLineGetOffsetForStringIndex(line, runRange.location, NULL);
            runBounds.origin.y = self.bounds.size.height - (ascent + descent);
            
            NSDictionary *dict = (NSDictionary *)CTRunGetAttributes(run);
            if (dict[NSBorderAttributeName]) {
                NSTextBorder *border = dict[NSBorderAttributeName];
                NSLog(@"");
                
                CGRect borderRect = CGRectMake(runBounds.origin.x - border.paddings.left, runBounds.origin.y - border.paddings.top, runBounds.size.width + border.paddings.left + border.paddings.right, runBounds.size.height + border.paddings.top + border.paddings.bottom);
                
                UIBezierPath *borderPath = [UIBezierPath bezierPathWithRoundedRect:borderRect cornerRadius:border.radius];
                CGContextAddPath(context, borderPath.CGPath);
                CGContextSetLineWidth(context, border.width);
                CGContextSetStrokeColorWithColor(context, border.color.CGColor);
                CGContextStrokePath(context);
            }
        }
    }
    
    CTFrameDraw(frame, context);
}

@end
