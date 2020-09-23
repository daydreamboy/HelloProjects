//
//  WCMessageInputItem.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMessageInputItem.h"
#import "WCMacroTool.h"
#import "WCStringTool.h"

#define kInputItemIconSide 30

@interface WCMessageInputItem ()
@property (nonatomic, assign, readwrite) WCMessageInputItemType type;
@property (nonatomic, assign, readwrite) WCMessageInputItemPosition position;
@property (nonatomic, assign, readwrite) NSInteger order;
@property (nonatomic, assign, readwrite) BOOL showRedPoint;
@property (nonatomic, copy, readwrite) NSString *actionName;
@property (nonatomic, copy, readwrite, nullable) NSString *actionUrl;
@property (nonatomic, assign, readwrite) BOOL placeAtTop;
@property (nonatomic, assign, readwrite) CGFloat width;
@property (nonatomic, assign, readwrite) CGFloat height;
#pragma mark - Text
@property (nonatomic, copy, readwrite) NSString *title;
/// String Value: #RRGGBB / #RRGGBBAA
@property (nonatomic, strong, readwrite) UIColor *titleColor;
@property (nonatomic, assign, readwrite) CGFloat titleFontSize;
@property (nonatomic, strong, readwrite) UIFont *titleFont;
@property (nonatomic, copy, readwrite, nullable) NSString *titleSelected;
@property (nonatomic, strong, readwrite, nullable) UIColor *titleColorSelected;
#pragma mark - Local Image
@property (nonatomic, copy, readwrite) NSString *iconName;
@property (nonatomic, copy, readwrite) NSString *iconNameSelected;
#pragma mark - Remote Image
@property (nonatomic, copy, readwrite) NSString *iconUrl;
@property (nonatomic, copy, readwrite) NSString *iconUrlSelected;

#pragma mark - Extra non-keyed properties
@property (nonatomic, assign, readwrite) CGSize size;
/// Customized View
@property (nonatomic, strong, readwrite, nullable) UIView *customView;
@property (nonatomic, strong, readwrite, nullable) UIImage *iconImage;
@property (nonatomic, strong, readwrite, nullable) UIImage *iconImageSelected;

@end

@implementation WCMessageInputItem

- (instancetype)initWithDict:(NSDictionary *)dict {
    self = [super init];
    if (self) {
        // Default values
        _width = kInputItemIconSide;
        _height = kInputItemIconSide;
        _size = CGSizeMake(_width, _height);
        
        [self updateWithDict:dict];
    }
    return self;
}

- (void)updateWithDict:(NSDictionary *)dict {
    if (!DICT_IF_NOT_EMPTY(dict)) {
        return;
    }
    
    _type = intValueOfJSONValue(dict[STR_OF_PROP(type)]);
    _position = intValueOfJSONValue(dict[STR_OF_PROP(position)]);
    _order = intValueOfJSONValue(dict[STR_OF_PROP(order)]);
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(showRedPoint)])) {
        _showRedPoint = boolValueOfJSONValue(dict[STR_OF_PROP(showRedPoint)]);
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(actionName)])) {
        _actionName = dict[STR_OF_PROP(actionName)];
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(actionUrl)])) {
        _actionUrl = dict[STR_OF_PROP(actionUrl)];
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(placeAtTop)])) {
        _placeAtTop = boolValueOfJSONValue(dict[STR_OF_PROP(placeAtTop)]);
    }
    
    CGFloat width = doubleValueOfJSONValue(dict[STR_OF_PROP(width)]);
    CGFloat height = doubleValueOfJSONValue(dict[STR_OF_PROP(height)]);
    
    if (width > 0 && height > 0) {
        _width = width;
        _height = height;
        _size = CGSizeMake(width, height);
    }
    
    if (STR_IF_NOT_EMPTY(dict[STR_OF_PROP(title)])) {
        _title = dict[STR_OF_PROP(title)];
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(titleColor)])) {
        UIColor *color = [WCStringTool colorFromHexString:dict[STR_OF_PROP(titleColor)]];
        if (color) {
            _titleColor = color;
        }
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(titleFontSize)])) {
        CGFloat fontSize = doubleValueOfJSONValue(dict[STR_OF_PROP(titleFontSize)]);
        if (fontSize > 0) {
            _titleFontSize = fontSize;
            _titleFont = [UIFont systemFontOfSize:_titleFontSize];
        }
    }
    
    if (STR_IF_NOT_EMPTY(dict[STR_OF_PROP(titleSelected)])) {
        _titleSelected = dict[STR_OF_PROP(titleSelected)];
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(titleColorSelected)])) {
        UIColor *color = [WCStringTool colorFromHexString:dict[STR_OF_PROP(titleColorSelected)]];
        if (color) {
            _titleColorSelected = color;
        }
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(iconName)])) {
        _iconName = dict[STR_OF_PROP(iconName)];
        _iconImage = [UIImage imageNamed:_iconName];
    }
    
    if (STR_TRIM_IF_NOT_EMPTY(dict[STR_OF_PROP(iconNameSelected)])) {
        _iconNameSelected = dict[STR_OF_PROP(iconNameSelected)];
        _iconImageSelected = [UIImage imageNamed:_iconNameSelected];
    }
    
    if (STR_IF_NOT_EMPTY(dict[STR_OF_PROP(iconUrl)])) {
        _iconUrl = dict[STR_OF_PROP(iconUrl)];
    }
    
    if (STR_IF_NOT_EMPTY(dict[STR_OF_PROP(iconUrlSelected)])) {
        _iconUrlSelected = dict[STR_OF_PROP(iconUrlSelected)];
    }
    
    UIView *customView = dict[STR_OF_PROP(customView)];
    if ([customView isKindOfClass:[UIView class]]) {
        _customView = customView;
    }
}

@end
