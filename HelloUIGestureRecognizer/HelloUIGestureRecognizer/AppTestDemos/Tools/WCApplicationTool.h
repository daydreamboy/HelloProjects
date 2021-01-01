//
//  WCApplicationTool.h
//  HelloUIGestureRecognizer
//
//  Created by wesley_chen on 2021/1/1.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCApplicationTool : NSObject

@end

@interface WCApplicationTool ()
+ (NSString *)stringFromUITouchPhase:(UITouchPhase)phase;
@end

NS_ASSUME_NONNULL_END
