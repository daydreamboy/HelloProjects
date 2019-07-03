//
//  WCMenuItem+Internal.h
//  HelloUIResponder
//
//  Created by wesley_chen on 2019/7/3.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCMenuItem.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCMenuItem ()
@property (nonatomic, weak, readwrite, nullable) UIView *targetView;
@property (nonatomic, weak, readwrite, nullable) UIMenuController *menuController;
@end

NS_ASSUME_NONNULL_END
