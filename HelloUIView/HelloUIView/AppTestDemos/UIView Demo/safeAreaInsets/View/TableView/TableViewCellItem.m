//
//  TableViewCellItem.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/11/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "TableViewCellItem.h"

@implementation TableViewCellItem

- (instancetype)initWithTitle:(NSString *)title enabled:(BOOL)enabled switchable:(BOOL)switchable custom:(BOOL)custom height:(CGFloat)height handler:(Handler)handler {
    self = [super init];
    
    if (self) {
        _title = title;
        _enabled = enabled;
        _switchable = switchable;
        _custom = custom;
        _height = height == 0 ? 44 : height;
        _handler = handler;
    }
    
    return self;
}

@end
