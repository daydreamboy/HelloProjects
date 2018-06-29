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
- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView configurePage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index reuseIdentifier:(NSString *)reuseIdentifier;
@end

@protocol WCHorizontalPageBrowserViewDelegate <NSObject>

@optional
- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView willDisplayPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index;

- (void)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView didEndDisplayingPage:(WCBaseHorizontalPage *)page forItemAtIndex:(NSInteger)index;
@end

@protocol WCHorizontalPage <NSObject>

@end

@interface WCHorizontalPageBrowserView : UIView
@property (nonatomic, weak) id<WCHorizontalPageBrowserViewDataSource> dataSource;
@property (nonatomic, weak) id<WCHorizontalPageBrowserViewDelegate> delegate;
@property (nonatomic, assign) CGFloat pageSpace;

- (void)registerPageClass:(Class)cellClass forPageWithReuseIdentifier:(NSString *)identifier;
- (void)reloadData;
- (void)reloadItemsAtIndexes:(NSArray<NSNumber *> *)indexes;

@end
