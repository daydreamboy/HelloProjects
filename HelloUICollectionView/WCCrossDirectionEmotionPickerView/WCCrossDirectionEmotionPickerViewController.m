//
//  WCCrossDirectionEmotionPickerViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCCrossDirectionEmotionPickerViewController.h"
#import "WCHorizontalPageBrowserView.h"
#import "WCEmotionVerticalLayoutPage.h"
#import "WCEmotionItemView.h"
#import "WCEmotionHeaderView.h"
#import "WCEmotionFooterView.h"
#import "MPMLightPopoverView.h"

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

@interface WCCrossDirectionEmotionPickerViewController () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate, WCEmotionVerticalPageDataSource, WCEmotionVerticalPageDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pickerView;
@property (nonatomic, strong) WCHorizontalPageBrowserView *sliderView;
@property (nonatomic, strong) NSArray<WCEmotionGroupInfo *> *emotionPageData;
@property (nonatomic, strong) MPMLightPopoverView *popoverView;
@property (nonatomic, strong) NSIndexPath *touchDownIndexPath;
@end

@implementation WCCrossDirectionEmotionPickerViewController

- (instancetype)init {
    self = [super init];
    if (self) {
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
        
        WCEmotionGroupInfo *group1 = [WCEmotionGroupInfo new];
        group1.groupData = @[
                             items,
                             items,
                             ];
        group1.itemViewClasses = @[[WCEmotionItemView class]];
        group1.headerViewClass = [WCEmotionHeaderView class];
        group1.footerViewClass = [WCEmotionFooterView class];
        
        WCEmotionGroupInfo *group2 = [WCEmotionGroupInfo new];
        group2.groupData = @[
                             items,
                             ];
        group2.itemViewClasses = @[[WCEmotionItemView class]];
        
        WCEmotionGroupInfo *group3 = [WCEmotionGroupInfo new];
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
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
//    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//    self.view.frame = CGRectMake(0, 0, screenSize.width, 216);
    
    [self.view addSubview:self.pickerView];
    [self.view addSubview:self.sliderView];
}

#pragma mark - Getters

- (WCHorizontalPageBrowserView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(0, 64 + 30, screenSize.width, pickerViewHeight)];
        view.dataSource = self;
        view.delegate = self;
        view.pageSpace = 0;
        view.separatorWidth = 30;
        view.pagable = NO;
        
        [view registerPageClass:[WCEmotionVerticalLayoutPage class] forPageWithReuseIdentifier:NSStringFromClass([WCEmotionVerticalLayoutPage class])];
        
//        [view registerPageClass:[UICollectionViewCell class] forPageWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class])];
        
        _pickerView = view;
    }
    
    return _pickerView;
}

//- (WCHorizontalPageBrowserView *)sliderView {
//    if (!_sliderView) {
//        CGFloat paddingH = 20;
//        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(paddingH, CGRectGetMaxY(self.pickerView.frame) + 20, screenSize.width  - 2 * paddingH, sliderViewHeight)];
//        view.delegate = self;
//        view.dataSource = self;
////        view.pagable = YES;
////        view.pageSpace = 0;
//
//        //[view registerPageClass:[WCBaseHorizontalPage class] forPageWithReuseIdentifier:NSStringFromClass([WCBaseHorizontalPage class])];
//
//        _sliderView = view;
//    }
//
//    return _sliderView;
//}


#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return self.emotionPageData.count;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index {
    WCBaseHorizontalPage *page;
    WCEmotionGroupInfo *item = self.emotionPageData[index];
    item.itemSize = CGSizeMake(horizontalPageBrowserView.bounds.size.width / 8.0, 40);
    
//    page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([UICollectionViewCell class]) forIndex:index];
    
    page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCEmotionVerticalLayoutPage class]) forIndex:index];
    WCEmotionVerticalLayoutPage *emotionPage = (WCEmotionVerticalLayoutPage *)page;
    emotionPage.dataSource = self;
    emotionPage.delegate = self;
    [emotionPage configurePage:item];
    page.backgroundColor = UICOLOR_randomColor;
    
    return page;
}

