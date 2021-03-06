//
//  WCStickyHeaderSection+Internal.h
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickySection.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCStickySection ()
@property (nonatomic, assign) CGFloat initialY;
@property (nonatomic, assign) CGFloat fixedY;
@property (nonatomic, assign, readwrite) CGFloat height;
@end

NS_ASSUME_NONNULL_END
