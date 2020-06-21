//
//  WCResizableImageLayer.h
//  HelloUIView
//
//  Created by wesley_chen on 2019/6/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCResizableImageLayer : CALayer

@property (nonatomic, strong, readonly) UIImage *image;
@property (nonatomic, assign, readonly) UIEdgeInsets capInsets;

/**
 Create a layer which stretchs the image by cap insets

 @param image the image to stretch
 @param capInsets the cap insets
 @return the layer
 @see https://stackoverflow.com/a/11928188
 */
- (instancetype)initWithImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets;

@end

NS_ASSUME_NONNULL_END
