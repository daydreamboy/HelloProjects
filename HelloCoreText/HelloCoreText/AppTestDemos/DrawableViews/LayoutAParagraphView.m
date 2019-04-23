//
//  LayoutAParagraphView.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "LayoutAParagraphView.h"
#import <CoreText/CoreText.h>

@implementation LayoutAParagraphView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Flip the context coordinates
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    // Set the text matrix
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    
    // Create a path which bounds the are where you will be drawing text
    // The path need not be rectangular
    CGMutablePathRef path = CGPathCreateMutable();
    
    // In this simple example, initialize a rectangular path
    CGRect bounds = CGRectMake(0, 0, rect.size.width, rect.size.height);
    CGPathAddRect(path, NULL, bounds);
    
    // Initialize a string
    CFStringRef textString = CFSTR("Hello, World! I know nothing in the world that has as much power as a word. Somtimes I write one, and I look at it, until it begins to shine.");
    
    // Create a mutable attributed string with a max length of 0
    // The max length is a hint as to how much internal storage to reserve
    // 0 means no hint.
    CFMutableAttributedStringRef attrString = CFAttributedStringCreateMutable(kCFAllocatorDefault, 0);
    
    // Copy the textString into the newly created attrString
    CFAttributedStringReplaceString(attrString, CFRangeMake(0, 0), textString);
    
    // Create a color that will be added as an attribute to the attrString
    CGColorSpaceRef rgbColorSpace = CGColorSpaceCreateDeviceRGB();
    CGFloat components[] = { 1.0, 0.0, 0.0, 0.8 };
    CGColorRef red = CGColorCreate(rgbColorSpace, components);
    CGColorSpaceRelease(rgbColorSpace);
    
    // Set the color of the first 12 chars to red
    CFAttributedStringSetAttribute(attrString, CFRangeMake(0, 12), kCTForegroundColorAttributeName, red);
    
    // Create the framesetter with the attributed string
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString(attrString);
    CFRelease(attrString);
    
    // Create a frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, 0), path, NULL);
    
    // Draw the specific frame in the given context
    CTFrameDraw(frame, context);
    
    // Release the objects we used
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
}

@end
