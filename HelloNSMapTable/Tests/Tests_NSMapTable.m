//
//  Tests_NSMapTable.m
//  Tests
//
//  Created by wesley_chen on 2019/5/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSMapTable : XCTestCase

@end

@implementation Tests_NSMapTable

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_fast_enumeration {
    NSMapTable<NSString *, NSString *> *mapTable = [NSMapTable strongToStrongObjectsMapTable];
    
    for (NSInteger i = 0; i < 10; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", (int)i];
        NSString *value = [NSString stringWithFormat:@"object%d", (int)i];
        //mapTable[key] = value;
        [mapTable setObject:value forKey:key];
    }
    
    // @see https://stackoverflow.com/a/45098216
    for (NSString *key in [mapTable keyEnumerator]) {
        NSLog(@"%@", key);
    }
    
    for (NSString *value in [mapTable objectEnumerator]) {
        NSLog(@"%@", value);
    }
}

- (void)test_weak_keys {
    NSMapTable<NSString *, NSString *> *mapTable = [NSMapTable weakToStrongObjectsMapTable];
    
    @autoreleasepool {
        NSMutableArray *keys = [NSMutableArray array];
        for (NSInteger i = 0; i < 10; i++) {
            NSString *key = [NSString stringWithFormat:@"%d", (int)i];
            [keys addObject:key];
            
            NSString *value = [NSString stringWithFormat:@"object%d", (int)i];
            [mapTable setObject:value forKey:key];
        }
        
        // Note: release all the keys
        [keys removeAllObjects];
    }
    
    for (NSString *key in [mapTable keyEnumerator]) {
        NSLog(@"%@", key);
    }
}

- (void)test_weak_values {
    NSMapTable<NSString *, NSObject *> *mapTable = [NSMapTable strongToWeakObjectsMapTable];
    
    NSMutableArray *values = [NSMutableArray array];
    for (NSInteger i = 0; i < 10; i++) {
        NSString *key = [NSString stringWithFormat:@"%d", (int)i];
        
        NSObject *value = [NSObject new];
        [values addObject:value];
        NSLog(@"%i: %p", (int)i, value);
        
//        [mapTable setObject:value forKey:key];
    }
    
    // Note: release all the keys
    [values removeAllObjects];
    values = nil;
    
    for (NSString *value in [mapTable objectEnumerator]) {
        NSLog(@"%@", value);
    }
}

@end
