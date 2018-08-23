//
//  LayerWithProgress.h
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

@protocol LayerWithProgressProtocol <NSObject>

- (void)progressUpdatedTo:(CGFloat)progress;

@end

@interface LayerWithProgress : CAShapeLayer
@property CGFloat progress;
@property (weak) id<LayerWithProgressProtocol> progressdelegate;

@end
