//
//  FlipImageViewViewController.m
//  HelloCoreAnimation
//
//  Created by wesley chen on 16/6/1.
//  Copyright © 2016年 wesley_chen. All rights reserved.
//

#import "FlipImageViewViewController.h"

@interface FlipImageViewViewController ()
@property (nonatomic, strong) UIButton *buttonFlip;
@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIImageView *imageView1;
@property (nonatomic, strong) UIImageView *imageView2;

@end

@implementation FlipImageViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor whiteColor];

    [self.view addSubview:self.imageView];
    [self.view addSubview:self.buttonFlip];
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        CGFloat side = 256.0f;

        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
//        imageView.image = [UIImage imageNamed:@"genre-music.jpg"];
        imageView.image = [UIImage imageNamed:@"ops_icon_input_sms_code"];

        _imageView = imageView;
    }

    return _imageView;
}

//- (UIImageView *)imageView1 {
//    if (!_imageView1) {
//        CGFloat side = 256.0f;
//        
//        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
//        imageView.image = [UIImage imageNamed:@"genre-music.jpg"];
//        
//        _imageView1 = imageView;
//    }
//    
//    return _imageView1;
//}
//
//- (UIImageView *)imageView2 {
//    if (!_imageView2) {
//        CGFloat side = 256.0f;
//        
//        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
//        
//        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((screenSize.width - side) / 2.0, (screenSize.height - side) / 2.0, side, side)];
//        imageView.image = [UIImage imageNamed:@"genre-blues.jpg"];
//        
//        _imageView2 = imageView;
//    }
//    
//    return _imageView2;
//}

- (UIButton *)buttonFlip {
    if (!_buttonFlip) {
        CGFloat height = 30.0f;
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;

        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake(0, screenSize.height - height, screenSize.width, height);
//        button.backgroundColor = [UIColor yellowColor];
        button.exclusiveTouch = YES;
        [button setTitle:@"Flip !" forState:UIControlStateNormal];
//        [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(flipImageView:) forControlEvents:UIControlEventTouchUpInside];

        _buttonFlip = button;
    }

    return _buttonFlip;
}

- (void)flipImageView:(id)sender {
    UIButton *button = (UIButton *)sender;

    button.selected = !button.selected;

    if (button.selected) {
//        [UIView beginAnimations:@"LeftFlip" context:nil];
//        [UIView setAnimationDuration:0.8];
//        [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
//        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.imageView cache:YES];
//        
//        self.imageView.image = [UIImage imageNamed:@"genre-blues.jpg"];
//        
//        [UIView commitAnimations];
        
        // switch image有问题
        /*
        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
                         animations:^(void) {
                             self.imageView.transform = CGAffineTransformMakeScale(1, -1);
                             self.imageView.image = [UIImage imageNamed:@"genre-blues.jpg"];
                         }
                         completion:nil];
        */
        
        
        [UIView transitionWithView:self.imageView
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionBeginFromCurrentState
                        animations:^{
//                            self.imageView.image = [UIImage imageNamed:@"genre-blues.jpg"];
                            self.imageView.image = [UIImage imageNamed:@"ops_icon_input_phone"];
                        } completion:nil];
        
        
//        [UIView transitionWithView:self.imageView
//                          duration:0.4
//                           options:UIViewAnimationOptionTransitionFlipFromRight
//                        animations:^{
//            //  Set the new image
//            //  Since its done in animation block, the change will be animated
////            self.imageView.image = [UIImage imageNamed:@"genre-blues.jpg"];
//        }
//                        completion:^(BOOL finished) {
//                            NSLog(@"%@", self.imageView.image);
//            //  Do whatever when the animation is finished
//        }];
    }
    else {
        
        // @sa http://stackoverflow.com/questions/14426233/uiview-flip-animation
//        [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut
//                         animations:^(void) {
//                             self.imageView.transform = CGAffineTransformMakeScale(1, 1);
//                             self.imageView.image = [UIImage imageNamed:@"genre-music.jpg"];
//                         }
//                         completion:nil];
        
        
        // @sa http://stackoverflow.com/questions/7638831/fade-dissolve-when-changing-uiimageviews-image
        [UIView transitionWithView:self.imageView
                          duration:0.25f
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
//                            self.imageView.image = [UIImage imageNamed:@"genre-music.jpg"];
                            self.imageView.image = [UIImage imageNamed:@"ops_icon_input_sms_code"];
                        } completion:nil];
//
        /*
        [UIView transitionWithView:self.imageView
                          duration:0.4
                           options:UIViewAnimationOptionTransitionFlipFromLeft
                        animations:^{
            //  Set the new image
            //  Since its done in animation block, the change will be animated
            self.imageView.image = [UIImage imageNamed:@"genre-music.jpg"];
        }
                        completion:^(BOOL finished) {
                            NSLog(@"%@", self.imageView.image);
            //  Do whatever when the animation is finished
        }];
         */
    }
}

@end
