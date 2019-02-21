//
//  WCAlertTool.m
//  HelloUIAlertController
//
//  Created by wesley_chen on 2019/1/16.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCAlertTool.h"
#import "WCBlockTool.h"

@implementation WCAlertTool

+ (void)presentAlertWithTitle:(NSString *)title message:(NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonDidClickBlock:(nullable void (^)(void))cancelButtonDidClickBlock {
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (cancelButtonDidClickBlock) {
                cancelButtonDidClickBlock();
            }
        }];
        [alert addAction:cancelAction];
        UIViewController *topViewController = [WCAlertTool topViewControllerOnWindow:[UIApplication sharedApplication].keyWindow];
        [topViewController presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)presentActionSheetWithTitle:(NSString *)title message:(nullable NSString *)message cancelButtonTitle:(NSString *)cancelButtonTitle cancelButtonDidClickBlock:(nullable void (^)(void))cancelButtonDidClickBlock, ... {
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            if (cancelButtonDidClickBlock) {
                cancelButtonDidClickBlock();
            }
        }];
        [alert addAction:cancelAction];
        
        va_list args;
        va_start(args, cancelButtonDidClickBlock);
        
        id firstArg = nil;
        id secondArg = nil;
        while ((firstArg = va_arg(args, id))) {
            secondArg = va_arg(args, id);
            
            if (![firstArg isKindOfClass:[NSString class]]) {
                break;
            }
            
            void (^block)(void) = nil;
            if ([WCBlockTool isBlock:secondArg]) {
                block = secondArg;
            }
            
            UIAlertAction *action = [UIAlertAction actionWithTitle:firstArg style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                if (block) {
                    block();
                }
            }];
            [alert addAction:action];
            
            if (secondArg == nil) {
                break;
            }
        }
        
        va_end(args);
        
        UIViewController *topViewController = [WCAlertTool topViewControllerOnWindow:[UIApplication sharedApplication].keyWindow];
        [topViewController presentViewController:alert animated:YES completion:nil];
    }
}

+ (void)presentActionSheetWithTitle:(NSString *)title message:(nullable NSString *)message buttonTitles:(NSArray<NSString *> *)buttonTitles buttonDidClickBlocks:(NSArray *)buttonDidClickBlocks {
    if (![buttonTitles isKindOfClass:[NSArray class]] || ![buttonDidClickBlocks isKindOfClass:[NSArray class]]) {
        return;
    }
    
    if (buttonTitles.count != buttonDidClickBlocks.count) {
        return;
    }
    
    if ([UIAlertController class]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleActionSheet];
        
        NSString *buttonTitle = [buttonTitles firstObject];
        id block = [buttonDidClickBlocks firstObject];
        
        if ([buttonTitle isKindOfClass:[NSString class]] && [WCBlockTool isBlock:block]) {
            void (^callback)(void) = block;
            
            UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
                if (callback) {
                    callback();
                }
            }];
            [alert addAction:cancelAction];
        }
        
        for (NSInteger i = 1; i < buttonTitles.count; i++) {
            buttonTitle = buttonTitles[i];
            block = buttonDidClickBlocks[i];
            
            if ([buttonTitle isKindOfClass:[NSString class]] && [WCBlockTool isBlock:block]) {
                void (^callback)(void) = block;
                
                UIAlertAction *action = [UIAlertAction actionWithTitle:buttonTitle style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
                    if (callback) {
                        callback();
                    }
                }];
                [alert addAction:action];
            }
        }
        
        UIViewController *topViewController = [WCAlertTool topViewControllerOnWindow:[UIApplication sharedApplication].keyWindow];
        [topViewController presentViewController:alert animated:YES completion:nil];
    }
}

#pragma mark - Utility

#pragma mark > WCViewControllerTool

+ (nullable UIViewController *)topViewControllerOnWindow:(UIWindow *)window {
    if (![window isKindOfClass:[UIWindow class]]) {
        return nil;
    }
    
    return [self topViewControllerWithRootViewController:window.rootViewController];
}

#pragma mark ::

+ (UIViewController *)topViewControllerWithRootViewController:(UIViewController *)rootViewController {
    if ([rootViewController isKindOfClass:[UITabBarController class]]) {
        UITabBarController *tabBarController = (UITabBarController *)rootViewController;
        return [self topViewControllerWithRootViewController:tabBarController.selectedViewController];
    }
    else if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navigationController = (UINavigationController *)rootViewController;
        // Note: visibleViewController is the view controller at the top of the navigation stack or a view controller that was presented modally on top of the navigation controller itself.
        return [self topViewControllerWithRootViewController:navigationController.visibleViewController];
    }
    else if (rootViewController.presentedViewController) {
        UIViewController *presentedViewController = rootViewController.presentedViewController;
        return [self topViewControllerWithRootViewController:presentedViewController];
    }
    else {
        return rootViewController;
    }
}

@end
