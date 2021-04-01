//
//  WCNotificationTool.m
//  HelloNSNotification
//
//  Created by wesley_chen on 2021/4/1.
//

#import "WCNotificationTool.h"
#import <objc/runtime.h>

@interface WCNotificationObserverWrapper : NSObject
@property (nonatomic, weak) id observer;
@property (nonatomic, strong) id blockObserver;
@property (nonatomic, copy) NSString *notificationName;
@property (nonatomic, strong) id object;
@end

@implementation WCNotificationObserverWrapper
- (void)dealloc {
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

@implementation WCNotificationTool

static const void *kAssociatedObjectKey_WCNotificationObserverWrapper = &kAssociatedObjectKey_WCNotificationObserverWrapper;

+ (BOOL)addObserver:(id)observer selector:(SEL)selector name:(nullable NSNotificationName)name object:(nullable id)object {
    if (!observer || selector == nil) {
        return NO;
    }
    
    id associatedObject = objc_getAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverWrapper);
    if (!associatedObject) {
        WCNotificationObserverWrapper *wrapper = [[WCNotificationObserverWrapper alloc] init];
        wrapper.observer = observer;
        wrapper.notificationName = name;
        wrapper.object = object;
        
        objc_setAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverWrapper, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        
        [[NSNotificationCenter defaultCenter] addObserver:observer selector:selector name:name object:object];
        
        return YES;
    }
    else {
        return NO;
    }
}

+ (BOOL)addObserver:(id)observer name:(nullable NSNotificationName)name object:(nullable id)object queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *notification))block {
    if (!observer) {
        return NO;
    }
    
    id associatedObject = objc_getAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverWrapper);
    if (!associatedObject) {
        WCNotificationObserverWrapper *wrapper = [[WCNotificationObserverWrapper alloc] init];
        id blockObserver = [[NSNotificationCenter defaultCenter] addObserverForName:name object:object queue:queue usingBlock:block];
        
        objc_setAssociatedObject(observer, kAssociatedObjectKey_WCNotificationObserverWrapper, wrapper, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
            
        wrapper.blockObserver = blockObserver;
        
        return YES;
    }
    else {
        return NO;
    }
}

@end
