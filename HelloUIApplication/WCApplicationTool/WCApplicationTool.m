//
//  WCApplicationTool.m
//  HelloUIApplication
//
//  Created by wesley_chen on 2019/2/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCApplicationTool.h"

@implementation WCApplicationTool

// https://stackoverflow.com/a/45099545
+ (nullable UIWindow *)currentKeyboardWindow {
    NSArray *components = @[ @"UI", @"Remote", @"Keyboard", @"Window" ];
    Class clz = NSClassFromString([components componentsJoinedByString:@""]);
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass: %@", clz];
    NSArray<UIWindow *> *windows = [[[UIApplication sharedApplication] windows] filteredArrayUsingPredicate:predicate];
    if (windows.count == 1) {
        UIWindow *keyboardWindow = [windows firstObject];
        if (keyboardWindow) {
            return keyboardWindow;
        }
    }
    
    return nil;
}

@end
