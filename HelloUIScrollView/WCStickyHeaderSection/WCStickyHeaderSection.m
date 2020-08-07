//
//  WCStickyHeaderSection.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickyHeaderSection.h"

@interface WCStickyHeaderSection ()
@property (nonatomic, assign, readwrite) CGFloat initialY;
@property (nonatomic, assign, readwrite) CGFloat fixedY;
@property (nonatomic, assign, readwrite) CGFloat height;
@end

@implementation WCStickyHeaderSection

- (instancetype)initWithInitialY:(CGFloat)initialY fixed:(CGFloat)fixedY height:(CGFloat)height {
    self = [super initWithFrame:CGRectMake(0, initialY, 0, height)];
    if (self) {
        _sticky = YES;
        _initialY = initialY;
        _fixedY = fixedY;
        _height = height;
    }
    return self;
}

- (void)didMoveToSuperview {
    if (self.superview) {
        // add to superview
        self.frame = CGRectMake(0, self.initialY, CGRectGetWidth(self.superview.bounds), self.height);
    }
    else {
        // remove to superview
    }
}

@end
