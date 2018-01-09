//
//  WCThreadTool.h
//  HelloThread
//
//  Created by wesley_chen on 12/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCThreadTool : NSObject

+ (void)performBlock:(dispatch_block_t)block onThread:(NSThread *)thread;
+ (void)performBlock:(void (^)(id))block onThread:(NSThread *)thread withObject:(id)object;
@end
