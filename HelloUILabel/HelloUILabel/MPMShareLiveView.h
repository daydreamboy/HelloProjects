//
//  MPMShareLiveView.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMShareLiveView : UIView

@property (nonatomic, copy) NSString *title;
@property (nonatomic, copy) NSString *sourceTitle;
@property (nonatomic, copy) NSString *playbackTitle;

@property (nonatomic, strong) UIImageView *imageViewPreview;
@property (nonatomic, strong) UIButton *buttonPlay;
@property (nonatomic, strong) UIView *viewMaskedGradient;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIImageView *imageViewSourceIcon;
@property (nonatomic, strong) UILabel *labelSourceTitle;
@property (nonatomic, strong) UIImageView *imageViewAvatar;
@property (nonatomic, strong) UIButton *buttonPlayback;
@property (nonatomic, strong) UILabel *labelAvatarName;
@end
