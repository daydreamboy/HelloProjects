//
//  WCHorizontalPageBrowserViewController.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCHorizontalPageBrowserItemType) {
    WCHorizontalPageBrowserItemLocalImage,
    WCHorizontalPageBrowserItemRemoteImage,
    WCHorizontalPageBrowserItemLocalVideo,
    WCHorizontalPageBrowserItemRemoteVideo,
};

@interface WCHorizontalPageBrowserItem : NSObject
@property (nonatomic, assign) WCHorizontalPageBrowserItemType type;
@property (nonatomic, strong) NSURL *URL;

/**
 Default is YES
 */
@property (nonatomic, assign) BOOL autoPlayVideo;
+ (instancetype)itemWithURL:(NSURL *)URL type:(WCHorizontalPageBrowserItemType)type;
@end

@class WCHorizontalPageBrowserViewController;

@protocol WCHorizontalPageBrowserViewControllerDataSource <NSObject>
- (NSArray<WCHorizontalPageBrowserItem *> *)itemsInHorizontalPageBrowserViewController:(WCHorizontalPageBrowserViewController *)horizontalPageBrowserView;
@end

@interface WCHorizontalPageBrowserViewController : UIViewController

@property (nonatomic, weak) id<WCHorizontalPageBrowserViewControllerDataSource> dataSource;
@property (nonatomic, copy) void (^pageDidDisplayBlock)(WCHorizontalPageBrowserItem *item, NSInteger index);

- (void)setCurrentPageAtIndex:(NSInteger)index animated:(BOOL)animated;
- (void)reloadPageData;

/**
 Show from a specific rect which of a UIImageView

 @param rect the rect for the image view to open. And rect's origin is refer UIWindow
 @param viewController the host view controller present this view controller
 @param animated YES, animate with a zoom effect. NO, just show immediately
 */
- (void)showInRect:(CGRect)rect fromViewController:(UIViewController *)viewController animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
