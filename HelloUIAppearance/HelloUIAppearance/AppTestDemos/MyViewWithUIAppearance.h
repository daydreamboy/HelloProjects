//
//  MyViewWithUIAppearance.h
//  HelloUIAppearance
//
//  Created by wesley_chen on 2018/7/3.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyViewWithUIAppearance : UIView
// UI_APPEARANCE_SELECTOR just indicate, ommit it also work
@property (nonatomic, strong) UIColor *myBackgroundColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor *myBorderColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, assign) CGFloat myBorderWidth UI_APPEARANCE_SELECTOR;
@end
