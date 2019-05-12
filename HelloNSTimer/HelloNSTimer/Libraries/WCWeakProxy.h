//
//  WCWeakProxy.h
//  HelloNSProxy
//
//  Created by wesley_chen on 2018/5/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 A proxy used to hold a weak object.
 It can be used to avoid retain cycles, such as the target in NSTimer or CADisplayLink.
 
 @see https://github.com/ibireme/YYKit/blob/master/YYKit/Utility/YYWeakProxy.h
 */
@interface WCWeakProxy : NSProxy
@property (nonatomic, weak, readonly, nullable) id target;

- (instancetype)initWithTarget:(id)target;
+ (instancetype)proxyWithTarget:(id)target;
@end

/**
 Convenient macro to create a wrapper for the target

 @param target the original target
 */
#define WCWeakProxy_NEW(target) ([WCWeakProxy proxyWithTarget:target])

NS_ASSUME_NONNULL_END
