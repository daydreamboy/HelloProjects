//
//  WCHorizontalPageBrowserViewController.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, WCHorizontalPageBrowserItemType) {
    WCHorizontalPageBrowserItemLocalImage,
    WCHorizontalPageBrowserItemRemoteImage,
    WCHorizontalPageBrowserItemLocalVideo,
    WCHorizontalPageBrowserItemRemoteVideo,
};

@interface WCHorizontalPageBrowserItem : NSObject
@property (nonatomic, assign) WCHorizontalPageBrowserItemType type;
@property (nonatomic, strong) NSURL *URL;
+ (instancetype)itemWithURL:(NSURL *)URL type:(WCHorizontalPageBrowserItemType)type;
@end

@class WCHorizontalPageBrowserViewController;

@protocol WCHorizontalPageBrowserViewControllerDataSource <NSObject>
- (NSArray<WCHorizontalPageBrowserItem *> *)itemsInHorizontalPageBrowserViewController:(WCHorizontalPageBrowserViewController *)horizontalPageBrowserView;
@end

@interface WCHorizontalPageBrowserViewController : UIViewController
@property (nonatomic, weak) id<WCHorizontalPageBrowserViewControllerDataSource> dataSource;
@end
