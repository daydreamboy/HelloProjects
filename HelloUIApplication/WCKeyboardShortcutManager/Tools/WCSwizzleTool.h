//
//  WCSwizzleTool.h
//  HelloUIApplication
//
//  Created by wesley_chen on 2021/2/27.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/// Type: The pointer to IMP
typedef IMP _Nonnull *WCIMPPtr;

@interface WCSwizzleTool : NSObject

@end

@interface WCSwizzleTool ()

+ (BOOL)exchangeIMPWithClass:(Class)class originalSelector:(SEL)originalSelector swizzledSelector:(SEL _Nullable)swizzledSelector swizzledBlock:(id)block;
+ (SEL)swizzledSelectorWithSelector:(SEL _Nullable)selector;

@end

NS_ASSUME_NONNULL_END
