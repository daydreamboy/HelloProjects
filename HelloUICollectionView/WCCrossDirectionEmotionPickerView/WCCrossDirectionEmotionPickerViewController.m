//
//  WCCrossDirectionEmotionPickerViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/11.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#define sliderViewHeight 34
#define pickerViewHeight (216 - 34)

#import "WCCrossDirectionEmotionPickerViewController.h"
#import "WCHorizontalPageBrowserView.h"

@interface WCCrossDirectionEmotionPickerViewController () <WCHorizontalPageBrowserViewDataSource, WCHorizontalPageBrowserViewDelegate>
@property (nonatomic, strong) WCHorizontalPageBrowserView *pickerView;
@property (nonatomic, strong) WCHorizontalPageBrowserView *sliderView;
@end

@implementation WCCrossDirectionEmotionPickerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    self.view.frame = CGRectMake(0, 0, screenSize.width, 216);
    [self.view addSubview:self.sliderView];
}

#pragma mark - Getters

- (WCHorizontalPageBrowserView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, pickerViewHeight)];
        
        _pickerView = view;
    }
    
    return _pickerView;
}

- (WCHorizontalPageBrowserView *)sliderView {
    if (!_sliderView) {
        CGFloat paddingH = 20;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        WCHorizontalPageBrowserView *view = [[WCHorizontalPageBrowserView alloc] initWithFrame:CGRectMake(paddingH, 100, screenSize.width  - 2 * paddingH, sliderViewHeight)];
        view.delegate = self;
        view.dataSource = self;
//        view.pagable = YES;
//        view.pageSpace = 0;
        
        //[view registerPageClass:[WCBaseHorizontalPage class] forPageWithReuseIdentifier:NSStringFromClass([WCBaseHorizontalPage class])];
        
        _sliderView = view;
    }
    
    return _sliderView;
}


#pragma mark - WCHorizontalPageBrowserViewDataSource

- (NSInteger)numberOfPagesHorizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView {
    return 10;
}

- (WCBaseHorizontalPage *)horizontalPageBrowserView:(WCHorizontalPageBrowserView *)horizontalPageBrowserView pageForItemAtIndex:(NSInteger)index {
    WCBaseHorizontalPage *page = [horizontalPageBrowserView dequeueReusablePageWithReuseIdentifier:NSStringFromClass([WCBaseHorizontalPage class]) forIndex:index];
    
    return page;
}

@end
