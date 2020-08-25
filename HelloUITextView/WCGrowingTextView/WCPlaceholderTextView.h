//
//  WCPlaceholderTextView.h
//  HelloUITextView
//
//  Created by wesley_chen on 2020/8/24.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCPlaceholderTextView : UITextView
@property (nonatomic, assign, readonly) BOOL isEmpty;
@property (nonatomic, copy) NSString *placeholder;
@property (nonatomic, copy) UIColor *placeholderColor;
@property (nonatomic, copy, nullable) NSAttributedString *attributedPlaceholder;

- (instancetype)initWithFrame:(CGRect)frame;
- (instancetype)initWithFrame:(CGRect)frame textContainer:(nullable NSTextContainer *)textContainer;

@end

NS_ASSUME_NONNULL_END
