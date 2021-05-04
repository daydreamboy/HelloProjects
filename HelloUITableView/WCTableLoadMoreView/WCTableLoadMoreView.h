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

/**
 The load more type
 
 Default is WCTableLoadMoreTypeFromBottom
 */
@property (nonatomic, assign, readonly) WCTableLoadMoreType loadMoreType;
@property (nonatomic, weak, readonly) UITableView *tableView;
@property (nonatomic, strong, readonly) UIActivityIndicatorView *loadingIndicator;

/**
 The callback when WCLoadMoreTableFooterView first to show. The callback is triggered when isRequesting is NO
 
 @note call stopLoadingIndicatorWithTip:hide:animatedForHide: will make this callback never being triggered.
 */
@property (nonatomic, copy) void (^willShowLoadingIndicatorBlock)(WCTableLoadMoreView *view);

/**
 The flag guides to need calling willShowLoadingIndicatorBlock.
 
 @note set to YES, when willShowLoadingIndicatorBlock trigger to request network data. And set to NO when the procedure finished
 */
@property (nonatomic, assign) BOOL isRequesting;

/**
 The content frame which used to decide when to trigger the willShowLoadingIndicatorBlock
 
 Default is the frame of this view
 */
@property (nonatomic, assign) CGRect contentFrame;

/**
 Create a WCTableLoadMoreView
 
 @param tableView the table view
 @param viewController the view controller which hold the table view
 @param frame the frame of the WCTableLoadMoreView
 @param type the WCTableLoadMoreType
 
 @note on iOS 10-, the viewController must not be nil
 */
- (instancetype)initWithTableView:(UITableView *)tableView viewController:(UIViewController *)viewController frame:(CGRect)frame loadMoreType:(WCTableLoadMoreType)type;

/**
 Stop loading indicator when table view has loaded all

 @param tip the tip for finishing load all
 @param hide YES if hide this view
 @param animated YES if hide this view using animation.
 
 @discussion animated parameter only works with hide parameter is YES
 @note This method will make the willShowLoadingIndicatorBlock never being triggered again.
 */
- (void)stopLoadingIndicatorWithTip:(NSString *)tip hide:(BOOL)hide animatedForHide:(BOOL)animated;

/**
 Show the load more view which not keep the table view scrolling
 */
- (void)show;

@end

NS_ASSUME_NONNULL_END
