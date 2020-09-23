//
//  WCMessageComposerView.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCMessageInputItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCMessageComposerView : UIView

@property (nonatomic, assign) UIEdgeInsets contentInsets;
@property (nonatomic, assign) UIEdgeInsets textInputViewMargins;
@property (nonatomic, assign) CGFloat spaceBetweenOutterItems;
@property (nonatomic, assign) CGFloat spaceBetweenInnerItems;

- (void)addMessageInputItem:(WCMessageInputItem *)item;

@end

NS_ASSUME_NONNULL_END
