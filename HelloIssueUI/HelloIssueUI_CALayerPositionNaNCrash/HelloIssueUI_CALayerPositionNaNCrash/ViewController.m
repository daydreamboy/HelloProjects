//
//  ViewController.m
//  HelloIssueUI_CALayerPositionNaNCrash
//
//  Created by wesley_chen on 2018/10/13.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
//    [self test_CALayer_position];
//    [self test_issue_of_CALayer_position];
//    [self test_CALayer_position_with_divide_zero];
//    [self test_CALayer_position_with_divide_zero2];
    [self test_CALayer_position_with_divide_zero3];
//    [self test_issue_of_UIView_frame];
}

- (void)test_CALayer_position {
    // Note: Center the layer in self.view
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    layer.position = CGPointMake(CGRectGetWidth(self.view.bounds) / 2.0, CGRectGetHeight(self.view.bounds) / 2.0);
    
    [self.view.layer addSublayer:layer];
}

- (void)test_CALayer_position_with_divide_zero {
    // Note: Center the layer in self.view
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    // Ok, not crash
    // Note: CGRectGetWidth(self.view.bounds) / 0 wil get +Inf
    layer.position = CGPointMake(CGRectGetWidth(self.view.bounds) / 0, CGRectGetHeight(self.view.bounds) / 0);
    
    [self.view.layer addSublayer:layer];
}

- (void)test_CALayer_position_with_divide_zero2 {
    // Note: Center the layer in self.view
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    // Note: CGRectGetWidth(self.view.bounds) / 0 + 1 wil get +Inf
    layer.position = CGPointMake(CGRectGetWidth(self.view.bounds) / 0 + 1, CGRectGetHeight(self.view.bounds) / 0 + 1);
    
    [self.view.layer addSublayer:layer];
}

- (void)test_CALayer_position_with_divide_zero3 {
    // Note: Center the layer in self.view
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    // Note: - CGRectGetWidth(self.view.bounds) / 0 wil get +Inf
    //       - 0 / 0.0 wil get NaN
    CGSize size = CGSizeMake(0 / 0.0, CGRectGetHeight(self.view.bounds) / 0);
    layer.position = CGPointMake(size.width, size.height);
    
    [self.view.layer addSublayer:layer];
}

- (void)test_issue_of_CALayer_position {
    CALayer *layer = [CALayer layer];
    layer.bounds = CGRectMake(0, 0, 100, 100);
    layer.backgroundColor = [UIColor yellowColor].CGColor;
    
    // Crash: *** Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan 333.5]'
    layer.position = CGPointMake(NAN, CGRectGetHeight(self.view.bounds) / 2.0);
    
    [self.view.layer addSublayer:layer];
}

- (void)test_issue_of_UIView_frame {
    // Note: aspect ratio scaled image view and center it in self.view
    UIImage *image = [UIImage imageNamed:@"image_not_exists"];
    // Note: nil.size will return CGZero
    CGRect aspectScaledRect = AVMakeRectWithAspectRatioInsideRect(image.size, self.view.bounds);
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    // Crash: *** Terminating app due to uncaught exception 'CALayerInvalidGeometry', reason: 'CALayer position contains NaN: [nan nan]'
    imageView.frame = aspectScaledRect;
    
    [self.view addSubview:imageView];
}

@end
