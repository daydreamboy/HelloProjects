//
//  YWVideoProgressLayer.h
//  VideoTest
//
//  Created by sidian on 16/2/26.
//  Copyright © 2016年 SiDian. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@interface YWVideoProgressLayer : CALayer

@property (nonatomic, assign) CGFloat progress;
@property (nonatomic, assign) BOOL isRotating;

- (id)initWithFrame:(CGRect)frame;

- (void)startWaitRotating;
- (void)stopWaitRotating;

@end
