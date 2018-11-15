//
//  WCViewTool.m
//  HelloUIImage
//
//  Created by wesley_chen on 2018/11/14.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"

@implementation WCViewTool

#pragma mark - Assistant Methods

#pragma mark > CGRect

+ (CGRect)centeredRectInRectWithSize:(CGSize)size inRect:(CGRect)rect {
    if (size.width <= 0 || size.height <= 0 ||
        rect.size.width <= 0 || rect.size.height <= 0) {
        return CGRectZero;
    }
    
    CGPoint origin = rect.origin;
    CGFloat deltaX = (rect.size.width - size.width) / 2.0;
    CGFloat deltaY = (rect.size.height - size.height) / 2.0;
    
    origin.x += deltaX;
    origin.y += deltaY;
    
    CGRect centeredRect = CGRectMake(origin.x, origin.y, size.width, size.height);
    return centeredRect;
}

#pragma mark > CGSize

+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToWidth:(CGFloat)fixedWidth {
    if (contentSize.width <= 0 || contentSize.height <= 0 || fixedWidth <= 0) {
        return CGSizeZero;
    }
    
    CGFloat ratioByWidth = (fixedWidth / contentSize.width);
    return CGSizeMake(fixedWidth, contentSize.height * ratioByWidth);
}

+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToHeight:(CGFloat)fixedHeight {
    if (contentSize.width <= 0 || contentSize.height <= 0 || fixedHeight <= 0) {
        return CGSizeZero;
    }
    
    CGFloat ratioByHeight = (fixedHeight / contentSize.height);
    return CGSizeMake(contentSize.width * ratioByHeight, fixedHeight);
}

@end
