//
//  WCMessageInputItemView.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/9/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WCMessageInputItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCMessageInputItemView : UIButton

@property (nonatomic, assign) CGPoint origin;

- (instancetype)initWithItem:(WCMessageInputItem *)item;

@end

NS_ASSUME_NONNULL_END
