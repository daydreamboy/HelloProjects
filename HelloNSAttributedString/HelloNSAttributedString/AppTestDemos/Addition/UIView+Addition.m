//
//  UIView+Addition.m
//  HelloNSAttributedString
//
//  Created by wesley_chen on 17/11/2017.
//  Copyright © 2017 chenliang-xy. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

#pragma mark - Size (width, height)

- (void)setWidth:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)width {
    return self.frame.size.width;
}

- (void)setHeight:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)height {
    return self.frame.size.height;
}

@end
