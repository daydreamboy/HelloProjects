//
//  UIView+DGUITheme.h
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//


#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCColorProvider;
@interface UIView (DGUITheme)

@property (nonatomic, copy) NSString *dguiTheme_identifier;
- (void)dgui_themeDidChangeByProvider:(NSObject<WCColorProvider> *)provider identifier:(__kindof NSString *)identifier  NS_REQUIRES_SUPER;

@end

NS_ASSUME_NONNULL_END
