//
//  WCImageTool.h
//  HelloUIImageView
//
//  Created by wesley_chen on 2018/8/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface WCImageTool : NSObject

@end

@interface WCImageTool ()
+ (UIImage *)roundCorneredImageWithImage:(UIImage *)image radius:(CGFloat)radius size:(CGSize)size;
+ (UIImage *)roundCorneredImageWithImage:(UIImage *)image radius:(CGFloat)radius;
@end
