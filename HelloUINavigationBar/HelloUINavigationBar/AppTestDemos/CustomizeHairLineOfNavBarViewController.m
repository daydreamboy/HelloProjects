//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "CustomizeHairLineOfNavBarViewController.h"
#import <objc/runtime.h>

#ifndef SYSTEM_VERSION_LESS_THAN
#define SYSTEM_VERSION_LESS_THAN(v)                ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)
#endif

@interface UINavigationBar (Addition)
@property (nonatomic, strong) UIView *hairLine;
@end

@implementation UINavigationBar (Addition)
@dynamic hairLine;

- (void)setHairLine:(UIView *)hairLine {
    objc_setAssociatedObject(self, @selector(hairLine), hairLine, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (UIView *)hairLine {
    return (UIView *)objc_getAssociatedObject(self, @selector(hairLine));
}

@end

@implementation UIImage (ColorImage)
+ (UIImage *)imageWithColor:(UIColor *)color{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f / [UIScreen mainScreen].scale);
//    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 10.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
@end

@interface CustomizeHairLineOfNavBarViewController ()

@end

@implementation CustomizeHairLineOfNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    
    if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
        UIImageView *shadowImageView = [self findShadowImageViewWithView:navigationBar];
        if (shadowImageView) {
            UIView *line = [[UIView alloc] initWithFrame:shadowImageView.bounds];
            line.backgroundColor = [UIColor redColor];
            [shadowImageView addSubview:line];
            navigationBar.hairLine = line;
        }
        else {
            NSLog(@"not found shadowImageView");
        }
//        [navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    }
    else {
        [navigationBar setShadowImage:[UIImage imageWithColor:[UIColor redColor]]];
    }
}

- (UIImageView *)findShadowImageViewWithView:(UIView *)view {
    if ([view isKindOfClass:[UIImageView class]] && view.bounds.size.height <= 1) {
        return (UIImageView *)view;
    }
    
    for (UIView *subview in [view subviews]) {
        return [self findShadowImageViewWithView:subview];
    }
    
    return nil;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    if (SYSTEM_VERSION_LESS_THAN(@"11.0")) {
        [navigationBar.hairLine removeFromSuperview];
    }
    else {
        navigationBar.shadowImage = nil;
    }
}

@end
