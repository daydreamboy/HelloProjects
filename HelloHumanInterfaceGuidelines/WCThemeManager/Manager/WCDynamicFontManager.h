//
//  WCDynamicFontManager.h
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCDynamicFont.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCDynamicFontManager : NSObject

@property (nonatomic, strong, readonly) NSArray<NSString *> *fontProviderNames;
@property (nonatomic, copy, readonly, nullable) NSString *currentFontProviderName;
@property (nonatomic, strong, readonly, nullable) id<WCDynamicFontProvider> currentFontProvider;

+ (instancetype)sharedManager;

#pragma mark - Font

#pragma mark > Change Font Provider

- (BOOL)setCurrentFontProviderName:(NSString *)currentProviderName;

#pragma mark > Register Font Provider

- (BOOL)registerDynamicFontProvider:(id<WCDynamicFontProvider>)dynamicFontProvider forName:(NSString *)name;
- (BOOL)unregisterDynamicFontProvider:(id<WCDynamicFontProvider>)dynamicFontProvider;
- (BOOL)unregisterDynamicFontProviderForName:(NSString *)name;

#pragma mark > Set Font

- (BOOL)setDynamicFontWithObject:(id)object defaultFont:(UIFont *)defaultFont forKey:(NSString *)key fontDidChangeBlock:(nullable WCFontDidChangeBlockType)fontDidChangeBlock;

@end

#pragma mark - Utility Macros

/**
 Use this macro to register the key and default font
 
 @param label the UILabel object
 @param key the key for the keyed font
 @param defaultFont_ the default font if the provider not find the keyed font
 @param block the callback when its font did change. The block type see WCFontDidChangeBlockType
 
 @return YES if set successfully, NO if not
 
 @discussion This method will initialize the label's font
 */
#define WCSetDynamicFont(label, key, defaultFont_, block) \
[[WCDynamicFontManager sharedManager] setDynamicFontWithObject:(label) defaultFont:defaultFont_ forKey:key fontDidChangeBlock:(block)];


NS_ASSUME_NONNULL_END
