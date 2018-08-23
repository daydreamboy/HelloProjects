//
//  CustomImageView.h
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/1/24.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

/*!
 *  A custom image view for drawing
 */
@interface DrawedImageView : UIView

@property (nonatomic, strong) UIImage *image;

- (instancetype)initWithImage:(UIImage *)image;

@end
