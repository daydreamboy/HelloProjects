//
//  WCExpandableHeaderView.h
//  HelloExpandableTableView
//
//  Created by wesley chen on 16/12/26.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WCExpandableHeaderView;

@protocol WCExpandableHeaderViewDelegate <NSObject>

@required
- (NSInteger)WCExpandableHeaderView_tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section;

@optional
- (void)sectionDidExpandAtIndex:(NSInteger)sectionIndex expandableHeaderView:(WCExpandableHeaderView *)expandableHeaderView;
- (void)sectionDidCollapseAtIndex:(NSInteger)sectionIndex expandableHeaderView:(WCExpandableHeaderView *)expandableHeaderView;

@end

@interface UITableView (WCExpandableHeaderView_Delegate)
@property (nonatomic, weak) id<WCExpandableHeaderViewDelegate> expandableHeaderView_delegate;

- (WCExpandableHeaderView *)expandableHeaderViewAtSectionIndex:(NSInteger)sectionIndex;
- (void)recordExpandableHeaderView:(WCExpandableHeaderView *)expandableHeaderView atSectionIndex:(NSInteger)sectionIndex;

@end

@interface WCExpandableHeaderView : UIView

@property (nonatomic, assign, readonly) BOOL closed;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)sectionTitle;

@end
