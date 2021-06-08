//
//  Tests_Issues.m
//  Tests
//
//  Created by wesley_chen on 2021/6/8.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_Issues : XCTestCase

@end

@implementation Tests_Issues

- (void)test_CGBitmapContextCreate_issue_return_NULL {
    CGSize size = CGSizeMake(100, 100);
    
    UIImage *image = [UIImage imageNamed:@"1.gif"];
    UIImage *firstImage = [image.images firstObject];
    
    CGRect clippedRect = CGRectMake(0, 0, firstImage.size.width, firstImage.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(firstImage.CGImage, clippedRect);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize canvasSize = CGSizeMake(size.width * scale, size.height * scale);
    
    CGContextRef contextRef = CGBitmapContextCreate(nil, canvasSize.width, canvasSize.height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    
    XCTAssertTrue(contextRef == NULL);
    
    if (contextRef == NULL) {
        contextRef = CGBitmapContextCreate(nil, canvasSize.width, canvasSize.height, bitsPerComponent, 0, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipLast);
    }
}

- (void)test_CGBitmapContextCreate_issue_return_NULL_fixed {
    CGSize size = CGSizeMake(100, 100);
    
    UIImage *image = [UIImage imageNamed:@"2.gif"];
    UIImage *firstImage = [image.images firstObject];
    
    CGRect clippedRect = CGRectMake(0, 0, firstImage.size.width, firstImage.size.height);
    CGImageRef imageRef = CGImageCreateWithImageInRect(firstImage.CGImage, clippedRect);
    
    size_t bitsPerComponent = CGImageGetBitsPerComponent(imageRef);
    CGColorSpaceRef colorSpace = CGImageGetColorSpace(imageRef);
    CGBitmapInfo bitmapInfo = CGImageGetBitmapInfo(imageRef);
    CGFloat scale = [UIScreen mainScreen].scale;
    
    CGSize canvasSize = CGSizeMake(size.width * scale, size.height * scale);
    
    CGContextRef contextRef = CGBitmapContextCreate(nil, canvasSize.width, canvasSize.height, bitsPerComponent, 0, colorSpace, bitmapInfo);
    
    XCTAssertTrue(contextRef == NULL);
    
    if (contextRef == NULL) {
        contextRef = CGBitmapContextCreate(nil, canvasSize.width, canvasSize.height, bitsPerComponent, 0, CGColorSpaceCreateDeviceRGB(), kCGImageAlphaNoneSkipLast);
        XCTAssertTrue(contextRef != NULL);
    }
}

@end
