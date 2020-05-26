//
//  WCCrossDirectionEmotionPickerView.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCCrossDirectionEmotionPickerView.h"
#import "WCHorizontalPageBrowserView.h"
#import "WCEmotionVerticalLayoutPage.h"
#import "WCEmotionItemView.h"
#import "WCEmotionHeaderView.h"
#import "WCEmotionFooterView.h"
#import "WCPopoverView.h"
#import "WCHorizontalSliderViewBaseCell.h"
#import "WCHorizontalSliderViewLayout.h"
#import "WCHorizontalSliderView.h"

#ifndef UICOLOR_randomColor
#define UICOLOR_randomColor [UIColor colorWithRed:(arc4random() % 255 / 255.0f) green:(arc4random() % 255 / 255.0f) blue:(arc4random() % 255 / 255.0f) alpha:1]
#endif

#define sliderViewHeight 34
#define pickerViewHeight (216 - 34)

@interface WCEmotionItemModel : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) NSArray<NSString *> *codes;
@end
@implementation WCEmotionItemModel
@end

@interface WCEmotionSliderGroupItem : NSObject <WCHorizontalSliderItem>
@end
@implementation WCEmotionSliderGroupItem
WCHorizontalSliderItemPropertiesImpl
@end

@interface WCEmotionPickerGroupItem : NSObject <WCEmotionGroupInfo>
@end
@implementation WCEmotionPickerGroupItem
WCEmotionGroupInfoPropertiesImpl
@end

@interface WCCrossDirectionEmotionPickerView () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate, WCEmotionVerticalPageDataSource, WCEmotionVerticalPageDelegate, WCHorizontalSliderViewDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pickerView;
@property (nonatomic, strong) WCHorizontalSliderView *sliderView;
@property (nonatomic, strong) NSArray<id<WCEmotionGroupInfo>> *emotionPageData;
@property (nonatomic, strong) WCPopoverView *popoverView;
@property (nonatomic, strong) NSIndexPath *touchDownIndexPath;
@end

@implementation WCCrossDirectionEmotionPickerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:self.pickerView];
        [self addSubview:self.sliderView];
        
        [self preloadData];
    }
    return self;
}

- (void)preloadData {
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    
    NSString *orderPlistFilePath = [emotionBundlePath stringByAppendingPathComponent:@"emotionOrder.plist"];
    NSString *codePlistFilePath = [emotionBundlePath stringByAppendingPathComponent:@"EmoticonInfo.plist"];
    
    NSMutableArray<WCEmotionItemModel *> *items = [NSMutableArray array];
    NSArray<NSString *> *emotionNameList = [NSArray arrayWithContentsOfFile:orderPlistFilePath];
    NSDictionary<NSString *, NSArray *> *emotionCodeDict = [NSDictionary dictionaryWithContentsOfFile:codePlistFilePath];
    
    for (NSUInteger i = 0; i < emotionNameList.count; i++) {
        NSString *imageName = emotionNameList[i];
        
        WCEmotionItemModel *item = [WCEmotionItemModel new];
        item.name = imageName;
        item.codes = emotionCodeDict[imageName];
        
        [items addObject:item];
    }
    
    id<WCEmotionGroupInfo> group1 = [WCEmotionPickerGroupItem new];
    group1.groupData = @[
                         items,
                         items,
                         ];
    group1.itemViewClasses = @[[WCEmotionItemView class]];
    group1.headerViewClass = [WCEmotionHeaderView class];
    group1.footerViewClass = [WCEmotionFooterView class];
    
    id<WCEmotionGroupInfo> group2 = [WCEmotionPickerGroupItem new];
    group2.groupData = @[
                         items,
                         ];
    group2.itemViewClasses = @[[WCEmotionItemView class]];
    
    id<WCEmotionGroupInfo> group3 = [WCEmotionPickerGroupItem new];
    group3.groupData = @[
                         items,
                         ];
    group3.itemViewClasses = @[[WCEmotionItemView class]];
    
    self.emotionPageData = @[
                             group1,
                             group2,
                             group3,
                             ];
}

#pragma mark - Getters

