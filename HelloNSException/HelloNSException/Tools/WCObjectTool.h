//
//  WCObjectTool.h
//  HelloNSException
//
//  Created by wesley_chen on 2019/9/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef IMP _Nonnull *IMPPtr;

@interface WCObjectTool : NSObject

/**
 Exchange the IMP directly

 @param cls the Class to modify
 @param swizzledIMP the swizzled C function
 @param originalSelector the original selector which should exist
 @param originalIMPPtr the original C function
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)exchangeIMPWithClass:(Class)cls swizzledIMP:(IMP)swizzledIMP originalSelector:(SEL)originalSelector originalIMPPtr:(IMPPtr _Nonnull)originalIMPPtr;

@end

NS_ASSUME_NONNULL_END
