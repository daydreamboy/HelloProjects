//
//  ManualLineBreakView.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ManualLineBreakView.h"
#import <CoreText/CoreText.h>

@implementation ManualLineBreakView

- (void)drawRect:(CGRect)rect {
    double width = 100;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // configure context
    CGContextTranslateCTM(context, 0.0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // set text matrix
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    CFAttributedStringRef attrString = (__bridge CFAttributedStringRef)self.textString;
    
    // Create a typesetter using the attributed string
    CTTypesetterRef typesetter = CTTypesetterCreateWithAttributedString(attrString);
    
    // Find a break for line from the beginning of the string to the given width
    CFIndex start = 0;
    // Note: A count of the characters from startIndex that would cause the line break.
    CFIndex count = CTTypesetterSuggestLineBreak(typesetter, start, width);
    
    // Use the returned character count (to the break) to create the line
    CTLineRef line = CTTypesetterCreateLine(typesetter, CFRangeMake(start, count));
    
    // Get the offset needed to center the line
    float flush = 0.5;
    double penOffset = CTLineGetPenOffsetForFlush(line, flush, width);
    
    CGPoint textPosition = { 10.0, 10.0 };
    
    // Move the given text drawing position by the calculated offset and draw the line
    CGContextSetTextPosition(context, textPosition.x + penOffset, textPosition.y);
    CTLineDraw(line, context);
    
    // Move the index beyond the line break
    start += count;
}

@end
