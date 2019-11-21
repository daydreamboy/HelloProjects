//
//  WCControlTool.m
//  HelloUIControl
//
//  Created by wesley_chen on 2019/11/19.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCControlTool.h"

// >= `9.0`
#ifndef IOS9_OR_LATER
#define IOS9_OR_LATER          ([[[UIDevice currentDevice] systemVersion] compare:@"9.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

@implementation WCControlTool

+ (nullable NSDictionary<NSString *, NSArray *> *)allTargetActionsMapWithControl:(UIControl *)control {
    if (![control isKindOfClass:[UIControl class]]) {
        return nil;
    }
    
    NSSet *allTargets = [control allTargets];
    UIControlEvents allControlEvents = [control allControlEvents];
    
    NSMutableDictionary *allKnownEventsMap = [@{
        @(UIControlEventTouchDown): @"UIControlEventTouchDown",
        @(UIControlEventTouchDownRepeat): @"UIControlEventTouchDownRepeat",
        @(UIControlEventTouchDragInside): @"UIControlEventTouchDragInside",
        @(UIControlEventTouchDragOutside): @"UIControlEventTouchDragOutside",
        @(UIControlEventTouchDragEnter): @"UIControlEventTouchDragEnter",
        @(UIControlEventTouchDragExit): @"UIControlEventTouchDragExit",
        @(UIControlEventTouchUpInside): @"UIControlEventTouchUpInside",
        @(UIControlEventTouchUpOutside): @"UIControlEventTouchUpOutside",
        @(UIControlEventTouchCancel): @"UIControlEventTouchCancel",
        @(UIControlEventValueChanged): @"UIControlEventValueChanged",
        @(UIControlEventEditingDidBegin): @"UIControlEventEditingDidBegin",
        @(UIControlEventEditingChanged): @"UIControlEventEditingChanged",
        @(UIControlEventEditingDidEnd): @"UIControlEventEditingDidEnd",
        @(UIControlEventEditingDidEndOnExit): @"UIControlEventEditingDidEndOnExit",
    } mutableCopy];
    
    if (IOS9_OR_LATER) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wunguarded-availability"
        allKnownEventsMap[@(UIControlEventPrimaryActionTriggered)] = @"UIControlEventPrimaryActionTriggered";
#pragma GCC diagnostic pop
    }
    
    NSMutableDictionary<NSString *, NSArray *> *dictM = [NSMutableDictionary dictionaryWithCapacity:allTargets.count];
    
    [allKnownEventsMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull event, NSString * _Nonnull eventName, BOOL * _Nonnull stop) {
        NSUInteger eventMask = [event unsignedIntegerValue];
        if (allControlEvents & eventMask) {
            for (id target in allTargets) {
                NSArray<NSString *> *selectors = [control actionsForTarget:target forControlEvent:eventMask];
                if (selectors) {
                    // Note: Don't use target as key, maybe the target not confirm copyWithZone:,
                    // because NSMutableDictionary must copy the key
                    dictM[[NSString stringWithFormat:@"%p", target]] = @[target, event, eventName, selectors];
                }
            }
        }
    }];
    
    return dictM;
}

@end
