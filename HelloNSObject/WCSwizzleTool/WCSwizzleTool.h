//
//  WCSwizzleTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 Use WC_SWIZZLE_CLASS_BEGIN/WC_SWIZZLE_CLASS_END to declare a class at any where for
 swizzling by category method
 
 @param clz the class to swizzle
 @code
 WC_SWIZZLE_CLASS_BEGIN(UIView)
 - (void)my_setFrame:(CGRect)frame {
     // do something
     [self my_setFrame:frame];
 }
 WC_SWIZZLE_CLASS_END
 @endcode
 
 @discussion the clz is derived from NSObject
 */
#define WC_SWIZZLE_CLASS_BEGIN(clz) \
@interface clz : NSObject \
@end \
@implementation clz (Swizzle)

#define WC_SWIZZLE_CLASS_END \
@end

/// Type: The pointer to IMP
typedef IMP _Nonnull *WCIMPPtr;

@interface WCSwizzleTool : NSObject

#pragma mark - Swizzle with block

/**
 Exchange the IMP between the existing selector  and the block

 @param cls the Class to modify
 @param originalSelector the original selector whose IMP should exist
 @param swizzledSelector the swizzled selector whose IMP exists or not
 @param block the swizzled block which must match the signature of the `originalSelector`
 
 @return YES if the operate successfull. NO if any error occurred internally.
 
 @discussion This method will create new selector (`swizzledSelector`) and its IMP if the IMP not exists. And
 replace the swizzled selector's IMP if the swizzled selector already has the previous one.
 */
+ (BOOL)exchangeIMPWithClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL _Nullable)swizzledSelector swizzledBlock:(id)block;

/**
 Replace the IMP of the original selector with block or add the new IMP to the original selector with block

 @param cls the Class to modify
 @param originalSelector the original selector whose IMP exists or not exists
 @param block the swizzled block which mapping to the `originalSelector` and must match the signature of the `originalSelector`
 @param originalIMPPtr the original IMP. If the `originalSelector` not exists, the IMP is the swizzled block.
 If the `originalSelector` exists, the IMP is the old IMP.
 
 @return YES if the operate successfull. NO if any error occurred internally.
 */
+ (BOOL)replaceIMPWithClass:(Class)cls originalSelector:(SEL)originalSelector swizzledBlock:(id)block originalIMPPtr:(inout WCIMPPtr _Nullable)originalIMPPtr;

#pragma mark - Swizzle with selector

/**
 Exchange the IMP for two existing selectors
 
 @param cls the Class to modify
 @param originalSelector the original selector which should exist
 @param swizzledSelector the swizzled selector which should also exist, e.g. a category method
 @param forClassMethod If YES, the `originalSelector` and `swizzledSelector` are both class method, or NO if
 the `originalSelector` and `swizzledSelector` are both instance method
 
 @return YES if the operate successfull. NO if any error occurred internally.
 
 @discussion This method usually used for swizzling by category method
 */
+ (BOOL)exchangeIMPWithClass:(Class)cls originalSelector:(SEL)originalSelector swizzledSelector:(SEL)swizzledSelector forClassMethod:(BOOL)forClassMethod;

#pragma mark - Swizzle with C function

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
+ (SEL)swizzledSelectorWithSelector:(SEL _Nullable)selector;

@end

NS_ASSUME_NONNULL_END
