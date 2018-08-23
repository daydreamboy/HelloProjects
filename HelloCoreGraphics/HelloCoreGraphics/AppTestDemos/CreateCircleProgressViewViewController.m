//
//  CreateCircleProgressViewViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2018/7/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "CreateCircleProgressViewViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "WCCirlcleProgressView.h"

#define degreesToRadians( degrees ) ( ( degrees ) / 180.0 * M_PI )

@interface CreateCircleProgressViewViewController ()
{
    CGRect drawbox;
}
@property (nonatomic, strong) IBOutlet CircleView *cv;
@property (nonatomic, strong) UIBezierPath *circlePath;
@end

@implementation CreateCircleProgressViewViewController

// @see https://www.quora.com/How-do-I-create-a-circle-with-a-fill-in-by-percentage-in-Objective-C
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.cv];
    [self drawCircle];
    [self.cv drawLineWithPath:self.circlePath];
}

#pragma mark - Getters

- (CircleView *)cv {
    if (!_cv) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CircleView *view = [[CircleView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        _cv = view;
    }
    
    return _cv;
}

-(void)drawCircle {
    CGFloat start = degreesToRadians(270);
    CGFloat end = degreesToRadians(630);
    CGPoint origin = CGPointMake(self.cv.frame.origin.x+4, self.cv.frame.origin.y+4);
    drawbox = CGRectMake(origin.x, origin.y, self.cv.frame.size.width-2, self.cv.frame.size.height-2);
    CGPoint midPoint = CGPointMake(CGRectGetWidth(drawbox)/2, CGRectGetWidth(drawbox)/2);
    CGFloat lineWidth = (CGRectGetWidth(drawbox)/2)*0.25;
    CGFloat radius = (CGRectGetWidth(drawbox)/2)-lineWidth/2-2;
    self.circlePath = [UIBezierPath bezierPathWithArcCenter:midPoint radius:radius startAngle:start endAngle:end clockwise:true];
    self.circlePath.lineWidth = lineWidth;
}

@end
