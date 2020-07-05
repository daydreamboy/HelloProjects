//
//  CircleAlphabetByCTM.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/7/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "CircleAlphabetByCTM.h"

@interface CircleAlphabetByCTM ()
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, strong) UIFont *font;
@end

@implementation CircleAlphabetByCTM

- (instancetype)initWithFrame:(CGRect)frame radius:(CGFloat)radius {
    self = [super initWithFrame:frame];
    if (self) {
        _radius = radius;
        _font = [UIFont boldSystemFontOfSize:17];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 1.0;
    }
    
    return self;
}

- (void)drawRect:(CGRect)rect {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [[UIColor whiteColor] setFill];
    CGContextFillRect(context, CGRectMake(0, 0, rect.size.width, rect.size.height));
    
    NSString *alphabet = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
    for (int i = 0; i < 26; i++) {
        NSString *letter = [alphabet substringWithRange:NSMakeRange(i, 1)];
        CGSize letterSize = [letter sizeWithAttributes:@{NSFontAttributeName:self.font}];

        //CGFloat theta = M_PI - i * (2 * M_PI / 26.0);
        
        CGFloat theta = i * (2 * M_PI / 26.0);
        // Note: the theta angle is like following graph
        /*
        center(cx, cy)
         ---------->x
         ||\
         || \  radius
         ||  \
         ||___\
         |     A
         |
         ↓ y
         */
        CGFloat x = self.center.x + self.radius * sin(theta) - letterSize.width / 2.0;
        CGFloat y = self.center.y + self.radius * cos(theta) - letterSize.height / 2.0;

        // Note: point uses UIKit coordinate system
        [letter drawAtPoint:CGPointMake(x, y) withAttributes:@{NSFontAttributeName:self.font}];
    }
}
@end
