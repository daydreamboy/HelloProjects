//
//  CTViewV1.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CTViewV1.h"

@implementation CTViewV1

- (void)drawRect:(CGRect)rect {
    // Step 1: get draw context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Step 2: do drawing
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, nil, self.bounds);
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"Hello World"];
    
    // Step 3: create framesetter
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((CFAttributedStringRef)attrString);
    
    // Step 4: create frame
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(0, attrString.length), path, nil);
    
    // Step 5: draw frame in context
    CTFrameDraw(frame, context);
}

@end
