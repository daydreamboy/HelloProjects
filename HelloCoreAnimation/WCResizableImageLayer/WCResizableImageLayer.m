//
//  WCResizableImageLayer.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/6/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCResizableImageLayer.h"

@interface WCResizableImageLayer ()
@property (nonatomic, strong, readwrite) UIImage *image;
@property (nonatomic, assign, readwrite) UIEdgeInsets capInsets;
@end

@implementation WCResizableImageLayer

- (instancetype)initWithImage:(UIImage *)image capInsets:(UIEdgeInsets)capInsets {
    self = [super init];
    if (self) {
        _capInsets = capInsets;
        
        if ([image isKindOfClass:[UIImage class]]) {
            _image = image;
            
            self.contents = (id)image.CGImage;
            self.contentsScale = image.scale;
            
            CGFloat y = capInsets.top / image.size.height;
            CGFloat x = capInsets.left / image.size.width;
            CGFloat width = (image.size.width - capInsets.left - capInsets.right) / image.size.width;
            CGFloat height = (image.size.height - capInsets.top - capInsets.bottom) / image.size.height;
            
            x = MIN(MAX(0, x), 1.0);
            y = MIN(MAX(0, y), 1.0);
            width = MIN(MAX(0, width), 1.0);
            height = MIN(MAX(0, height), 1.0);
            
            self.contentsCenter = CGRectMake(x, y, width, height);
        }
    }
    return self;
}

@end
