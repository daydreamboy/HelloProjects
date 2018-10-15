//
//  WCViewTool.m
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/10/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCViewTool.h"
#import <AVFoundation/AVFoundation.h>

@implementation WCViewTool

#pragma mark - Assistant Methods

#pragma mark > CGRect

+ (CGRect)safeAVMakeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect {
    if (contentSize.width <= 0 || contentSize.height <= 0) {
        return CGRectZero;
    }
    
    if (CGRectGetWidth(boundingRect) <= 0 || CGRectGetHeight(boundingRect) <= 0) {
        return CGRectZero;
    }
    
    return AVMakeRectWithAspectRatioInsideRect(contentSize, boundingRect);
}

+ (CGRect)makeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect {
    if (contentSize.width <= 0 || contentSize.height <= 0) {
        return CGRectZero;
    }
    
    if (CGRectGetWidth(boundingRect) <= 0 || CGRectGetHeight(boundingRect) <= 0) {
        return CGRectZero;
    }
    
    CGSize boundingSize = boundingRect.size;
    CGSize scaledSize = CGSizeZero;
    
    if (contentSize.width > contentSize.height) {
        // Note: landscape
        // 1. firstly scale by width ratio
        CGFloat ratioByWidth = (boundingSize.width / contentSize.width);
        
        if (contentSize.height * ratioByWidth <= boundingSize.height) {
            scaledSize = CGSizeMake(boundingSize.width, contentSize.height * ratioByWidth);
        }
        else {
            // 2. if scale by width ratio, scaled height is still greater than boundingSize.height, then scale by height ratio
            CGFloat ratioByHeight = (boundingSize.height / contentSize.height);
            scaledSize = CGSizeMake(contentSize.width * ratioByHeight, boundingSize.height);
        }
    }
    else if (contentSize.width < contentSize.height) {
        // Note: portrait
        // 1. firstly scale by height ratio
        CGFloat ratioByHeight = (boundingSize.height / contentSize.height);
        
        if (contentSize.width * ratioByHeight <= boundingSize.width) {
            scaledSize = CGSizeMake(contentSize.width * ratioByHeight, boundingSize.height);
        }
        else {
            // 2. if scale by height ratio, scaled width is still greater than boundingSize.width, then scale by width ratio
            CGFloat ratioByWidth = (boundingSize.width / contentSize.width);
            scaledSize = CGSizeMake(boundingSize.width, contentSize.height * ratioByWidth);
        }
    }
    else {
        // Note: squared
        // 1. firstly scale by width ratio
        CGFloat ratioByWidth = (boundingSize.width / contentSize.width);
        
        if (contentSize.height * ratioByWidth <= boundingSize.height) {
            scaledSize = CGSizeMake(boundingSize.width, contentSize.height * ratioByWidth);
        }
        else {
            // 2. if scale by width ratio, scaled height is still greater than boundingSize.height, then scale by height ratio
            CGFloat ratioByHeight = (boundingSize.height / contentSize.height);
            scaledSize = CGSizeMake(contentSize.width * ratioByHeight, boundingSize.height);
        }
    }
    
#if DEBUG
    if (scaledSize.width > boundingSize.width || scaledSize.height > boundingSize.height) {
        NSLog(@"This line should never show. Check scaledSize");
    }
#endif
    
    CGRect scaledRect = CGRectMake(boundingRect.origin.x + (CGRectGetWidth(boundingRect) - scaledSize.width) / 2.0, boundingRect.origin.y +  (CGRectGetHeight(boundingRect) - scaledSize.height) / 2.0, scaledSize.width, scaledSize.height);
    return scaledRect;
}

@end
