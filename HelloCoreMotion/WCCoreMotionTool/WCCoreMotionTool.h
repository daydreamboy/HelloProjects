//
//  WCCoreMotionTool.h
//  HelloCMMotionManager
//
//  Created by wesley_chen on 2021/3/27.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCCoreMotionTool : NSObject

+ (BOOL)startDeviceMotionListenerWithBizID:(NSString *)bizID updateHandler:(void (^)(CMDeviceMotion *motion, NSError *error))updateHandler;
+ (void)stopDeviceMotionListenerWithBizID:(NSString *)bizID completion:(void (^)(BOOL success))completion;

@end

NS_ASSUME_NONNULL_END
