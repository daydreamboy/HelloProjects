//
//  CTColumnViewV2.m
//  HelloCoreText
//
//  Created by wesley_chen on 14/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "CTColumnViewV2.h"

@interface CTColumnViewV2 ()
@property (nonatomic, assign) CTFrameRef ctFrame;
@property (nonatomic, strong) NSMutableArray<NSArray *> *images;
@end

@implementation CTColumnViewV2

- (instancetype)initWithFrame:(CGRect)frame CTFrame:(CTFrameRef)ctFrame {
    self = [super initWithFrame:frame];
    if (self) {
        _ctFrame = ctFrame;
        _images = [NSMutableArray array];
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
    
    for (NSArray *imageData in self.images) {
        UIImage *image = imageData[0];
        CGRect imageBounds = CGRectFromString(imageData[1]);
        CGContextDrawImage(context, imageBounds, image.CGImage);
    }
}

@end

