//
//  DottedLineViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/7/1.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "DottedLineViewViewController.h"
#import "WCDashLineView.h"

@interface DottedLineViewViewController ()

@end

@implementation DottedLineViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CGFloat spaceV = 15;
    
    // Horizontal lines
    WCDashLineView *lineH1_1dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, 70, screenSize.width - 2 * 10, 10)];
    lineH1_1dp.horizontal = YES;
    lineH1_1dp.lineThickness = 1;
    lineH1_1dp.lineColor = [UIColor redColor];
    lineH1_1dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH1_1dp];
    
    WCDashLineView *lineH2_1px = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH1_1dp.frame) + spaceV, screenSize.width - 2 * 10, 10)];
    lineH2_1px.horizontal = YES;
    lineH2_1px.lineThickness = 1.0 / [UIScreen mainScreen].scale;
    lineH2_1px.lineColor = [UIColor redColor];
    lineH2_1px.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH2_1px];

    WCDashLineView *lineH3_1dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH2_1px.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH3_1dp.horizontal = YES;
    lineH3_1dp.lineThickness = 1.0;
    lineH3_1dp.lineColor = [UIColor redColor];
    lineH3_1dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH3_1dp];

    WCDashLineView *lineH4_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH3_1dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH4_5dp.horizontal = YES;
    lineH4_5dp.lineThickness = 5.0;
    lineH4_5dp.lineColor = [UIColor redColor];
    lineH4_5dp.dashPattern = @[ @(2), @(3) ];
    lineH4_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH4_5dp];
    
    WCDashLineView *lineH5_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH4_5dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH5_5dp.horizontal = YES;
    lineH5_5dp.lineThickness = 5.0;
    lineH5_5dp.lineColor = [UIColor redColor];
    lineH5_5dp.dashPattern = @[ @(10), @(5), @(5), @(5) ];
    lineH5_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH5_5dp];
    
    WCDashLineView *lineH6_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH5_5dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH6_5dp.horizontal = YES;
    lineH6_5dp.lineThickness = 5.0;
    lineH6_5dp.lineColor = [UIColor redColor];
    lineH6_5dp.dashPattern = @[ @(10), @(5), @(5), @(5) ];
    lineH6_5dp.dashPatternOffset = 10;
    lineH6_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH6_5dp];
    
    WCDashLineView *lineH7_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH6_5dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH7_5dp.horizontal = YES;
    lineH7_5dp.lineThickness = 5.0;
    lineH7_5dp.lineColor = [UIColor redColor];
    lineH7_5dp.dashPattern = @[ @(10), @(5), @(5), @(5) ];
    lineH7_5dp.dashPatternOffset = 15;
    lineH7_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH7_5dp];

    WCDashLineView *lineH8_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH7_5dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH8_5dp.horizontal = YES;
    lineH8_5dp.lineThickness = 5.0;
    lineH8_5dp.dotRounded = YES;
    lineH8_5dp.lineColor = [UIColor redColor];
    lineH8_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH8_5dp];
    
    WCDashLineView *lineH9_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH8_5dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH9_5dp.horizontal = YES;
    lineH9_5dp.lineThickness = 5.0;
    lineH9_5dp.lineColor = [UIColor redColor];
    lineH9_5dp.dotRounded = YES;
    lineH9_5dp.roundDotGap = lineH9_5dp.lineThickness / 2.0;
    lineH9_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH9_5dp];
    
    WCDashLineView *lineH10_5dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH9_5dp.frame) + spaceV, screenSize.width - 2 * 10, 1.0)];
    lineH10_5dp.horizontal = YES;
    lineH10_5dp.lineThickness = 5.0;
    lineH10_5dp.lineColor = [UIColor redColor];
    lineH10_5dp.dotRounded = YES;
    lineH10_5dp.roundDotGap = 5.0;
    lineH10_5dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineH10_5dp];
    
    // Vertical lines
    CGFloat lengthV = 300;
    CGFloat spaceH = 15;
    
    WCDashLineView *lineV1_1dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(10, CGRectGetMaxY(lineH10_5dp.frame) + spaceV, 10, lengthV)];
    lineV1_1dp.horizontal = NO;
    lineV1_1dp.lineThickness = 1;
    lineV1_1dp.lineColor = [UIColor redColor];
    lineV1_1dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineV1_1dp];
    
    WCDashLineView *lineV2_1px = [[WCDashLineView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineV1_1dp.frame) + spaceH, CGRectGetMinY(lineV1_1dp.frame), 10, lengthV)];
    lineV2_1px.horizontal = NO;
    lineV2_1px.lineThickness = 1.0 / [UIScreen mainScreen].scale;
    lineV2_1px.lineColor = [UIColor redColor];
    lineV2_1px.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineV2_1px];
    
    WCDashLineView *lineV3_1dp = [[WCDashLineView alloc] initWithFrame:CGRectMake(CGRectGetMaxX(lineV2_1px.frame) + spaceH, CGRectGetMinY(lineV1_1dp.frame), 1.0, lengthV)];
    lineV3_1dp.horizontal = NO;
    lineV3_1dp.lineThickness = 1.0;
    lineV3_1dp.lineColor = [UIColor redColor];
    lineV3_1dp.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.5];
    [self.view addSubview:lineV3_1dp];
}

@end
