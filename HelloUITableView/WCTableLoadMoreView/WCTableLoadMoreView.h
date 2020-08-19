//
//  WCTableLoadMoreView.h
//  HelloUITableView
//
//  Created by wesley_chen on 2020/8/19.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCTableLoadMoreType) {
    WCTableLoadMoreTypeFromBottom,
    WCTableLoadMoreTypeFromTop,
};

@interface WCTableLoadMoreView : UIView

@property (nonatomic, assign, readonly) WCTableLoadMoreType loadMoreType;
@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *loadingIndicator;

/**
 The callback when WCLoadMoreTableFooterView first to show. The callback is triggered when isRequesting is NO
 @note call dismissActivityIndicatorWithTip: will make this callback never being triggered.
 */
@property (nonatomic, copy) void (^didFirstShowActivityIndicatorBlock)(WCTableLoadMoreView *view);

/**
 The flag guides to need calling didFirstShowActivityIndicatorBlock.
 @note set to YES, when didFirstShowActivityIndicatorBlock trigger to request network data. And set to YES when the procedure finished
 */
@property (nonatomic, assign) BOOL isRequesting;

@property (nonatomic, assign) CGRect contentFrame;

- (instancetype)initWithTableView:(UITableView *)tableView frame:(CGRect)frame loadMoreType:(WCTableLoadMoreType)type;

/**
 Stop loading indicator when table view has loaded all

 @param tip the tip for finishing load all
 @param hide YES if hide this view
 @param animated YES if hide this view using animation.
 
 @discussion animated parameter only works with hide parameter
 @note This method will make the didFirstShowActivityIndicatorBlock never being triggered again.
 */
- (void)stopLoadingIndicatorWithTip:(NSString *)tip hide:(BOOL)hide animatedForHide:(BOOL)animated;

/**
 Show the load more view which not keep the table view scrolling
 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
