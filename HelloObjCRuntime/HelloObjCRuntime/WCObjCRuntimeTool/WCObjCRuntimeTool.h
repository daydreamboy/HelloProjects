//
//  WCObjCRuntimeTool.h
//  HelloObjCRuntime
//
//  Created by wesley_chen on 2019/7/18.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 The pair structure of the selector and block
 
 @discussion the block use id (^)(id, ...) as signature without _cmd,
 because the selector of the method is not available to block from document of
 the imp_implementationWithBlock
 */
typedef struct selBlockPair {
    SEL sel;
    id (^__unsafe_unretained block)(id, ...);
} selBlockPair;

#define selBlockPair_nil    ((struct selBlockPair) { 0, 0 })
#define selBlockPair_list   (struct selBlockPair [])
#define selBlockPair_block   (id (^)(id, ...))

@interface WCObjCRuntimeTool : NSObject

#pragma mark - Create Class

/**
 Create a subclass in the runtime 
 
 @param className the subclass name, if nil use a random class name instead
 @param baseClassName the base class, if nil use NSObject instead
 @param protocolNames the protocol name array.
 @param selBlockPairs the pair of the selector and block.
 @return the Class if create successfully
 @discussion The pair list's format, for example as following
    selBlockPair_list {
        @selector(description),
        selBlockPair_block ^id (id sender) {
            return @"This is a MyCustomString string";
        },
        NSSelectorFromString(@"hello:"),
        selBlockPair_block ^id (id sender, NSString *name) {
            NSLog(@"hello %@!", name);
            return nil;
        },
        selBlockPair_nil
    }
 1. The first value is the SEL
 2. The second value is the block with signature `id (^)(id, ...)`
    - return nil if no return value
    - the first paramter is always the sender object
    - no self/_cmd parameter in the block
 3. Use selBlockPair_block to cast the block
 4. Use selBlockPair_nil as pair list terminator
 5. Use selBlockPair_list to cast the pair list
 */
+ (nullable Class)createSubclassWithClassName:(nullable NSString *)className baseClassName:(nullable NSString *)baseClassName protocolNames:(NSArray<NSString *> * _Nullable)protocolNames selBlockPairs:(selBlockPair * _Nullable)selBlockPairs;

@end

NS_ASSUME_NONNULL_END
