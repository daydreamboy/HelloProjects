//
//  WCSingletonObject.m
//  WCSingletonObject
//
//  Created by wesley_chen on 2019/7/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCSingletonObject.h"

@implementation WCSingletonObject

static NSMutableDictionary *sSharedInstanceStore = nil;

// @see https://stackoverflow.com/a/25023814
static dispatch_queue_t get_sync_queue(void) {
    static dispatch_once_t onceToken;
    static dispatch_queue_t sSyncQueue;
    dispatch_once(&onceToken, ^{
        sSyncQueue = dispatch_queue_create("WCSingletonObject.sSyncQueue_c", DISPATCH_QUEUE_CONCURRENT);
    });
    return sSyncQueue;
}

+ (void)initialize {
    if (self == [WCSingletonObject class]) {
        sSharedInstanceStore = [NSMutableDictionary dictionary];
    }
}

+ (instancetype)sharedInstance {
    WCSingletonObject *sharedInstance = nil;
    
    @synchronized (self) {
        NSString *instanceClass = NSStringFromClass(self);
        
        // Looking for existing instance
        sharedInstance = sSharedInstanceStore[instanceClass];
        
        // If there's no instance – create one and add it to the dictionary
        if (sharedInstance == nil) {
            sharedInstance = [[super allocWithZone:nil] init];
            sharedInstance.shared = YES;
            sSharedInstanceStore[instanceClass] = sharedInstance;
        }
    }
    
    return sharedInstance;
}

+ (void)destroySharedInstance {
    @synchronized (self) {
        [sSharedInstanceStore removeObjectForKey:NSStringFromClass(self)];
    }
}

#pragma mark - For WCSingletonObject

+ (BOOL)checkShareInstanceExistsWithClassName:(NSString *)className {
    if (![className isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    WCSingletonObject *sharedInstance = nil;
    
    @synchronized (self) {
        sharedInstance = sSharedInstanceStore[className];
    }
    
    return sharedInstance == nil ? NO : YES;
}

@end