- (WCHorizontalPageBrowserView *)pickerView {
    if (!_pickerView) {
        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, pickerViewHeight)];;
        view.dataSource = self;
        view.delegate = self;
        view.pageSpace = 0;
//        view.separatorWidth = 30;
//        view.pagable = NO;
        
        [view registerPageClass:[WCEmotionVerticalLayoutPage class] forPageWithReuseIdentifier:NSStringFromClass([WCEmotionVerticalLayoutPage class])];
        
        _pickerView = view;
    }
    
    return _pickerView;
}

- (WCHorizontalSliderView *)sliderView {
    if (!_sliderView) {
        NSMutableArray<id<WCHorizontalSliderItem>> *items = [NSMutableArray array];
        
        for (NSInteger i = 0; i < 10; i++) {
            WCEmotionSliderGroupItem *item = [WCEmotionSliderGroupItem new];
            NSString *imageName = [NSString stringWithFormat:@"EmotionGroupIcon_%d@2x", arc4random() % 8 + 1];
            item.iconURL = [[NSBundle mainBundle] URLForResource:imageName withExtension:@"png"];
            item.iconSize = CGSizeMake(21, 21);
            item.width = 45.5;
            [items addObject:item];
        }
        
        CGFloat paddingH = 20;
        WCHorizontalSliderView *view = [[WCHorizontalSliderView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.pickerView.frame), self.frame.size.width  - 2 * paddingH, sliderViewHeight)];
        view.delegate = self;
        view.sliderData = items;
        view.separatorWidth = 1.0 / [UIScreen mainScreen].scale;
        view.separatorColor = [UIColor redColor];
        view.itemSelectedColor = [UIColor redColor];
        
        view.backgroundColor = [UIColor yellowColor];

        _sliderView = view;
    }

    return _sliderView;
}

#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return self.emotionPageData.count;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index {
    WCBaseHorizontalPage *page;
    
    id<WCEmotionGroupInfo>item = self.emotionPageData[index];
    item.itemSize = CGSizeMake(horizontalPageBrowserView.bounds.size.width / 8.0, 40);
    
    page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCEmotionVerticalLayoutPage class]) forIndex:index];
    WCEmotionVerticalLayoutPage *emotionPage = (WCEmotionVerticalLayoutPage *)page;
    emotionPage.dataSource = self;
    emotionPage.delegate = self;
    [emotionPage configurePage:item];
    page.backgroundColor = UICOLOR_randomColor;
    
    return page;
}

#pragma mark - WCHorizontalPageBrowserViewDelegate

- (void)horizontalPageBrowserViewWillBeginDragging:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    [self.popoverView dismiss:YES];
}

#pragma mark - WCEmotionVerticalPageDataSource

- (UICollectionViewCell *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage cellForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo atIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = groupInfo.itemViewClasses[0];
    
    WCEmotionItemView *cell = (WCEmotionItemView *)[emotionPage dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    WCEmotionItemModel *item = (WCEmotionItemModel *)groupInfo.groupData[indexPath.section][indexPath.item];
    
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
    
    cell.imageView.image = [UIImage imageNamed:imagePath];
    cell.backgroundColor = UICOLOR_randomColor;
    
    return cell;
}

- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage headerViewForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo atIndexPath:(NSIndexPath *)indexPath {
    WCEmotionHeaderView *header = (WCEmotionHeaderView *)[emotionPage dequeueReusableHeaderViewWithReuseIdentifier:NSStringFromClass([WCEmotionHeaderView class]) forIndexPath:indexPath];
    header.backgroundColor = [UIColor redColor];
    header.textLabel.text = (indexPath.section == 0) ? @"最近使用" : @"全部表情";
    
    return header;
}

- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage footerViewForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footer = [emotionPage dequeueReusableFooterViewWithReuseIdentifier:NSStringFromClass([WCEmotionFooterView class])  forIndexPath:indexPath];
    footer.backgroundColor = [UIColor blueColor];
    
    return footer;
}

- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfHeaderForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo inSection:(NSInteger)section {
    return 30;
}

- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfFooterForGroupInfo:(id<WCEmotionGroupInfo>)groupInfo inSection:(NSInteger)section {
    return 30;
}

#pragma mark - WCEmotionVerticalPageDelegate

#define NSIndexPathEqualToIndexPath(indexPath1, indexPath2) \
((indexPath1.section == indexPath2.section) && (indexPath1.row == indexPath2.row))

- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(id<WCEmotionGroupInfo>)groupInfo clickedAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    contentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.6];
    WCEmotionItemModel *item = (WCEmotionItemModel *)groupInfo.groupData[indexPath.section][indexPath.item];
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
    contentView.image = [UIImage imageNamed:imagePath];
    
    if (NSIndexPathEqualToIndexPath(self.touchDownIndexPath, indexPath) && !self.popoverView.hidden) {
        // Note: touch down the same cell as previous cell, just return, and not show it again
        return;
    }
    else {
        self.touchDownIndexPath = indexPath;
        [self.popoverView dismiss:NO];
    }

    if (indexPath) {
        CGRect rect = [emotionPage visibleCellRectInPageAtIndexPath:indexPath];
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            WCPopoverViewDescriptor *descriptor = [WCPopoverViewDescriptor new];
            descriptor.autoDismissAfterSeconds = 10000;
            descriptor.boxInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            descriptor.showDuration = 0.15;
            descriptor.dismissDuration = 0.1;
            
            CGPoint topMiddlePoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            CGPoint locationInWindow = [emotionPage convertPoint:topMiddlePoint toView:self.window];
            self.popoverView = [WCPopoverView showPopoverViewAtPoint:locationInWindow inView:self.window contentView:contentView descriptor:descriptor];
        }
        else {
            [self.popoverView dismiss:NO];
        }
    }
    else {
        [self.popoverView dismiss:NO];
    }
}

- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(id<WCEmotionGroupInfo>)groupInfo pressDownAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    contentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.6];
    WCEmotionItemModel *item = (WCEmotionItemModel *)groupInfo.groupData[indexPath.section][indexPath.item];
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
    contentView.image = [UIImage imageNamed:imagePath];
    
    if (NSIndexPathEqualToIndexPath(self.touchDownIndexPath, indexPath) && !self.popoverView.hidden) {
        // Note: touch down the same cell as previous cell, just return, and not show it again
        return;
    }
    else {
        self.touchDownIndexPath = indexPath;
        [self.popoverView dismiss:NO];
    }
    
    if (indexPath) {
        CGRect rect = [emotionPage visibleCellRectInPageAtIndexPath:indexPath];
        if (!CGRectEqualToRect(rect, CGRectZero)) {
            WCPopoverViewDescriptor *descriptor = [WCPopoverViewDescriptor new];
            descriptor.autoDismissAfterSeconds = 0;
            descriptor.boxInsets = UIEdgeInsetsMake(5, 5, 5, 5);
            descriptor.showDuration = 0.15;
            descriptor.dismissDuration = 0.1;
            
            CGPoint topMiddlePoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            CGPoint locationInWindow = [emotionPage convertPoint:topMiddlePoint toView:self.window];
            self.popoverView = [WCPopoverView showPopoverViewAtPoint:locationInWindow inView:self.window contentView:contentView descriptor:descriptor];
        }
        else {
            [self.popoverView dismiss:NO];
        }
    }
    else {
        [self.popoverView dismiss:NO];
    }
}

- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(id<WCEmotionGroupInfo>)groupInfo pressUpAtIndexPath:(NSIndexPath *)indexPath {
    [self.popoverView dismiss:YES];
}

#pragma mark - WCHorizontalSliderViewDelegate

- (void)WCEmotionSliderView:(WCHorizontalSliderView *)emotionSliderView didSelectItem:(id<WCHorizontalSliderItem>)item atIndex:(NSInteger)index {
}

- (BOOL)WCEmotionSliderView:(WCHorizontalSliderView *)emotionSliderView shouldSelectItem:(id<WCHorizontalSliderItem>)item atIndex:(NSInteger)index {
    if (index == 0) {
        return NO;
    }
    return YES;
}

@end
