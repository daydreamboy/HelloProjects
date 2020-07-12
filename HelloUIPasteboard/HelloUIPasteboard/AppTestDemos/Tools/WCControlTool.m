//
//  WCControlTool.m
//  HelloUIPasteboard
//
//  Created by wesley_chen on 2020/7/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCControlTool.h"
#import <objc/runtime.h>

@interface WCControlToolBlockHolder : NSObject
@property (nonatomic, copy) void (^block)(id sender);
@property (nonatomic, assign) UIControlEvents events;
- (instancetype)initWithEvents:(UIControlEvents)events block:(void (^)(id sender))block;
- (void)invoke:(id)sender;
@end

@implementation WCControlToolBlockHolder

- (instancetype)initWithEvents:(UIControlEvents)events block:(void (^)(id sender))block {
    self = [super init];
    if (self) {
        _events = events;
        _block = [block copy];
    }
    return self;
}

- (void)invoke:(id)sender {
    if (_block) _block(sender);
}

@end


@implementation WCControlTool

#pragma mark - Target-Action Block/Normal Style

#pragma mark > Add

+ (BOOL)addBlockForControl:(UIControl *)control events:(UIControlEvents)events block:(void (^)(id sender))block {
    if (![control isKindOfClass:[UIControl class]] || !block || !events) {
        return NO;
    }
    
    WCControlToolBlockHolder *holder = [[WCControlToolBlockHolder alloc] initWithEvents:events block:block];
    [control addTarget:holder action:@selector(invoke:) forControlEvents:events];
    
    [[self holdersForControl:control] addObject:holder];
    
    return YES;
}

#pragma mark > Replace

+ (BOOL)setBlockForControl:(UIControl *)control events:(UIControlEvents)events block:(void (^)(id sender))block {
    if (![control isKindOfClass:[UIControl class]] || !events) {
        return NO;
    }
    
    [self removeAllBlocksForControl:control events:UIControlEventAllEvents];
    [self addBlockForControl:control events:events block:block];
    
    return YES;
}

+ (BOOL)setTargetToContorl:(UIControl *)control target:(id)target action:(SEL)action forControlEvents:(UIControlEvents)events {
    if (![control isKindOfClass:[UIControl class]] || !target || !action || !events) {
        return NO;
    }
    
    NSSet *targets = [control allTargets];
    for (id currentTarget in targets) {
        NSArray *actions = [control actionsForTarget:currentTarget forControlEvent:events];
        for (NSString *currentAction in actions) {
            [control removeTarget:currentTarget action:NSSelectorFromString(currentAction)
                forControlEvents:events];
        }
    }
    [control addTarget:target action:action forControlEvents:events];
    
    return YES;
}

#pragma mark > Remove

+ (BOOL)removeAllBlocksForControl:(UIControl *)control events:(UIControlEvents)events {
    if (![control isKindOfClass:[UIControl class]] || !events) {
        return NO;
    }
    
    NSMutableArray *holders = [self holdersForControl:control];
    NSMutableArray *toRemoves = [NSMutableArray array];
    
    for (WCControlToolBlockHolder *holder in holders) {
        if (holder.events & events) {
            // Note: check the events to remove if exists in the holder
            UIControlEvents newEvent = holder.events & (~events);
            if (newEvent) {
                // When the events to remove exists in the holder, update the holder's events and still keep the holder as control's target
                [control removeTarget:holder action:@selector(invoke:) forControlEvents:holder.events];
                holder.events = newEvent;
                [control addTarget:holder action:@selector(invoke:) forControlEvents:holder.events];
            }
            else {
                // When the events to remove not exists in the holder, remove the holder
                [control removeTarget:holder action:@selector(invoke:) forControlEvents:holder.events];
                [toRemoves addObject:holder];
            }
        }
    }
    
    [holders removeObjectsInArray:toRemoves];
    
    return YES;
}

+ (BOOL)removeAllTargetsForControl:(UIControl *)control {
    if (![control isKindOfClass:[UIControl class]]) {
        return NO;
    }
    
    [[control allTargets] enumerateObjectsUsingBlock: ^(id object, BOOL *stop) {
        [control removeTarget:object action:NULL forControlEvents:UIControlEventAllEvents];
    }];
    
    [[self holdersForControl:control] removeAllObjects];
    
    return YES;
}

#pragma mark ::

static void * const kAssociatedKeyBlockHolder = (void *)&kAssociatedKeyBlockHolder;

+ (NSMutableArray<WCControlToolBlockHolder *> *)holdersForControl:(UIControl *)control {
    NSMutableArray *holders = objc_getAssociatedObject(control, &kAssociatedKeyBlockHolder);
    if (!holders) {
        holders = [NSMutableArray array];
        objc_setAssociatedObject(control, &kAssociatedKeyBlockHolder, holders, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return holders;
}

#pragma mark ::

@end
