//
//  RotationViewController.m
//  HelloCoreAnimation
//
//  Created by wesley_chen on 15/3/30.
//  Copyright (c) 2015年 wesley_chen. All rights reserved.
//

#import "RotationViewController.h"

typedef NS_ENUM(NSUInteger, ButtonTag) {
    ButtonTagPlay,
    ButtonTagPrevious,
    ButtonTagNext,
};

@interface RotationViewController ()
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) BOOL firstStart;
@end

@implementation RotationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor yellowColor];
//    self.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UIImage *image = [UIImage imageNamed:@"logo64X64"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.center = CGPointMake(screenSize.width / 2, screenSize.height / 2);
    imageView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleRightMargin;
    [self.view addSubview:imageView];
    self.imageView = imageView;
    
    
    CGSize imageSize = [UIImage imageNamed:@"play"].size;
    UIButton *playButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playButton.frame = CGRectMake((screenSize.width - imageSize.width) / 2, screenSize.height - imageSize.height - 20, imageSize.width, imageSize.height);
    playButton.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    playButton.tag = ButtonTagPlay;
    [playButton setBackgroundImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [playButton setBackgroundImage:[UIImage imageNamed:@"pause"] forState:UIControlStateSelected];
    [playButton setSelected:NO];
    [playButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:playButton];
    
    UIImage *preImage = [UIImage imageNamed:@"previous"];
    UIButton *preButton = [UIButton buttonWithType:UIButtonTypeCustom];
    preButton.frame = CGRectMake(CGRectGetMinX(playButton.frame) - preImage.size.width - 20, screenSize.height - preImage.size.height - 20, preImage.size.width, preImage.size.height);
    preButton.tag = ButtonTagPrevious;
    [preButton setBackgroundImage:preImage forState:UIControlStateNormal];
    [preButton setBackgroundImage:[UIImage imageNamed:@"previous_pressed"] forState:UIControlStateHighlighted];
    [preButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [preButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:preButton];
    
    UIImage *nextImage = [UIImage imageNamed:@"next"];
    UIButton *nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
    nextButton.frame = CGRectMake(CGRectGetMaxX(playButton.frame) + 20, screenSize.height - nextImage.size.height - 20, nextImage.size.width, nextImage.size.height);
    nextButton.tag = ButtonTagNext;
    [nextButton setBackgroundImage:nextImage forState:UIControlStateNormal];
    [nextButton setBackgroundImage:[UIImage imageNamed:@"next_pressed"] forState:UIControlStateHighlighted];
    [nextButton addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchDown];
    [nextButton addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:nextButton];
    
    self.firstStart = YES;
}

- (void)buttonClicked:(UIButton *)sender {
    
    switch ((ButtonTag)sender.tag) {
        case ButtonTagPlay: {
            
            sender.selected = !sender.selected;
            
            if (self.firstStart) {
                [self rotateLayer:self.imageView.layer withSpeed:3.0 byClockwise:NO];
                
                self.firstStart = NO;
                break;
            }
            
            if (sender.selected) {
                // Resume
                [self resumeLayer:self.imageView.layer];
            }
            else {
                // Pause
                [self pauseLayer:self.imageView.layer];
            }
            break;
        }
        case ButtonTagPrevious: {
            
            break;
        }
        case ButtonTagNext: {
            [self rotateLayer:self.imageView.layer withSpeed:3.0 byClockwise:NO];
            break;
        }
    }
}

- (void)buttonPressed:(UIButton *)sender {
    switch ((ButtonTag)sender.tag) {
        case ButtonTagPrevious: {
            
            break;
        }
        case ButtonTagNext: {
            [self accelerateLayer:self.imageView.layer withRatioOfSpeed:3.0];
            break;
        }
        default:
            break;
    }
}

#pragma mark -
- (void)pauseLayer:(CALayer *)layer {
	CFTimeInterval pausedTime = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
	layer.speed = 0.0;
	layer.timeOffset = pausedTime;
}

- (void)resumeLayer:(CALayer *)layer {
	CFTimeInterval pausedTime = [layer timeOffset];
	layer.speed = 1.0;
	layer.timeOffset = 0.0;
	layer.beginTime = 0.0;
	CFTimeInterval timeSincePause = [layer convertTime:CACurrentMediaTime() fromLayer:nil] - pausedTime;
	layer.beginTime = timeSincePause;
}

- (void)rotateLayer:(CALayer *)layer withSpeed:(CGFloat)speed byClockwise:(BOOL)isClockwise {
    
    CALayer* currentLayer = (CALayer*)[layer presentationLayer];
    float currentRotation = [(NSNumber*)[currentLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
    NSLog(@"f2: %f", currentRotation);
    
    [layer removeAllAnimations];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = speed;
    animation.speed = 1.0;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = @(currentRotation);
    animation.toValue = @(-2 * M_PI + fabs(currentRotation));
    //                animation.removedOnCompletion = NO;
    [layer addAnimation:animation forKey:@"play"];
}

- (void)accelerateLayer:(CALayer *)layer withRatioOfSpeed:(CGFloat)speed {
//    layer.timeOffset = [layer convertTime:CACurrentMediaTime() fromLayer:nil];
//    layer.beginTime = CACurrentMediaTime();
//    layer.speed = speed;
    
    
//    CABasicAnimation *oldAnimation = (CABasicAnimation *)[layer animationForKey:@"rotaion"];
//    float f = [oldAnimation.fromValue floatValue];
//    NSLog(@"f: %f", f);
//
    
    CALayer* currentLayer = (CALayer*)[layer presentationLayer];
    float currentRotation = [(NSNumber*)[currentLayer valueForKeyPath:@"transform.rotation.z"] floatValue];
    NSLog(@"f: %f", currentRotation);

//    [self pauseLayer:layer];
//    [layer removeAnimationForKey:@"play"];
    [layer removeAllAnimations];
//    [self resumeLayer:layer];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    animation.duration = 1.0f;
    animation.speed = 1.0;
    animation.repeatCount = HUGE_VALF;
    animation.fromValue = @(currentRotation);
    animation.toValue = @(2 * M_PI - fabsf(currentRotation));
    [layer addAnimation:animation forKey:@"fast forwards"];
    
//    layer.transform = CATransform3DMakeRotation(M_PI / 2, 0, 0, 1);
}

@end
