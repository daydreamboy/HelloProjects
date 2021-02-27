//
//  WCSwizzleTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef IMP _Nonnull *WCIMPPtr;

@interface WCSwizzleTool : NSObject

#pragma mark - Runtime Modify

#pragma mark > Swizzle Method

/**
 Exchange the IMP of the existing selector to another IMP of the selector

 @param cls the Class to modify
 @param originalSelector the original selector whose IMP should exist
 @param swizzledSelector the swizzled selector whose IMP exists or not
 @param block the swizzled block which must match the signature of the `originalSelector`
 @return YES if the operate successfull. NO if any error occurred internally.
 @discussion This method will create new selector (`swizzledSelector`) and its IMP if the IMP not exists. And
 replace the swizzled selector's IMP if the swizzled selector already has the previous one.
 */
+ (BOOL)exchangeIMPWithClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector swizzledBlock:(id)block;

/**
 Replace or add the IMP of the original selector with block

 @param cls the Class to modify
 @param originalSelector the original selector whose IMP exists or not exists
 @param block the swizzled block which mapping to the `originalSelector` and must match the signature of the `originalSelector`
 @param originalIMPPtr the original IMP. If the `originalSelector` not exists, the IMP is the swizzled block.
 If the `originalSelector` exists, the IMP is the old IMP.
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)replaceIMPWithClass:(Class)cls originalSelector:(SEL)originalSelector swizzledBlock:(id)block originalIMPPtr:(inout WCIMPPtr _Nullable)originalIMPPtr;

/**
 Exchange the IMP for two existing selectors

 @param cls the Class to modify
 @param selector1 the selector1
 @param selector2 the selector2
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)exchangeIMPWithClass:(Class)cls selector1:(SEL)selector1 selector2:(SEL)selector2;

/**
 Exchange the IMP directly

 @param cls the Class to modify
 @param swizzledIMP the swizzled C function
 @param originalSelector the original selector which should exist
 @param originalIMPPtr the original C function
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)exchangeIMPWithClass:(Class)cls swizzledIMP:(IMP)swizzledIMP originalSelector:(SEL)originalSelector originalIMPPtr:(inout WCIMPPtr _Nullable)originalIMPPtr;

#pragma mark > Swizzle Assistant Method

/**
 Return a random selector name for given selector
 
 @param selector the original selector
 @return the modified selector which created with prefix
 */
+ (SEL)swizzledSelectorWithSelector:(SEL)selector;

@end

NS_ASSUME_NONNULL_END
