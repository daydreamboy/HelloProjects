//
//  WCTableView.m
//  LotteryMate
//
//  Created by chenliang-xy on 15/6/2.
//  Copyright (c) 2015年 Qihoo. All rights reserved.
//

#import "WCTableView.h"
#import <objc/runtime.h>

#ifndef IOS7_OR_LATER
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] compare:@"7.0" options:NSNumericSearch] != NSOrderedAscending)
#endif

#define DEBUG_UI 0

@interface DummyView : UIView
@end

@implementation DummyView
@end

@interface WCTableView ()
@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, strong) DummyView *dummyView;
@property (nonatomic, strong) UIView *wrappingView;
@property (nonatomic, strong) UIView *tableViewHeaderView;
@end

@implementation WCTableView

#pragma mark - Associated Properties

@dynamic separatorInset;

static const char * const SeparatorInsetObjectTag = "SeparatorInsetObjectTag";

- (void)setSeparatorInset:(UIEdgeInsets)separatorInset {
    if (IOS7_OR_LATER) {
        [super setSeparatorInset:separatorInset];
    }
    else {
        NSValue *valueObj = [NSValue valueWithUIEdgeInsets:separatorInset];
        objc_setAssociatedObject(self, SeparatorInsetObjectTag, valueObj, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (UIEdgeInsets)separatorInset {
    if (IOS7_OR_LATER) {
        return [super separatorInset];
    }
    else {
        NSValue *valueObj = objc_getAssociatedObject(self, SeparatorInsetObjectTag);
        return [valueObj UIEdgeInsetsValue];
    }
}

#pragma mark - Public Methods

- (instancetype)initWithFrame:(CGRect)frame style:(UITableViewStyle)style {
    
    if (IOS7_OR_LATER) {
        self = [super initWithFrame:frame style:style];
    }
    else {
        self = [super initWithFrame:frame style:UITableViewStylePlain];
        _tableViewStyle = style;
        
        if (self) {
            
            self.backgroundColor = [UIColor whiteColor];
            self.separatorInset = UIEdgeInsetsMake(0, 15, 0, 0);
            self.separatorColor = [UIColor colorWithRed:0xC8 / 255.0 green:0xC7 / 255.0 blue:0xCC / 255.0 alpha:1];
            
            if (style == UITableViewStyleGrouped) {
                CGFloat dummyViewHeight = 40;
                _dummyView = [[DummyView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, dummyViewHeight)];
                _dummyView.backgroundColor = [UIColor clearColor];
#if DEBUG_UI
                _dummyView.backgroundColor = [UIColor yellowColor];
#endif
                self.tableHeaderView = _dummyView;
            }
        }
    }
    
    return self;
}

/*!
 *  Register a custom table view cell
 *
 *  @param cellClass Can be subclass of UITableViewCell or nil
 */
- (void)registerCellClass:(Class)cellClass {
    
    if (!IOS7_OR_LATER) {
        NSString *className = NSStringFromClass(cellClass);
        if (![className isEqualToString:@"UITableViewCell"]) {
            self.separatorStyle = UITableViewCellSeparatorStyleNone;
        }
    }
}

/*!
 *  Set custom table view header
 *
 *  @param tableHeaderView 
 *  @warning must set contentInset: method before call this method
 */
- (void)setTableHeaderView:(UIView *)tableHeaderView {
    
    if (![tableHeaderView isKindOfClass:[DummyView class]]) {
        _tableViewHeaderView = tableHeaderView;
    }
    
    if (IOS7_OR_LATER) {
        [super setTableHeaderView:tableHeaderView];
    }
    else {
        if (_tableViewStyle == UITableViewStyleGrouped) {
            // http://stackoverflow.com/questions/1074006/is-it-possible-to-disable-floating-headers-in-uitableview-with-uitableviewstylep
            
            CGFloat headerViewHeight = CGRectGetHeight(tableHeaderView.bounds);
            UIEdgeInsets insets = self.contentInset;
            
            if ([tableHeaderView isKindOfClass:[DummyView class]]) {
                [super setTableHeaderView:tableHeaderView];

                self.contentInset = UIEdgeInsetsMake(-headerViewHeight, insets.left, insets.bottom, insets.right);
            }
            else {
                
                CGFloat dummyHeight = CGRectGetHeight(_dummyView.bounds);
                CGFloat totalHeight = headerViewHeight + dummyHeight;
                
                CGRect newFrame = tableHeaderView.frame;
                newFrame.origin.y += CGRectGetHeight(_dummyView.bounds);
                tableHeaderView.frame = newFrame;
                
                _wrappingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.bounds.size.width, totalHeight)];
                [_wrappingView addSubview:_dummyView];
                [_wrappingView addSubview:tableHeaderView];
                
                [super setTableHeaderView:_wrappingView];
                self.contentInset = UIEdgeInsetsMake(-dummyHeight, insets.left, insets.bottom, insets.right);
            }
        }
    }
}

#pragma mark - 

- (void)didMoveToSuperview {
    [super didMoveToSuperview];
    
    if (_extendTableViewHeaderColor && _tableViewHeaderView) {
        
        // http://stackoverflow.com/questions/1114587/different-background-colors-for-the-top-and-bottom-of-a-uitableview
        
        CGRect frame = self.bounds;
        frame.origin.y = -frame.size.height;
        UIView *topView = [[UIView alloc] initWithFrame:frame];
        topView.backgroundColor = _tableViewHeaderView.backgroundColor;
        [self addSubview:topView];
        
        _wrappingView.backgroundColor = _tableViewHeaderView.backgroundColor;
    }
}

@end
