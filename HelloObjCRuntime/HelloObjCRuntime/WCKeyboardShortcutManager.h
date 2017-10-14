//
//  WCKeyboardShortcutManager.h
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/1/10.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

// only work for simulator
#if TARGET_OS_SIMULATOR

NS_CLASS_AVAILABLE_IOS(7_0)
@interface WCKeyboardShortcutManager : NSObject

@property (nonatomic, assign, getter=isEnabled) BOOL enabled;

// handle ESC key by default to resign first responder
+ (instancetype)defaultManager;

- (void)registerSimulatorShortcutWithKey:(NSString *)key modifiers:(UIKeyModifierFlags)modifiers action:(dispatch_block_t)action description:(NSString *)description;
- (NSString *)keyboardShortcutsDescription;

@end

#endif
