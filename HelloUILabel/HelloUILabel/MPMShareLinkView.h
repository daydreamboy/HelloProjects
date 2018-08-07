//
//  MPMShareLinkView.h
//  HelloUILabel
//
//  Created by wesley_chen on 2018/8/6.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MPMShareLinkView : UIView

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subtitle;
@property (nonatomic, strong) UIColor *subtitleColor;
@property (nonatomic, assign) NSInteger numberOfLinesForTitle;
@property (nonatomic, strong) NSString *sourceTitle;
@property (nonatomic, assign) BOOL imageViewPreviewHidden;

@property (nonatomic, strong) UIImageView *imageViewPreview;
@property (nonatomic, strong) UILabel *labelTitle;
@property (nonatomic, strong) UILabel *labelSubtitle;
@property (nonatomic, strong) UIImageView *imageViewSourceIcon;
@property (nonatomic, strong) UILabel *labelSourceTitle;
@property (nonatomic, strong) UILabel *labelSourceSubtitle; // on the right
@property (nonatomic, strong) UIImageView *imageViewStamp;
@end
