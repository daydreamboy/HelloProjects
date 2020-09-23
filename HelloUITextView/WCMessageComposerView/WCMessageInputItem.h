//
//  WCMessageInputItem.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSUInteger, WCMessageInputItemType) {
    /// Text (support IconFont)
    WCMessageInputItemTypeText,
    /// Local Image
    WCMessageInputItemTypeLocalImage,
    /// Remote Image
    WCMessageInputItemTypeRemoteImage,
    /// Customized View
    WCMessageInputItemTypeCustomView,
};

typedef NS_ENUM(NSUInteger, WCMessageInputItemPosition) {
    WCMessageInputItemPositionLeft,
    WCMessageInputItemPositionLeftIn,
    WCMessageInputItemPositionRightIn,
    WCMessageInputItemPositionRight,
};

@interface WCMessageInputItem : NSObject
@property (nonatomic, assign, readonly) WCMessageInputItemType type;
@property (nonatomic, assign, readonly) WCMessageInputItemPosition position;
@property (nonatomic, assign, readonly) NSInteger order;
@property (nonatomic, assign, readonly) BOOL showRedPoint;
@property (nonatomic, copy, readonly) NSString *actionName;
@property (nonatomic, copy, readonly, nullable) NSString *actionUrl;
@property (nonatomic, assign, readonly) BOOL placeAtTop;
@property (nonatomic, assign, readonly) CGFloat width;
@property (nonatomic, assign, readonly) CGFloat height;
#pragma mark - Text
@property (nonatomic, copy, readonly) NSString *title;
/// String Value: #RRGGBB / #RRGGBBAA
@property (nonatomic, strong, readonly) UIColor *titleColor;
@property (nonatomic, assign, readonly) CGFloat titleFontSize;
@property (nonatomic, copy, readonly, nullable) NSString *titleSelected;
@property (nonatomic, strong, readonly, nullable) UIColor *titleColorSelected;
#pragma mark - Local Image
@property (nonatomic, copy, readonly) NSString *iconName;
@property (nonatomic, copy, readonly) NSString *iconNameSelected;
#pragma mark - Remote Image
@property (nonatomic, copy, readonly) NSString *iconUrl;
@property (nonatomic, copy, readonly) NSString *iconUrlSelected;
#pragma mark - Customized View
@property (nonatomic, strong, readonly, nullable) UIView *customView;
#pragma mark - Extra non-keyed properties
@property (nonatomic, assign, readonly) CGSize size;
@property (nonatomic, strong, readonly) UIFont *titleFont;
@property (nonatomic, strong, readonly, nullable) UIImage *iconImage;
@property (nonatomic, strong, readonly, nullable) UIImage *iconImageSelected;

- (instancetype)init UNAVAILABLE_ATTRIBUTE;
+ (instancetype)new UNAVAILABLE_ATTRIBUTE;

- (instancetype)initWithDict:(NSDictionary *)dict;
- (void)updateWithDict:(NSDictionary *)dict;

@end

NS_ASSUME_NONNULL_END
