//
//  ContentView.m
//  HelloUIScrollView
//
//  Created by wesley_chen on 2019/12/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "ContentView.h"

@interface ContentView ()
@property (nonatomic, strong) UILabel *labelAtTop;
@property (nonatomic, strong) UILabel *labelAtLeft;
@property (nonatomic, strong) UILabel *labelAtBottom;
@property (nonatomic, strong) UILabel *labelAtRight;
@end

@implementation ContentView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        UILabel *labelAtTop = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        labelAtTop.text = @"top";
        labelAtTop.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtTop.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelAtTop];
        _labelAtTop = labelAtTop;
        
        UILabel *labelAtBottom = [[UILabel alloc] initWithFrame:CGRectMake(0, frame.size.height - 30, frame.size.width, 30)];
        labelAtBottom.text = @"bottom";
        labelAtBottom.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtBottom.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelAtBottom];
        _labelAtBottom = labelAtBottom;
        
        UILabel *labelAtLeft = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, frame.size.height)];
        labelAtLeft.text = @"left";
        labelAtLeft.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtLeft.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelAtLeft];
        _labelAtLeft = labelAtLeft;
        
        UILabel *labelAtRight = [[UILabel alloc] initWithFrame:CGRectMake(frame.size.width - 40, 0, 40, frame.size.height)];
        labelAtRight.text = @"right";
        labelAtRight.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.5];
        labelAtRight.textAlignment = NSTextAlignmentCenter;
        [self addSubview:labelAtRight];
        _labelAtRight = labelAtRight;
    }
    return self;
}

@end
