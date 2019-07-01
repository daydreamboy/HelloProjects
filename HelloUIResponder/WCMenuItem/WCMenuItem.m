//
//  WCMenuItem.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCMenuItem.h"
#import <objc/runtime.h>


@interface WCMenuItem ()

@property (nonatomic, weak, readwrite, nullable) UIView *targetView;
@property (nonatomic, weak, readwrite, nullable) UIMenuController *menuController;
@end

@implementation WCMenuItem

- (instancetype)initWithTitle:(NSString *)title block:(void (^)(WCMenuItem *))block {
    self = [super initWithTitle:title action:NSSelectorFromString([NSString stringWithFormat:@"%@_%p:", [WCMenuItem actionPrefix], self])];
    if (self) {
        _block = block;
    }
    return self;
}

+ (NSString *)actionPrefix {
    return @"WCMenuItem_action";
}

#pragma mark -

- (void)dealloc {
    NSLog(@"%@", self);
}

@end

@implementation WCMenuItemTool

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
