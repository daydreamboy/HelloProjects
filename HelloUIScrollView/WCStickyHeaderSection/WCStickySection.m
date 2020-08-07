//
//  WCStickySection.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2020/8/7.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStickySection.h"
#import "WCStickySection_Internal.h"

@interface WCStickySection ()
@property (nonatomic, assign, readwrite) CGFloat fixedY;
@property (nonatomic, assign, readwrite) CGFloat height;
@end

@implementation WCStickySection

- (instancetype)initWithFixed:(CGFloat)fixedY height:(CGFloat)height {
    self = [super initWithFrame:CGRectZero];
    if (self) {
        _sticky = YES;
        _fixedY = fixedY;
        _height = height;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<WCStickyHeaderSection: %p; frame = %@; layer = <CALayer: %p>; priority = %d; sticky = %@>", self, NSStringFromCGRect(self.frame), self.layer, (int)self.priority, self.sticky ? @"YES": @"NO"];
}

@end
