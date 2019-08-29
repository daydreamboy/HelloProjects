//
//  LayoutALineView.m
//  HelloCoreText
//
//  Created by wesley_chen on 2019/4/23.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "LayoutALineView.h"
#import <CoreText/CoreText.h>

@implementation LayoutALineView

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
//    CGContextSetTextMatrix(context, CGAffineTransformMakeScale(1.0f, -1.0f));
    
    CGPoint locationTextDrawn = CGContextGetTextPosition(context);
    NSLog(@"%@", NSStringFromCGPoint(locationTextDrawn));

    // Flip the context coordinates
//    CGContextTranslateCTM(context, 0, self.bounds.size.height);
//    CGContextScaleCTM(context, 1.0, -1.0);
    
    locationTextDrawn = CGContextGetTextPosition(context);
    NSLog(@"%@", NSStringFromCGPoint(locationTextDrawn));
    
//    // Set the text matrix
//    CGAffineTransform affineTransform = CGContextGetTextMatrix(context);
//    affineTransform = CGAffineTransformTranslate(affineTransform, 0, -self.bounds.size.height);
//    CGContextSetTextMatrix(context, affineTransform);
    
    CFStringRef textString = CFSTR("A text line drawed by CTLine.");
    // @see https://stackoverflow.com/a/10620714
    CTFontRef font = CTFontCreateWithName((CFStringRef)@"Helvetica", 12, NULL);
    
    CFStringRef keys[] = { kCTFontAttributeName };
    CFTypeRef values[] = { font };
    
    CFDictionaryRef attributes = CFDictionaryCreate(kCFAllocatorDefault, (const void **)&keys, (const void **)&values, sizeof(keys) / sizeof(keys[0]), &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    
    CFAttributedStringRef attrString = CFAttributedStringCreate(kCFAllocatorDefault, textString, attributes);
    CFRelease(textString);
    CFRelease(attributes);
    
    CTLineRef line = CTLineCreateWithAttributedString(attrString);
    
    // Set text position and draw the line into the graphics context
//    CGContextSetTextPosition(context, 10.0, 5); // origin: bottom-left
    CTLineDraw(line, context);
    CFRelease(line);
    CFRelease(attrString);
}

@end
