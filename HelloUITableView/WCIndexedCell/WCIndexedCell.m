//
//  WCIndexedCell.m
//  HelloUITableView
//
//  Created by wesley_chen on 2020/6/13.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCIndexedCell.h"
#import "WCTableViewCellTool.h"
#import <objc/runtime.h>

static const void *kAssociatedObjectKeyTintSystemCheckmarkCell = &kAssociatedObjectKeyTintSystemCheckmarkCell;

#define KeyFromIndexPath(indexPath) [NSString stringWithFormat:@"%ld,%ld", (long)[(indexPath) section], (long)[(indexPath) row]];

@interface WCIndexedCell ()
@property (nonatomic, strong) NSIndexPath *currentIndexPath;
@property (nonatomic, assign) BOOL isConfigureBlockRunning;
@property (nonatomic, weak) UITableView *tableView;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString *, NSMutableDictionary *> *stateMap;
@end

@implementation WCIndexedCell

- (void)configureCellAtIndexPath:(NSIndexPath *)indexPath configureBlock:(void (^)(void))configureBlock {
    self.currentIndexPath = indexPath;
    self.isConfigureBlockRunning = YES;
    configureBlock();
    self.isConfigureBlockRunning = NO;
}

- (BOOL)setAttributeValue:(id)value forAttributeKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (!self.isConfigureBlockRunning) {
        return NO;
    }
    
    UITableView *tableView = self.tableView;
    if (tableView) {
        NSIndexPath *indexPath = self.currentIndexPath;
        if (indexPath) {
            NSString *key = KeyFromIndexPath(indexPath);
            NSMutableDictionary *stateMap = self.stateMap;
            
            if (![stateMap[key] isKindOfClass:[NSMutableDictionary class]]) {
                stateMap[key] = [NSMutableDictionary dictionary];
            }
            
            NSMutableDictionary *attrs = stateMap[key];
            attrs[key] = value;
        }
    }
    
    return YES;
}

- (nullable id)attributeValueForAttributeKey:(NSString *)key {
    if (![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    UITableView *tableView = self.tableView;
    if (tableView) {
        NSIndexPath *indexPath = self.currentIndexPath;
        if (indexPath) {
            NSString *key = KeyFromIndexPath(indexPath);
            NSMutableDictionary *stateMap = self.stateMap;
            
            NSMutableDictionary *attrs = stateMap[key];
            return attrs[key];
        }
    }
    
    return nil;
}

#pragma mark - Getter

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [WCTableViewCellTool superTableViewWithCell:self];
    }
    
    return _tableView;
}

- (NSMutableDictionary *)stateMap {
    NSMutableDictionary *stateMapL;
    
    UITableView *tableView = self.tableView;
    if (tableView) {
        id object = objc_getAssociatedObject(tableView, kAssociatedObjectKeyTintSystemCheckmarkCell);
        if ([object isKindOfClass:[NSMutableDictionary class]]) {
            stateMapL = object;
        }
        else {
            stateMapL = [NSMutableDictionary dictionary];
            objc_setAssociatedObject(tableView, kAssociatedObjectKeyTintSystemCheckmarkCell, stateMapL, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        }
    }
    
    return stateMapL;
}

@end
