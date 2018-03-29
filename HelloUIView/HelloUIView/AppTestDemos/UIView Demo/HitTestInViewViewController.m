//
//  HitTestInViewViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 09/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "HitTestInViewViewController.h"

@interface TapHandler : NSObject
@end

@implementation TapHandler
- (void)dealloc {
    NSLog(@"dealloc");
}
@end

@interface SuperView : UIView
@end

@implementation SuperView

// Note: 关于Hit Test机制
// Hit Test机制，利用UIView的hitTest:withEvent:和pointInside:withEvent:方法，用于确定视图层级（View Hierarchy）中哪个UIView接收touch事件
// 官方文档说明，在- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event;方法上


// Note: hitTest:withEvent:方法会用pointInside:withEvent:方法，测试当前UIView所有子view，如果某个子view的pointInside:withEvent:方法返回YES，则它的hitTest:withEvent:被调用，然后这样迭代去查找front-most view

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    return [super hitTest:point withEvent:event];
}

// Note: pointInside:withEvent:总是会被hitTest:withEvent:调用，该方法主要判断touch point是否落入当前view中
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    return YES;
}

@end

@interface ChildView : UIView
@end

@implementation ChildView
- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        __unused TapHandler *handler = [TapHandler new];
        
        // Note: UITapGestureRecognizer hold self as weak
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
        [self addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)viewTapped:(UITapGestureRecognizer *)recognizer {
    UIView *tappedView = recognizer.view;
    if (tappedView == self) {
        NSLog(@"view tapped");
    }
}

@end

@interface HitTestInViewViewController ()

@end

@implementation HitTestInViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    SuperView *superView = [[SuperView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    superView.backgroundColor = [[UIColor greenColor] colorWithAlphaComponent:0.8];
    superView.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    
    ChildView *childView = [[ChildView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    childView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.6];
    
    [superView addSubview:childView];
    [self.view addSubview:superView];
}

@end
