//
//  WCObjCRuntimeUtility.h
//  HelloObjCRuntime
//
//  Created by wesley chen on 16/12/8.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef IMP *IMPPtr;

@interface WCObjCRuntimeUtility : NSObject

#pragma mark - Swizzle Helper Methods

+ (void)replaceIMPOfOriginalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector onClass:(Class)class withBlock:(id)block;
+ (IMP)replaceMethodWithSelector:(SEL)originalSelector onClass:(Class)class withBlock:(id)block;

+ (void)exchangeIMPForClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector;
+ (BOOL)exchangeIMPForSelector:(SEL)originalSelector onClass:(Class)class swizzledIMP:(IMP)swizzledIMP originalIMP:(IMPPtr)originalIMPPtr;

+ (SEL)swizzledSelectorForSelector:(SEL)selector;

@end
