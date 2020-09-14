//
//  DGUIThemeManager.h
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**currentThemeIdentifier发生变化的通知, 该通知在执行UI切换渲染之前发出*/
UIKIT_EXTERN NSNotificationName const DGUIThemeDidChangeNotification;

/**currentThemeIdentifier 在本地UserDefault存储的key值*/
UIKIT_EXTERN NSNotificationName const DGUIThemeCurrentIdentifierLocalKey;
@protocol WCColorProvider;
@interface DGUIThemeManager : NSObject

/**当前UI主题标识*/
@property (nonatomic,   copy) NSString *currentThemeIdentifier;
/**主题提供者*/
@property (nonatomic, strong) NSObject <WCColorProvider> *themeProvider;
- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;
+ (instancetype)sharedManager;
- (UIColor *)themeColorForKey:(NSString *)key;
- (UIColor *)themeColorForKey:(NSString *)key defaultHexValue:(NSString * _Nullable)defaultHexValue;

@end

NS_ASSUME_NONNULL_END
