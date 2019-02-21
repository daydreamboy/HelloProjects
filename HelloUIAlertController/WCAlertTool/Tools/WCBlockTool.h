//
//  WCBlockTool.h
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/2/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCBlockTool : NSObject

@end

@interface WCBlockTool ()
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

NS_ASSUME_NONNULL_END
