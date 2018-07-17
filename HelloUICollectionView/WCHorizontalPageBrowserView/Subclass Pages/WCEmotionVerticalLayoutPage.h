//
//  WCEmotionVerticalLayoutPage.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"

NS_ASSUME_NONNULL_BEGIN

@protocol WCEmotionGroupInfo <NSObject>

#define WCEmotionGroupInfoPropertiesImpl \
@synthesize itemSize; \
@synthesize groupData; \
@synthesize itemViewClasses; \
@synthesize headerViewClass; \
@synthesize footerViewClass; \
@synthesize extraData;

@required
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<NSArray<NSObject *> *> *groupData;
@property (nonatomic, strong) NSArray<Class> *itemViewClasses;
@property (nonatomic, strong) Class headerViewClass;
@property (nonatomic, strong) Class footerViewClass;

@optional
@property (nonatomic, strong) NSMutableDictionary *extraData;

@end

@class WCEmotionVerticalLayoutPage;

@protocol WCEmotionVerticalPageDataSource <NSObject>

@required
- (UICollectionViewCell *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage cellForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo atIndexPath:(NSIndexPath *)indexPath;

@optional

- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage headerViewForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo atIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage footerViewForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfHeaderForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo inSection:(NSInteger)section;
- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfFooterForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo inSection:(NSInteger)section;

@end

@protocol WCEmotionVerticalPageDelegate <NSObject>

@optional

/**
 touch down cell or view when tap or long press, maybe called many times

 @param emotionPage the WCEmotionVerticalLayoutPage
 @param groupInfo the WCEmotionGroupInfo
 @param indexPath the index path for cell. If touch down not on cell, the index path is nil
 */
- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(id<WCEmotionGroupInfo>)groupInfo clickedAtIndexPath:(NSIndexPath *)indexPath;

- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(id<WCEmotionGroupInfo>)groupInfo pressDownAtIndexPath:(NSIndexPath *)indexPath;

- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(id<WCEmotionGroupInfo>)groupInfo pressUpAtIndexPath:(NSIndexPath *)indexPath;

@end

@interface WCEmotionVerticalLayoutPage : WCBaseHorizontalPage
@property (nonatomic, strong, readonly) id<WCEmotionGroupInfo>groupInfo;
@property (nonatomic, weak) id<WCEmotionVerticalPageDataSource> dataSource;
@property (nonatomic, weak) id<WCEmotionVerticalPageDelegate> delegate;

- (void)configurePage:(id<WCEmotionGroupInfo>)groupInfo;

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableHeaderViewWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableFooterViewWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;

/**
 Get the cell frame relative to the page.

 @param indexPath the index path of cell
 @return the frame of cell relative to WCEmotionVerticalLayoutPage. If not find the cell, just return CGRectZero.
 */
- (CGRect)visibleCellRectInPageAtIndexPath:(NSIndexPath *)indexPath;

@end

NS_ASSUME_NONNULL_END
