//
//  WCQuartzTool.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreGraphics/CoreGraphics.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCQuartzTool : NSObject

#pragma mark - CGPathRef

/**
 Get all points of the CGPathRef
 
 @param path the CGPathRef
 
 @return the points include control points
 @see https://stackoverflow.com/a/5714872
 */
+ (nullable NSArray<NSValue *> *)allPointsWithCGPath:(CGPathRef)path;

@end

NS_ASSUME_NONNULL_END
