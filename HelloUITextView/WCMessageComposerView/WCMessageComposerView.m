//
//  WCMessageComposerView.m
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCMessageComposerView.h"
#import "WCGrowingTextView.h"

@interface WCMessageComposerView ()
@property (nonatomic, strong) WCGrowingTextView *textInputView;
@property (nonatomic, strong) UIView *textInputBackgroundView;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *leftItems;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *leftInItems;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *rightInItems;
@property (nonatomic, strong) NSMutableArray<WCMessageInputItem *> *rightItems;

@property (nonatomic, strong) NSMutableArray<UIView *> *leftViews;
@property (nonatomic, strong) NSMutableArray<UIView *> *leftInViews;
@property (nonatomic, strong) NSMutableArray<UIView *> *rightInViews;
@property (nonatomic, strong) NSMutableArray<UIView *> *rightViews;

@property (nonatomic, copy) NSComparisonResult (^itemsComparatorBlock)(WCMessageInputItem *item1, WCMessageInputItem *item2);
@end

@implementation WCMessageComposerView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _contentInsets = UIEdgeInsetsMake(11, 10, 11, 10);
        _textInputViewMargins = UIEdgeInsetsMake(-3, 10, -3, 10);
        
        _leftItems = [NSMutableArray array];
        _leftInItems = [NSMutableArray array];
        _rightItems = [NSMutableArray array];
        _rightInItems = [NSMutableArray array];
        
        _leftViews = [NSMutableArray array];
        _leftInViews = [NSMutableArray array];
        _rightInViews = [NSMutableArray array];
        _rightViews = [NSMutableArray array];
        _itemsComparatorBlock = ^NSComparisonResult(WCMessageInputItem *item1, WCMessageInputItem *item2) {
            if (item1.order < item2.order) {
                return NSOrderedAscending;
            }
            else if (item1.order > item2.order) {
                return NSOrderedDescending;
            }
            else {
                return NSOrderedSame;
            }
        };
    }
    return self;
}

- (void)addMessageInputItem:(WCMessageInputItem *)item {
    switch (item.type) {
        case WCMessageInputItemPositionLeft: {
            [self.leftItems addObject:item];
            [self.leftItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        case WCMessageInputItemPositionLeftIn: {
            [self.leftInItems addObject:item];
            [self.leftInItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        case WCMessageInputItemPositionRight: {
            [self.rightItems addObject:item];
            [self.rightItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        case WCMessageInputItemPositionRightIn: {
            [self.rightInItems addObject:item];
            [self.rightInItems sortUsingComparator:self.itemsComparatorBlock];
            break;
        }
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.leftViews removeAllObjects];
    [self.leftInViews removeAllObjects];
    [self.rightViews removeAllObjects];
    [self.rightInViews removeAllObjects];
    
    [self.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    for (WCMessageInputItem *item in self.leftItems) {
        
    }
}

- (UIView *)inputItemViewWithItem:(WCMessageInputItem *)item {
    UIView *itemView = nil;
    switch (item.type) {
        case WCMessageInputItemTypeText: {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
            button.titleLabel.font = item.titleFont;
            [button setTitle:item.title forState:UIControlStateNormal];
            [button setTitle:item.titleSelected ? item.titleSelected : item.title forState:UIControlStateSelected];
            [button sizeToFit];
            itemView = button;
            break;
        }
        case WCMessageInputItemTypeLocalImage: {
            
            break;
        }
        case WCMessageInputItemTypeRemoteImage: {
            
            break;
        }
        case WCMessageInputItemTypeCustomView: {
            
            break;
        }
    }
    
    return itemView;
}

@end
