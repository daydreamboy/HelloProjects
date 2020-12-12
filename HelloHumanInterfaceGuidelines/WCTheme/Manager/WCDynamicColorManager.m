//
//  WCDynamicColorManager.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/15.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicColorManager.h"
#import "WCDynamicInternalColor.h"
#import "WCDynamicInternalColor_Internal.h"
#import <objc/runtime.h>

#define kWCThemeColorProviderName @"WCThemeColor"

@interface WCDynamicColorManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<WCDynamicColorProvider>> *colorProviders;
@property (nonatomic, strong, readwrite, nullable) id<WCDynamicColorProvider> currentColorProvider;
@end

@implementation WCDynamicColorManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WCDynamicColorManager *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCDynamicColorManager alloc] init];
    });
    
    return sInstance;
}

#pragma mark - Color

- (NSArray<NSString *> *)colorProviderNames {
    return [[self.colorProviders allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark > Change Color Provider

- (BOOL)setCurrentColorProviderName:(NSString *)currentProviderName {
    if (![currentProviderName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([currentProviderName isKindOfClass:[NSString class]] && currentProviderName.length == 0) {
        return NO;
    }
    
    if (![[self.colorProviders allKeys] containsObject:currentProviderName]) {
        return NO;
    }
    
    _currentColorProviderName = currentProviderName;
    _currentColorProvider = self.colorProviders[currentProviderName];
    
    NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
    userInfoM[WCDynamicColorChangeNotificationUserInfoProvider] = _currentColorProvider;
    userInfoM[WCDynamicColorChangeNotificationUserInfoProviderName] = _currentColorProviderName;
    
    [[NSUserDefaults standardUserDefaults] setObject:_currentColorProviderName forKey:kWCThemeColorProviderName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCDynamicColorDidChangeNotification object:nil userInfo:userInfoM];
    
    return YES;
}

#pragma mark > Register Font Provider

#pragma mark > Register Font Provider

- (BOOL)registerDynamicColorProvider:(id<WCDynamicColorProvider>)dynamicColorProvider forName:(NSString *)name {
    if (![dynamicColorProvider respondsToSelector:@selector(colorWithProviderName:forKey:)]) {
        return NO;
    }
    
    if (![name isKindOfClass:[NSString class]] || ([name isKindOfClass:[NSString class]] && name.length == 0)) {
        return NO;
    }
    
    if (self.colorProviders[name]) {
        return NO;
    }
    
    self.colorProviders[name] = dynamicColorProvider;
    
    if ([_currentColorProviderName isEqualToString:name]) {
        _currentColorProvider = dynamicColorProvider;
    }
    
    return YES;
}

- (BOOL)unregisterDynamicColorProvider:(id<WCDynamicColorProvider>)dynamicFontProvider {
    if (!dynamicFontProvider) {
        return NO;
    }
    
    __block NSString *keyToRemove = nil;
    [self.colorProviders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<WCDynamicColorProvider>  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == dynamicFontProvider) {
            keyToRemove = key;
            *stop = YES;
        }
    }];
    
    if (keyToRemove) {
        [self.colorProviders removeObjectForKey:keyToRemove];
        return YES;
    }
    
    return NO;
}

- (BOOL)unregisterDynamicColorProviderForName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (self.colorProviders[name]) {
        [self.colorProviders removeObjectForKey:name];
        return YES;
    }
    
    return NO;
}

#pragma mark - Create Color

+ (UIColor *)dynamicColorWithDefaultColor:(UIColor *)defaultColor forKey:(NSString *)key attachToObject:(nullable id)object colorWillChangeBlock:(nullable WCColorWillChangeBlockType)colorWillChangeBlock {
    
    if (object) {
        [WCDynamicColor setDynamicColorWithHost:object defaultColor:defaultColor forKey:key colorWillChangeBlock:colorWillChangeBlock forceReplace:NO];
    }
    
    return [[WCDynamicInternalColor alloc] initWithDefaultColor:defaultColor key:key];
}

#pragma mark - Color Change Observer

static void * const kAssociatedKeyColorDidChangeObserver = (void *)&kAssociatedKeyColorDidChangeObserver;

+ (BOOL)addColorDidChangeObserver:(id)observer callback:(nullable void (^)(id<WCDynamicColorProvider> colorProvider, NSString *colorProviderName))callback {
    if (!observer) {
        return NO;
    }
    
    id<NSObject> actualObserver = objc_getAssociatedObject(observer, kAssociatedKeyColorDidChangeObserver);
    if (actualObserver) {
        return NO;
    }
    
    __weak typeof(observer) weak_observer = observer;
    actualObserver = [[NSNotificationCenter defaultCenter] addObserverForName:WCDynamicColorDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification * _Nonnull note) {
        __strong typeof(observer) strong_observer = weak_observer;
        if ([strong_observer isKindOfClass:[UIView class]]) {
            [strong_observer setNeedsDisplay];
        }
        
        NSDictionary *userInfo = note.userInfo;
        id<WCDynamicColorProvider> currentColorProvider = userInfo[WCDynamicColorChangeNotificationUserInfoProvider];
        NSString *currentColorProviderName = userInfo[WCDynamicColorChangeNotificationUserInfoProviderName];
                                                      
        !callback ?: callback(currentColorProvider, currentColorProviderName);
    }];
    
    objc_setAssociatedObject(observer, kAssociatedKeyColorDidChangeObserver, actualObserver, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    return YES;
}

+ (BOOL)removeColorDidChangeObserver:(id)observer {
    if (!observer) {
        return NO;
    }
    
    id<NSObject> actualObserver = objc_getAssociatedObject(observer, kAssociatedKeyColorDidChangeObserver);
    if (!actualObserver) {
        return NO;
    }
    
    @try {
        [[NSNotificationCenter defaultCenter] removeObserver:actualObserver];
        objc_setAssociatedObject(observer, kAssociatedKeyColorDidChangeObserver, nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    @catch (NSException *exception) {}
    
    return YES;
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _colorProviders = [NSMutableDictionary dictionary];
        _currentColorProviderName = [[NSUserDefaults standardUserDefaults] stringForKey:kWCThemeColorProviderName];
    }
    return self;
}

@end
