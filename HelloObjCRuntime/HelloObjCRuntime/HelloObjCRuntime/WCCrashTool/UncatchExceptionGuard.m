//
//  UncatchExceptionGuard.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 09/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "UncatchExceptionGuard.h"

@implementation UncatchExceptionGuard

+ (BOOL)tryCallBlockIfNeeded:(dispatch_block_t)block forKey:(NSString *)key {
    
    BOOL isBlockCalled = NO;
    
    if ([key isKindOfClass:[NSString class]] && block) {
        NSString *appVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"];
        NSString *keyForDict = [NSString stringWithFormat:@"%@_%@", NSStringFromClass(self), appVersion];
        
        NSDictionary *dict = [[NSUserDefaults standardUserDefaults] objectForKey:keyForDict];
        
        if (dict == nil || [dict isKindOfClass:[NSDictionary class]]) {
            
            // Note: only two cases to call block
            // case 1: the key has not stored in local (This is the first time to call block)
            // case 2: the key's value is @"true" (The block was called safely once)
            if ((dict[key] == nil) || ([dict[key] isKindOfClass:[NSString class]] && [dict[key] isEqualToString:@"true"])) {
                NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:dict.count];
                [dictM addEntriesFromDictionary:dict];
                
                dictM[key] = @"false";
                
                [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:keyForDict];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                // Note: if block will crash, @"false" is stored, so next time try to call the unsafe block will skip
                block();
                
                dictM[key] = @"true";
                
                [[NSUserDefaults standardUserDefaults] setObject:dictM forKey:keyForDict];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                isBlockCalled = YES;
            }
            else {
                if (([dict[key] isKindOfClass:[NSString class]] && [dict[key] isEqualToString:@"false"])) {
                    // TODO: maybe need to log file to upload
                    NSLog(@"[%@][Warning] block %@ has crashed once. Now skip it.", NSStringFromClass(self), block);
                }
            }
        }
    }
    
    if (!isBlockCalled && block) {
        // Note: log for developer
        NSLog(@"[%@][Warning] ignore to call block %@ for key `%@`", NSStringFromClass(self), block, key);
    }
    
    return isBlockCalled;
}

@end
