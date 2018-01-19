//
//  WCExpandableHeaderView.m
//  HelloExpandableTableView
//
//  Created by wesley chen on 16/12/26.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "WCExpandableHeaderView.h"
#import <objc/runtime.h>

@interface WCTableViewSectionInfo : NSObject
@property (nonatomic, weak) id<WCExpandableHeaderViewDelegate> expandableHeaderView_delegate;
@property (nonatomic, weak) UITableView *tableView;
// key is index of section
@property (nonatomic, strong) NSMutableDictionary *headerViews;
@property (nonatomic, strong) NSArray *listData;
@end

@implementation WCTableViewSectionInfo
@end


@implementation UITableView (WCExpandableHeaderView_Delegate)

static NSString *WCTableViewSectionInfoObjectTag = @"WCExpandableHeaderViewDelegateObjectTag";

- (void)setExpandableHeaderView_delegate:(id<WCExpandableHeaderViewDelegate>)expandableHeaderView_delegate {
    
    WCTableViewSectionInfo *info = objc_getAssociatedObject(self, &WCTableViewSectionInfoObjectTag);
    if (!info.expandableHeaderView_delegate) {
        WCTableViewSectionInfo *info = [WCTableViewSectionInfo new];
        info.expandableHeaderView_delegate = expandableHeaderView_delegate;
        info.tableView = self;
        info.headerViews = [NSMutableDictionary dictionary];
        info.listData = [expandableHeaderView_delegate tableViewData:self];
        
        objc_setAssociatedObject(self, &WCTableViewSectionInfoObjectTag, info, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
}

- (id<WCExpandableHeaderViewDelegate>)expandableHeaderView_delegate {
    WCTableViewSectionInfo *info = objc_getAssociatedObject(self, &WCTableViewSectionInfoObjectTag);
    return info.expandableHeaderView_delegate;
}

- (WCExpandableHeaderView *)expandableHeaderViewAtSectionIndex:(NSInteger)sectionIndex {
    WCTableViewSectionInfo *info = objc_getAssociatedObject(self, &WCTableViewSectionInfoObjectTag);
    return info.headerViews[@(sectionIndex)];
}

- (void)recordExpandableHeaderView:(WCExpandableHeaderView *)expandableHeaderView atSectionIndex:(NSInteger)sectionIndex {
    WCTableViewSectionInfo *info = objc_getAssociatedObject(self, &WCTableViewSectionInfoObjectTag);
    info.headerViews[@(sectionIndex)] = expandableHeaderView;
}

@end

@interface WCExpandableHeaderView ()
@property (nonatomic, assign, readwrite) BOOL closed;
@property (nonatomic, strong) WCTableViewSectionInfo *sectionInfo;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UIButton *buttonIndicator;
@end

@implementation WCExpandableHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = YES;
        self.closed = NO;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(toggleOpenOrClose:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)sectionTitle {
    self = [self initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:0.97f green:0.97f blue:0.97f alpha:1.0f];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, CGRectGetWidth(frame) - 15, CGRectGetHeight(frame))];
        label.backgroundColor = [UIColor clearColor];
        label.text = sectionTitle;
        label.font = [UIFont boldSystemFontOfSize:17.0f];
        label.textColor = [UIColor colorWithRed:0.137f green:0.137f blue:0.137f alpha:1.0f];
        [self addSubview:label];
        _labelTitle = label;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.userInteractionEnabled = NO;
        button.transform = CGAffineTransformMakeRotation(M_PI);
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitle:@"△" forState:UIControlStateNormal];
        button.titleLabel.font = [UIFont systemFontOfSize:14.0f];
        [button sizeToFit];
        button.center = CGPointMake(CGRectGetWidth(frame) - CGRectGetWidth(button.bounds) / 2.0, CGRectGetHeight(frame) / 2.0);
        [self addSubview:button];
        _buttonIndicator = button;
    }
    return self;
}

#pragma mark - Actions

- (void)toggleOpenOrClose:(id)sender {
    WCExpandableHeaderView *headerView = (WCExpandableHeaderView *)[(UITapGestureRecognizer *)sender view];
    WCTableViewSectionInfo *info = objc_getAssociatedObject([self superTableView], &WCTableViewSectionInfoObjectTag);
    
    NSInteger sectionIndex = 0;
    for (NSNumber *number in info.headerViews) {
        WCExpandableHeaderView *view = info.headerViews[number];
        if (view == headerView) {
            sectionIndex = [number integerValue];
            break;
        }
    }
    
    if (headerView.closed) {
        // to open
        NSInteger sectionOpened = sectionIndex;
        
        // Get the number of rows in the open section
        NSInteger countOfRowsToInsert = [info.listData[sectionOpened] count];
        NSMutableArray *indexPathsToInsert = [[NSMutableArray alloc] init];
        
        // Gather the indexes for inserting
        for (NSInteger i = 0; i < countOfRowsToInsert; i++) {
            [indexPathsToInsert addObject:[NSIndexPath indexPathForRow:i inSection:sectionOpened]];
        }
        
        headerView.closed = NO;
        
        // Commit the animation
        [CATransaction begin];
        [info.tableView beginUpdates];
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            _buttonIndicator.transform = CGAffineTransformMakeRotation(M_PI);
        } completion:nil];
        [CATransaction setCompletionBlock:^{
            if ([info.expandableHeaderView_delegate respondsToSelector:@selector(sectionDidExpandAtIndex:expandableHeaderView:)]) {
                [info.expandableHeaderView_delegate sectionDidExpandAtIndex:sectionOpened expandableHeaderView:headerView];
            }
        }];
        [info.tableView insertRowsAtIndexPaths:indexPathsToInsert withRowAnimation:UITableViewRowAnimationTop];
        [info.tableView endUpdates];
        [CATransaction commit];
    }
    else {
        // to close
        NSInteger sectionClosed = sectionIndex;
        
        // Get the number of rows in the close section
        NSInteger countOfRowsToDelete = [info.listData[sectionClosed] count];
        
        if (countOfRowsToDelete > 0) {
            NSMutableArray *indexPathsToDelete = [[NSMutableArray alloc] init];
            
            // Gather the indexes for deleting
            for (NSInteger i = 0; i < countOfRowsToDelete; i++) {
                [indexPathsToDelete addObject:[NSIndexPath indexPathForRow:i inSection:sectionClosed]];
            }
            
            headerView.closed = YES;
            
            // Commit the animation
            [CATransaction begin];
            [info.tableView beginUpdates];
            [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
                _buttonIndicator.transform = CGAffineTransformMakeRotation(-2 * M_PI);
            } completion:nil];
            [CATransaction setCompletionBlock:^{
                if ([info.expandableHeaderView_delegate respondsToSelector:@selector(sectionDidCollapseAtIndex:expandableHeaderView:)]) {
                    [info.expandableHeaderView_delegate sectionDidCollapseAtIndex:sectionClosed expandableHeaderView:headerView];
                }
            }];
            [info.tableView deleteRowsAtIndexPaths:indexPathsToDelete withRowAnimation:UITableViewRowAnimationTop];
            [info.tableView endUpdates];
            [CATransaction commit];
        }
    }
}

#pragma mark - Helpers

- (UITableView *)superTableView {
    
    id view = [(UIView *)self superview];
    while (view && [view isKindOfClass:[UITableView class]] == NO) {
        view = [view superview];
    }
    UITableView *tableView = (UITableView *)view;
    
    return tableView;
}

@end
