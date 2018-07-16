//
//  WCEmotionVerticalLayoutPage.h
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCBaseHorizontalPage.h"

@interface WCEmotionGroupInfo : NSObject
@property (nonatomic, assign) CGSize itemSize;
@property (nonatomic, strong) NSArray<NSArray<NSObject *> *> *groupData;
@property (nonatomic, strong) NSArray<Class> *itemViewClasses;
@property (nonatomic, strong) Class headerViewClass;
@property (nonatomic, strong) Class footerViewClass;
@end

@class WCEmotionVerticalLayoutPage;

@protocol WCEmotionVerticalPageDataSource <NSObject>

@required
- (UICollectionViewCell *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage cellForGroupInfo:(WCEmotionGroupInfo *)groupInfo atIndexPath:(NSIndexPath *)indexPath;

@optional

- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage headerViewForGroupInfo:(WCEmotionGroupInfo *)groupInfo atIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage footerViewForGroupInfo:(WCEmotionGroupInfo *)groupInfo atIndexPath:(NSIndexPath *)indexPath;

- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfHeaderForGroupInfo:(WCEmotionGroupInfo *)groupInfo inSection:(NSInteger)section;
- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfFooterForGroupInfo:(WCEmotionGroupInfo *)groupInfo inSection:(NSInteger)section;

@end

@interface WCEmotionVerticalLayoutPage : WCBaseHorizontalPage
@property (nonatomic, strong, readonly) WCEmotionGroupInfo *groupInfo;
@property (nonatomic, weak) id<WCEmotionVerticalPageDataSource> dataSource;

- (void)configurePage:(WCEmotionGroupInfo *)groupInfo;

- (UICollectionViewCell *)dequeueReusableCellWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableHeaderViewWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;
- (UICollectionReusableView *)dequeueReusableFooterViewWithReuseIdentifier:(NSString *)reuseIdentifier forIndexPath:(NSIndexPath *)indexPath;

@end
