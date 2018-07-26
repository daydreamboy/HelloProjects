//
//  WCHorizontalSliderView.h
//  WCEmotionPanelView
//
//  Created by wesley_chen on 2018/6/9.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol WCHorizontalSliderItem <NSObject>

#define WCHorizontalSliderItemPropertiesImpl \
@synthesize width; \
@synthesize iconURL; \
@synthesize iconSize; \
@synthesize extraData;

@required

/**
 The width of slider item
 */
@property (nonatomic, assign) CGFloat width;

/**
 The icon of local file URL
 */
@property (nonatomic, strong) NSURL *iconURL;

/**
 The icon size. If it's CGSizeZero, use image's size instead
 */
@property (nonatomic, assign) CGSize iconSize;

@optional

/**
 The custom data for the item, this propertiy not used by slider view
 */
@property (nonatomic, strong) NSMutableDictionary *extraData;

@end

@class WCHorizontalSliderView;

@protocol WCHorizontalSliderViewDelegate <NSObject>
- (void)WCEmotionSliderView:(WCHorizontalSliderView *)emotionSliderView didSelectItem:(id<WCHorizontalSliderItem>)item atIndex:(NSInteger)index;
- (BOOL)WCEmotionSliderView:(WCHorizontalSliderView *)emotionSliderView shouldSelectItem:(id<WCHorizontalSliderItem>)item atIndex:(NSInteger)index;
@end

@protocol WCHorizontalSliderViewDataSource <NSObject>
@required
@end

@interface WCHorizontalSliderView : UIView

@property (nonatomic, strong) NSArray<id<WCHorizontalSliderItem>> *sliderData;
@property (nonatomic, weak) id<WCHorizontalSliderViewDelegate> delegate;

/**
 The separators between pages. If zero or negative, there are no separators.
 
 Default is 0.
 */
@property (nonatomic, assign) CGFloat separatorWidth;

/**
 The color of separators
 
 Default is [UIColor lightGrayColor]
 */
@property (nonatomic, strong) UIColor *separatorColor;

/**
 The background color when item selected. Set nil for clear color
 
 Default is [UIColor lightGrayColor], same as separatorColor
 */
@property (nonatomic, strong) UIColor *itemSelectedColor;

/**
 The background color when item unselected. Set nil for clear color
 
 Default is [UIColor whiteColor]
 */
@property (nonatomic, strong) UIColor *itemNormalColor;

/**
 Auto scroll the item partially showed to full visible when selected
 
 Default is YES
 */
@property (nonatomic, assign) BOOL autoScrollItemToFullVisbleWhenSelected;

/**
 Refresh view after changing the sliderData
 */
- (void)reloadData;

/**
 Select the item and scroll it to visible

 @param index the index of the item
 */
- (void)selectItemAtIndex:(NSInteger)index;

- (void)scrollItemToVisibleForIndex:(NSInteger)index animated:(BOOL)animated;

@end

NS_ASSUME_NONNULL_END
