//
//  WCLinkLabel.h
//  HelloUILabel
//
//  Created by wesley_chen on 2020/11/2.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCLinkLabel : UILabel

@property (nonatomic, strong) UIColor *linkColor;
@property (nonatomic, strong) UIColor *linkBackgroundColor;
@property (nonatomic, assign) CGFloat linkBackgroundCornerRadius;
@property (nonatomic, copy) void (^linkTappedBlock)(NSString *linkString, NSRange linkRange);

@end

NS_ASSUME_NONNULL_END
