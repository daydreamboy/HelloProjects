//
//  WCMenuItem.m
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/6/26.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCMenuItem.h"
#import "WCMenuItem_Internal.h"

@interface WCMenuItem ()
@property (nonatomic, strong) NSMutableDictionary<NSNumber *, NSString *> *mapStateToTitle;
@end

@implementation WCMenuItem

- (instancetype)initWithTitle:(NSString *)title block:(void (^)(WCMenuItem *))block {
    self = [super initWithTitle:title action:NSSelectorFromString([NSString stringWithFormat:@"%@_%p:", [WCMenuItem actionPrefix], self])];
    if (self) {
        _block = block;
        
        [self setTitle:title forState:WCMenuItemStateNormal];
    }
    return self;
}

+ (NSString *)actionPrefix {
    return @"WCMenuItem_action";
}

#pragma mark > State

- (void)setTitle:(NSString *)title forState:(WCMenuItemState)state {
    self.mapStateToTitle[@(state)] = title;
}

- (NSString *)titleForState:(WCMenuItemState)state {
    return self.mapStateToTitle[@(state)];
}

#pragma mark - Getters

- (NSMutableDictionary<NSNumber *, NSString *> *)mapStateToTitle {
    if (!_mapStateToTitle) {
        _mapStateToTitle = [NSMutableDictionary dictionary];
    }
    
    return _mapStateToTitle;
}

#pragma mark -

- (void)dealloc {
    NSLog(@"%@", self);
}

@end
