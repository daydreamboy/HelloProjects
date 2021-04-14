//
//  WCNotificationTool.m
//  HelloNSNotification
//
//  Created by wesley_chen on 2021/4/1.
//

#import "WCNotificationTool.h"
#import <objc/runtime.h>

#define DEBUG_WCNotificationObserverWrapper 1

/**
 The remover for auto removing the registered observer from NSNotificationCenter
 */
@interface WCNotificationObserverRemover : NSObject
@property (nonatomic, weak) id observer;
@property (nonatomic, strong) id blockObserver;
@property (nonatomic, copy) NSNotificationName notificationName;
@property (nonatomic, strong) id object;
@end

@implementation WCNotificationObserverRemover

+ (instancetype)removerWithObserver:(id)observer notificationName:(NSNotificationName)notificationName object:(id)object {
    WCNotificationObserverRemover *wrapper = [[WCNotificationObserverRemover alloc] init];
    wrapper.observer = observer;
    wrapper.notificationName = notificationName;
    wrapper.object = object;
    
    return wrapper;
}

- (void)dealloc {
#if DEBUG_WCNotificationObserverWrapper
    NSLog(@"%@: %@, %@", self, NSStringFromSelector(_cmd), self.notificationName);
#endif
    
    if (self.blockObserver) {
        // A block based notification center observer
        [[NSNotificationCenter defaultCenter] removeObserver:self.blockObserver];
    }
    else {
        id localObserver = self.observer;
        if (localObserver) {
            // A selector based notification center observer
            [[NSNotificationCenter defaultCenter] removeObserver:localObserver name:self.notificationName object:self.object];
        }
    }
}
@end

@interface WCNotificationObserverStorage : NSObject
@property (nonatomic, strong) NSMutableDictionary<NSNotificationName, NSMutableArray<WCNotificationObserverRemover *> *> *storage;
@end

@implementation WCNotificationObserverStorage
- (instancetype)init {
    self = [super init];
    if (self) {
        _storage = [NSMutableDictionary dictionary];
    }
    return self;
}

- (void)addRemover:(WCNotificationObserverRemover *)remover forNoticationName:(NSNotificationName)noticationName {
    if (noticationName && remover) {
        NSMutableArray *removers = _storage[noticationName];
        if (!removers) {
            removers = [NSMutableArray array];
        }
        [removers addObject:remover];
        
        _storage[noticationName] = removers;
    }
}

- (void)dealloc {
#if DEBUG_WCNotificationObserverWrapper
    NSLog(@"%@: %@", self, NSStringFromSelector(_cmd));
#endif
}

@end

@implementation WCNotificationTool

static const void *kAssociatedObjectKey_WCNotificationObserverStorage = &kAssociatedObjectKey_WCNotificationObserverStorage;

+ (BOOL)addObserver:(id)observer selector:(SEL)selector name:(nullable NSNotificationName)name object:(nullable id)object {
    if (!observer || selector == nil) {
        return NO;
    }
    
    WCNotificationObserverStorage *storage = nil;
    id associatedObject = objc_getAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverStorage);
    if ([associatedObject isKindOfClass:[WCNotificationObserverStorage class]]) {
        storage = (WCNotificationObserverStorage *)associatedObject;
    }
    else {
        storage = [[WCNotificationObserverStorage alloc] init];
        objc_setAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    WCNotificationObserverRemover *remover = [WCNotificationObserverRemover removerWithObserver:observer notificationName:name object:object];
    [storage addRemover:remover forNoticationName:name];
    
    [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
    
    return YES;
}

+ (BOOL)addObserver:(id)observer name:(nullable NSNotificationName)name object:(nullable id)object queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *notification))block {
    if (!observer) {
        return NO;
    }
    
    WCNotificationObserverStorage *storage = nil;
    id associatedObject = objc_getAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverStorage);
    if ([associatedObject isKindOfClass:[WCNotificationObserverStorage class]]) {
        storage = (WCNotificationObserverStorage *)associatedObject;
    }
    else {
        storage = [[WCNotificationObserverStorage alloc] init];
        objc_setAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverStorage, storage, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    WCNotificationObserverRemover *remover = [[WCNotificationObserverRemover alloc] init];
    id blockObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:queue usingBlock:block];
    remover.notificationName = name;
    remover.blockObserver = blockObserver;
    
    [storage addRemover:remover forNoticationName:name];
    
    return YES;
}

@end
