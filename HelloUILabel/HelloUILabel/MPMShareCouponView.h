//
//  MPMShareCouponView.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMShareCouponView : UIView
@property (nonatomic, strong) UIImageView *imageViewBackground;
@property (nonatomic, strong) UIImageView *imageViewIcon;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSubtitle;
@property (nonatomic, strong) UIView *viewFooter;
@property (nonatomic, strong) UIImageView *imageViewSourceIcon;
@property (nonatomic, strong) UILabel *labelSourceTitle;
@property (nonatomic, strong) UIView *viewMaskSelected;
@end
