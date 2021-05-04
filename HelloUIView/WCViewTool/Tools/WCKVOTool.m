//
//  WCKVOTool.m
//  HelloUIView
//
//  Created by wesley_chen on 2020/4/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCKVOTool.h"
#import <objc/runtime.h>

@interface WCKVOObserver ()
@property (nonatomic, weak, readwrite) id observedObject;
@property (nonatomic, copy, readwrite) WCKVOObserverEventCallback eventCallback;
@property (nonatomic, copy, readwrite) NSString *keyPath;
@property (nonatomic, assign, readwrite) NSKeyValueObservingOptions options;
@end

@implementation WCKVOObserver

- (instancetype)initWithObservedObject:(id)observedObject keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options eventCallback:(WCKVOObserverEventCallback)eventCallback  {
    self = [super init];
    if (self) {
        _observedObject = observedObject;
        _keyPath = keyPath;
        _options = options;
        _eventCallback = eventCallback;
        
        [_observedObject addObserver:self forKeyPath:keyPath options:options context:nil];
    }
    return self;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context {
    if (_observedObject == object && [keyPath isEqualToString:_keyPath]) {
        !_eventCallback ?: _eventCallback(_observedObject, self, change, context);
    }
}

- (void)dealloc {
    @try {
        [_observedObject removeObserver:self forKeyPath:_keyPath];
    }
    @catch (NSException *exception) {
#if DEBUG
        NSLog(@"an exception occurred: %@", exception);
#endif
    }
}

@end

@implementation WCKVOTool

#pragma mark - Auto KVO

+ (BOOL)observeKVOEventWithObject:(NSObject *)object keyPath:(NSString *)keyPath options:(NSKeyValueObservingOptions)options associatedKey:(const void *)associatedKey eventCallback:(WCKVOObserverEventCallback)eventCallback {
    if (![object isKindOfClass:[NSObject class]] || eventCallback == nil) {
        return NO;
    }
    
    id associatedObject = objc_getAssociatedObject(object, associatedKey);
    if (associatedObject) {
        return NO;
    }
    
    WCKVOObserver *observer = [[WCKVOObserver alloc] initWithObservedObject:object keyPath:keyPath options:options eventCallback:eventCallback];
    objc_setAssociatedObject(object, associatedKey, observer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

@end
