//
//  StaticLibrary.m
//  StaticLibrary
//
//  Created by wesley_chen on 2018/5/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "StaticLibrary.h"
#import "LazyLoadDynamicLibrary.h"

@implementation StaticLibrary
- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSomeNotification1:) name:@"SomeNotification1" object:nil];
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleSomeNotification2:) name:SomeNotification2 object:nil];
    }
    return self;
}

- (void)handleSomeNotification1:(NSNotification *)notification {
    NSLog(@"receive notification 1");
}

- (void)handleSomeNotification2:(NSNotification *)notification {
    NSLog(@"receive notification 2");
}

@end