#pragma mark - WCEmotionVerticalPageDataSource

- (UICollectionViewCell *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage cellForGroupInfo:(WCEmotionGroupInfo *)groupInfo atIndexPath:(NSIndexPath *)indexPath {
    Class cellClass = groupInfo.itemViewClasses[0];
    
    WCEmotionItemView *cell = (WCEmotionItemView *)[emotionPage dequeueReusableCellWithReuseIdentifier:NSStringFromClass(cellClass) forIndexPath:indexPath];
    WCEmotionItemModel *item = (WCEmotionItemModel *)groupInfo.groupData[indexPath.section][indexPath.item];
    
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
    
    cell.imageView.image = [UIImage imageNamed:imagePath];
    cell.backgroundColor = UICOLOR_randomColor;
    
    return cell;
}

- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage headerViewForGroupInfo:(WCEmotionGroupInfo *)groupInfo atIndexPath:(NSIndexPath *)indexPath {
    WCEmotionHeaderView *header = (WCEmotionHeaderView *)[emotionPage dequeueReusableHeaderViewWithReuseIdentifier:NSStringFromClass([WCEmotionHeaderView class]) forIndexPath:indexPath];
    header.backgroundColor = [UIColor redColor];
    header.textLabel.text = (indexPath.section == 0) ? @"最近使用" : @"全部表情";
    
    return header;
}

- (UICollectionReusableView *)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage footerViewForGroupInfo:(WCEmotionGroupInfo *)groupInfo atIndexPath:(NSIndexPath *)indexPath {
    UICollectionReusableView *footer = [emotionPage dequeueReusableFooterViewWithReuseIdentifier:NSStringFromClass([WCEmotionFooterView class])  forIndexPath:indexPath];
    footer.backgroundColor = [UIColor blueColor];
    
    return footer;
}

- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfHeaderForGroupInfo:(WCEmotionGroupInfo *)groupInfo inSection:(NSInteger)section {
    return 30;
}

- (CGFloat)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage heightOfFooterForGroupInfo:(WCEmotionGroupInfo *)groupInfo inSection:(NSInteger)section {
    return 30;
}

#pragma mark - WCHorizontalPageBrowserViewDelegate

- (void)horizontalPageBrowserViewWillBeginDragging:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    [self.popoverView dismiss:YES];
}

#pragma mark - WCEmotionVerticalPageDelegate

- (void)WCEmotionVerticalPage:(WCEmotionVerticalLayoutPage *)emotionPage groupInfo:(WCEmotionGroupInfo *)groupInfo touchDownAtIndexPath:(NSIndexPath *)indexPath {
    UIImageView *contentView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    contentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.6];
    WCEmotionItemModel *item = (WCEmotionItemModel *)groupInfo.groupData[indexPath.section][indexPath.item];
    NSString *emotionBundlePath = [[NSBundle mainBundle].bundlePath stringByAppendingPathComponent:@"Emoticon.bundle"];
    NSString *imagePath = [emotionBundlePath stringByAppendingPathComponent:item.name];
    contentView.image = [UIImage imageNamed:imagePath];
    
    if ([self.touchDownIndexPath isEqual:indexPath] && !self.popoverView.hidden) {
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
            MPMLightPopoverViewDescriptor *descriptor = [MPMLightPopoverViewDescriptor new];
            descriptor.autoDismissAfterSeconds = 0.5;
            descriptor.boxPadding = 5;
            descriptor.showDuration = 0.15;
            descriptor.dismissDuration = 0.1;
            
            CGPoint topMiddlePoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
            CGPoint locationInWindow = [emotionPage convertPoint:topMiddlePoint toView:self.view.window];
            self.popoverView = [MPMLightPopoverView showAlwaysAbovePopoverAtPoint:locationInWindow inView:self.view.window withContentView:contentView withDescriptor:descriptor];
        }
        else {
            [self.popoverView dismiss:NO];
        }
    }
    else {
        [self.popoverView dismiss:NO];
    }
}

@end
