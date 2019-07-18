//
//  WCObjCRuntimeTool.h
//  HelloObjCRuntime
//
//  Created by wesley_chen on 2019/7/18.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef struct selBlockPair {
    SEL sel;
    id (^__unsafe_unretained block)(id, ...);
} selBlockPair;

#define selBlockPair_nil    ((struct selBlockPair) { 0, 0 })
#define selBlockPair_list   (struct selBlockPair [])
#define selBlockPair_cast   (id (^)(id, ...))

@interface WCObjCRuntimeTool : NSObject

#pragma mark - Create Class

/**
 Create a subclass in the runtime
 
 @param className the subclass name, if nil use a random class name instead
 @param baseClassName the base class, if nil use NSObject instead
 @param protocolNames the protocol name array.
 @param selBlockPairs the pair of the selector and block, and ends with selBlockPair_nil macro
 @return the Class if create successfully
 */
+ (nullable Class)createSubclassWithClassName:(nullable NSString *)className baseClassName:(nullable NSString *)baseClassName protocolNames:(NSArray<NSString *> * _Nullable)protocolNames selBlockPairs:(selBlockPair * _Nullable)selBlockPairs;

@end

NS_ASSUME_NONNULL_END
