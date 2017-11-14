//
//  CTColumnViewV1.m
//  HelloCoreText
//
//  Created by wesley_chen on 13/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CTColumnViewV1.h"
#import <CoreText/CoreText.h>

@interface CTColumnViewV1 ()
@property (nonatomic, assign) CTFrameRef ctFrame;
@end

@implementation CTColumnViewV1

- (instancetype)initWithFrame:(CGRect)frame CTFrame:(CTFrameRef)ctFrame {
    self = [super initWithFrame:frame];
    if (self) {
        _ctFrame = ctFrame;
        self.backgroundColor = UIColor.whiteColor;
    }
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetTextMatrix(context, CGAffineTransformIdentity);
    CGContextTranslateCTM(context, 0, self.bounds.size.height);
    CGContextScaleCTM(context, 1, -1);
    
    CTFrameDraw(self.ctFrame, context);
}

@end
