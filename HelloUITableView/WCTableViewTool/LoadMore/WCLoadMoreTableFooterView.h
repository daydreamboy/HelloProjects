//
//  WCLoadMoreTableFooterView.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCLoadMoreTableFooterView : UIView

/**
 The callback when WCLoadMoreTableFooterView first to show. The callback is triggered when isRequesting is NO
 @note call dismissActivityIndicatorWithTip: will make this callback never being triggered.
 */
@property (nonatomic, copy) void (^didFirstShowActivityIndicatorBlock)(WCLoadMoreTableFooterView *loadMoreView);

/**
 The flag guides to need calling didFirstShowActivityIndicatorBlock.
 @note set to YES, when didFirstShowActivityIndicatorBlock trigger to request network data. And set to YES when the procedure finished
 */
@property (nonatomic, assign) BOOL isRequesting;

- (instancetype)initWithFrame:(CGRect)frame activityIndicatorStyle:(UIActivityIndicatorViewStyle)activityIndicatorStyle;

/**
 Start animating activity indicator
 @note must call this method in -[UIScrollView scrollViewDidScroll:]
 */
- (void)startActivityIndicatorIfNeeded;

/**
 Dismiss activity indicator when table view has loaded all

 @param tip the tip for finishing load all
 @note This method will make the didFirstShowActivityIndicatorBlock never being triggered again.
 */
- (void)dismissActivityIndicatorWithTip:(NSString *)tip;

@end

NS_ASSUME_NONNULL_END
