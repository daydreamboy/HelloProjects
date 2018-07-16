//
//  WCHorizontalPageBrowserView.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/6/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCBaseHorizontalPage.h"

@class WCHorizontalPageBrowserView;
@class WCBaseHorizontalPage;

@protocol WCHorizontalPageBrowserViewDataSource <NSObject>

@required
- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView;

@optional
- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index;

@end

@protocol WCHorizontalPageBrowserViewDelegate <NSObject>

@optional

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView willDisplayPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index;

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView didEndDisplayingPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index;

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView didScrollToPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index;

- (void)horizontalPageBrowserViewWillBeginDragging:(WCHorizontalPageBrowserView *)horizontalPageBrowserView;

@end

@interface WCHorizontalPageBrowserView : UIView
@property (nonatomic, weak) id<WCHorizontalPageBrowserViewDataSource> dataSource;
@property (nonatomic, weak) id<WCHorizontalPageBrowserViewDelegate> delegate;
@property (nonatomic, assign) CGFloat pageSpace;
/**
 use page mode or not. Default is YES.
 */
@property (nonatomic, assign) BOOL pagable;

/**
 The separators between pages. If zero or negative, there are no separators.
 
 Default is 0.
 */
@property (nonatomic, assign) CGFloat separatorWidth;
@property (nonatomic, strong) UIColor *separatorColor;

- (void)registerPageClass:(Class)cellClass forPageWithReuseIdentifier:(NSString *)reuseIdentifier;
- (WCBaseHorizontalPage *)dequeueReusablePageWithReuseIdentifier:(NSString *)reuseIdentifier forIndex:(NSInteger)index;
- (void)reloadData;
- (void)reloadItemsAtIndexes:(NSArray<NSNumber *> *)indexes;
- (void)setCurrentPage:(NSInteger)index animated:(BOOL)animated;

@end
