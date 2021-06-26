//
//  Test_WCHeapTool.m
//  Test
//
//  Created by wesley_chen on 2021/6/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCHeapTool.h"
#import "WCPointerTool.h"
#import "FLEXHeapEnumerator.h"

@interface Test_WCHeapTool : XCTestCase

@end

@implementation Test_WCHeapTool

- (void)test_enumerateLiveObjectsUsingBlock {
    [WCHeapTool enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id  _Nonnull object, __unsafe_unretained Class  _Nonnull actualClass) {
        NSLog(@"%@: %p", NSStringFromClass(actualClass), object);
    }];
    
//    [FLEXHeapEnumerator enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
//        NSLog(@"%@: %@", NSStringFromClass(actualClass), object);
//    }];
}

- (void)test_allLiveObjectsWithContainerCountForClass_containerSizesForClass {
    NSMutableDictionary *container1 = [NSMutableDictionary dictionary];
    NSMutableDictionary *container2 = [NSMutableDictionary dictionary];
    [WCHeapTool allLiveObjectsWithContainerCountForClass:&container1 containerSizesForClass:&container2];
    [container1 enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
//        if (WCPointerIsValidObjcObject((__bridge const void *)(obj))) {
//            NSLog(@"%@", obj);
//        }
    }];
}

@end
