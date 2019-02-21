//
//  WCBlockTool.h
//  HelloBlocks
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCBlockTool : NSObject

/**
 Check an object if a block

 @param object the object to check
 @return YES if the object is a block
 @see https://gist.github.com/steipete/6ee378bd7d87f276f6e0
 @discussion Don't convert object to block, before use this method to check
 @code
 
    // A wrong example,
    id object = [NSNull null];
    void (^block)(void) = object;
    [WCBlockTool isBlock:block]; // Crash caused by _Block_copy
 
    // A good example
    id object = [NSNull null];
    if ([WCBlockTool isBlock:object]) { // OK
        void (^block)(void) = object;
        if (block) {
            block();
        }
    }
 
 @endcode
 */
+ (BOOL)isBlock:(id _Nullable)object;
@end

@interface WCBlockDescriptor : NSObject

@property (nonatomic, strong, readonly) NSMethodSignature *_Nullable blockSignature;
/**
 The sinagure types: @[ return_type, block_self_type, arg1_type, arg2_type, ... ]
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *_Nullable blockSignatureTypes;
@property (nonatomic, strong, readonly) id _Nullable block;

- (instancetype _Nullable)initWithBlock:(id _Nullable)block;
- (BOOL)isEqualToSigature:(NSMethodSignature *_Nullable)methodSignature;
- (BOOL)isEqual:(WCBlockDescriptor *_Nullable)object;

@end
