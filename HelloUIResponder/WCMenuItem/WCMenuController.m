//
//  WCMenuController.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/7/3.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCMenuController.h"
#import "WCMenuItem_Internal.h"
#import <objc/runtime.h>

@implementation WCMenuController

#pragma mark - Override Methods

+ (instancetype)sharedMenuController {
    static WCMenuController *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCMenuController alloc] init];
    });
    
    return sInstance;
}

- (void)setMenuVisible:(BOOL)menuVisible {
    [self updateMenuItemsIfNeeded];
    [[UIMenuController sharedMenuController] setMenuVisible:menuVisible];
}

- (BOOL)isMenuVisible {
    return [[UIMenuController sharedMenuController] isMenuVisible];
}

- (void)setMenuVisible:(BOOL)menuVisible animated:(BOOL)animated {
    [self updateMenuItemsIfNeeded];
    [[UIMenuController sharedMenuController] setMenuVisible:menuVisible animated:YES];
}

- (void)setTargetRect:(CGRect)targetRect inView:(UIView *)targetView {
    [[UIMenuController sharedMenuController] setTargetRect:targetRect inView:targetView];
}

- (CGRect)menuFrame {
    return [UIMenuController sharedMenuController].menuFrame;
}

- (void)setArrowDirection:(UIMenuControllerArrowDirection)arrowDirection {
    [UIMenuController sharedMenuController].arrowDirection = arrowDirection;
}

- (UIMenuControllerArrowDirection)arrowDirection {
    return [UIMenuController sharedMenuController].arrowDirection;
}

- (void)update {
    [self updateMenuItemsIfNeeded];
    [[UIMenuController sharedMenuController] update];
}

- (void)setMenuItems:(NSArray<UIMenuItem *> *)menuItems {
    [UIMenuController sharedMenuController].menuItems = menuItems;
}

- (NSArray<UIMenuItem *> *)menuItems {
    return [UIMenuController sharedMenuController].menuItems;
}

#pragma mark -

- (void)updateMenuItemsIfNeeded {
    for (WCMenuItem *menuItem in [UIMenuController sharedMenuController].menuItems) {
        if ([menuItem isKindOfClass:[WCMenuItem class]]) {
            menuItem.title = [menuItem titleForState:menuItem.state];
        }
    }
}

#pragma mark - Public Methods

+ (BOOL)registerMenuItemsWithTargetView:(UIView *)targetView menuItems:(NSArray<WCMenuItem *> *)menuItems {
    if (![targetView isKindOfClass:[UIView class]] || ![menuItems isKindOfClass:[NSArray class]]) {
        return NO;
    }
    
    BOOL registerAllSuccess = YES;
    
    for (WCMenuItem *item in menuItems) {
        if ([item isKindOfClass:[WCMenuItem class]]) {
            __weak typeof(item) weak_item = item;
            __weak typeof(targetView) weak_targetView = targetView;
            
            IMP imp = imp_implementationWithBlock(^(id self, SEL selector, id sender) {
                item.targetView = weak_targetView;
                item.menuController = sender;
                
                !item.block ?: item.block(weak_item);
            });
            
            BOOL success = class_addMethod([targetView class], NSSelectorFromString([NSString stringWithFormat:@"%@_%p:", [WCMenuItem actionPrefix], item]), imp, "v@:");
            if (!success) {
                registerAllSuccess = NO;
            }
        }
    }
    
    return registerAllSuccess;
}

@end
