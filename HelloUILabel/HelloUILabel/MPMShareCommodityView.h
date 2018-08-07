//
//  MPMShareCommodityView.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMShareCommodityView : UIView
@property (nonatomic, strong) UIImageView *imageViewCommodityPreview;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSubtitle;
@property (nonatomic, strong) UILabel *labelPrice;
@property (nonatomic, strong) UILabel *labelNumberOfOrders;
@property (nonatomic, strong) UIButton *buttonLeft;
@property (nonatomic, strong) UIButton *buttonRight;
@property (nonatomic, strong) UIImageView *imageViewSourceIcon;
@property (nonatomic, strong) UILabel *labelSourceTitle;
@property (nonatomic, strong) UIImageView *imageViewCoupon;
@property (nonatomic, strong) UILabel *labelSourceSubtitle; // on the right
@property (nonatomic, strong) UIImageView *imageViewStamp;
@end
