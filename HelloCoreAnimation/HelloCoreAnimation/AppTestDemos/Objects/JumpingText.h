//
//  JumpingText.h
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/4/5.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JumpingText : NSObject <NSFastEnumeration> {
    NSMutableArray *letters;
    CGFloat topOfString;
}

@property (readonly) CGFloat topOfString;

- (void)addTextLayersTo:(CALayer *)layer;
- (void)removeTextLayers;

@end
