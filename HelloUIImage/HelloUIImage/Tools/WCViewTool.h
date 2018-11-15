//
//  WCViewTool.h
//  HelloUIImage
//
//  Created by wesley_chen on 2018/11/14.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCViewTool : NSObject

@end

@interface WCViewTool ()

#pragma mark - Assistant Methods

#pragma mark > CGRect

/**
 Get the rect with specific size which always centered in the rect
 
 @param size the size of the centered rect
 @param rect the super rect
 @return the centered rect. Return CGRectZero if the `size` or `rect` have zero width or zero height.
 */
+ (CGRect)centeredRectInRectWithSize:(CGSize)size inRect:(CGRect)rect;

#pragma mark > CGSize

/**
 Get scaled size by ratio of width
 
 @param contentSize the content size
 @param fixedWidth the fixed width to fit
 @return the scaled size. Return CGSizeZero if the content's width or height is <= 0 or fixedWidth <= 0
 */
+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToWidth:(CGFloat)fixedWidth;

/**
 Get scaled size by ratio of height
 
 @param contentSize the content size
 @param fixedHeight the fixed height to fit
 @return the scaled size. Return CGSizeZero if the content's width or height is <= 0 or fixedHeight <= 0
 */
+ (CGSize)scaledSizeWithContentSize:(CGSize)contentSize fitToHeight:(CGFloat)fixedHeight;

@end
