//
//  WCViewTool.h
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/10/15.
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
 Safe wrapper of AVMakeRectWithAspectRatioInsideRect
 
 @param contentSize the content size to scale and fit to the bounding rect
 @param boundingRect the bounding rect
 @return the scaled rect
 @discussion 1. The AVMakeRectWithAspectRatioInsideRect's signature is CGRect AVMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect), and contentSize for aspectRatio, boundingRect for boundingRect. 2. This method internally use AVMakeRectWithAspectRatioInsideRect.
 */
+ (CGRect)safeAVMakeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect;

/**
 Equivalent of AVMakeRectWithAspectRatioInsideRect
 
 @param contentSize the content size to scale and fit to the bounding rect
 @param boundingRect the bounding rect
 @return the scaled rect
 @discussion The AVMakeRectWithAspectRatioInsideRect's signature is CGRect AVMakeRectWithAspectRatioInsideRect(CGSize aspectRatio, CGRect boundingRect), and contentSize for aspectRatio, boundingRect for boundingRect
 */
+ (CGRect)makeAspectRatioRectWithContentSize:(CGSize)contentSize insideBoundingRect:(CGRect)boundingRect;

@end
