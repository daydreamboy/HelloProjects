//
//  WCDynamicFontManager.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCDynamicFontManager.h"

#define kWCThemeFontProviderName @"WCThemeFont"

@interface WCDynamicFontManager ()
@property (nonatomic, strong) NSMutableDictionary<NSString *, id<WCDynamicFontProvider>> *fontProviders;
@property (nonatomic, strong, readwrite, nullable) id<WCDynamicFontProvider> currentFontProvider;
@end

@implementation WCDynamicFontManager

+ (instancetype)sharedManager {
    static dispatch_once_t onceToken;
    static WCDynamicFontManager *sInstance;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCDynamicFontManager alloc] init];
    });
    
    return sInstance;
}

#pragma mark > Register Font Provider

- (BOOL)registerDynamicFontProvider:(id<WCDynamicFontProvider>)dynamicFontProvider forName:(NSString *)name {
    if (![dynamicFontProvider respondsToSelector:@selector(fontWithProviderName:forKey:)]) {
        return NO;
    }
    
    if (![name isKindOfClass:[NSString class]] || ([name isKindOfClass:[NSString class]] && name.length == 0)) {
        return NO;
    }
    
    if (self.fontProviders[name]) {
        return NO;
    }
    
    self.fontProviders[name] = dynamicFontProvider;
    
    NSString *currentFontProviderName = [[NSUserDefaults standardUserDefaults] stringForKey:kWCThemeFontProviderName];
    if ([currentFontProviderName isEqualToString:name]) {
        _currentFontProvider = dynamicFontProvider;
        _currentFontProviderName = currentFontProviderName;
    }
    
    return YES;
}

- (BOOL)unregisterDynamicFontProvider:(id<WCDynamicFontProvider>)dynamicFontProvider {
    if (!dynamicFontProvider) {
        return NO;
    }
    
    __block NSString *keyToRemove = nil;
    [self.fontProviders enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id<WCDynamicFontProvider>  _Nonnull obj, BOOL * _Nonnull stop) {
        if (obj == dynamicFontProvider) {
            keyToRemove = key;
            *stop = YES;
        }
    }];
    
    if (keyToRemove) {
        [self.fontProviders removeObjectForKey:keyToRemove];
        return YES;
    }
    
    return NO;
}

- (BOOL)unregisterDynamicFontProviderForName:(NSString *)name {
    if (![name isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (self.fontProviders[name]) {
        [self.fontProviders removeObjectForKey:name];
        return YES;
    }
    
    return NO;
}

- (NSArray<NSString *> *)fontProviderNames {
    return [[self.fontProviders allKeys] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark > Change Font Provider

- (BOOL)setCurrentFontProviderName:(NSString *)currentFontProviderName {
    if (![currentFontProviderName isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if ([currentFontProviderName isKindOfClass:[NSString class]] && currentFontProviderName.length == 0) {
        return NO;
    }
    
    if (![[self.fontProviders allKeys] containsObject:currentFontProviderName]) {
        return NO;
    }
    
    NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
    
    userInfoM[WCDynamicFontChangeNotificationUserInfoProviderName] = currentFontProviderName;
    userInfoM[WCDynamicFontChangeNotificationUserInfoProvider] = self.fontProviders[currentFontProviderName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCDynamicFontWillChangeNotification object:nil userInfo:userInfoM];
    
    _currentFontProviderName = currentFontProviderName;
    _currentFontProvider = self.fontProviders[currentFontProviderName];
    
    [[NSUserDefaults standardUserDefaults] setObject:_currentFontProviderName forKey:kWCThemeFontProviderName];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:WCDynamicFontDidChangeNotification object:nil userInfo:userInfoM];
    
    return YES;
}

#pragma mark > Set Font

- (BOOL)setDynamicFontWithDefaultFont:(UIFont *)defaultFont forKey:(NSString *)key attachToObject:(id)object fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock {
    
    // TODO: add more object type
    if ([object isKindOfClass:[UILabel class]]) {
        UILabel *label = (UILabel *)object;
        UIFont *font = [self.currentFontProvider fontWithProviderName:self.currentFontProviderName forKey:key];
        label.font = font ?: defaultFont;
        
        [WCDynamicFont setDynamicFontWithHost:object defaultFont:defaultFont forKey:key fontDidChangeBlock:fontDidChangeBlock forceReplace:NO];
        
        return YES;
    }
    
    return NO;
}

- (UIFont *)dynamicFontWithDefaultFont:(UIFont *)defaultFont forKey:(NSString *)key attachToObject:(nullable id)object fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock {
    UIFont *font = [self.currentFontProvider fontWithProviderName:self.currentFontProviderName forKey:key];
    
    if (object) {
        [WCDynamicFont setDynamicFontWithHost:object defaultFont:defaultFont forKey:key fontDidChangeBlock:fontDidChangeBlock forceReplace:NO];
    }
    
    return font ?: defaultFont;
}

#pragma mark -

- (instancetype)init {
    self = [super init];
    if (self) {
        _fontProviders = [NSMutableDictionary dictionary];
    }
    return self;
}

@end
