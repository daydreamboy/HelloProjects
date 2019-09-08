//
//  UncatchExceptionGuard.h
//  HelloObjCRuntime
//
//  Created by wesley_chen on 09/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UncatchExceptionGuard : NSObject

+ (BOOL)tryCallBlockIfNeeded:(dispatch_block_t)block forKey:(NSString *)key;

@end
