//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "UseLOTAnimationViewViewController.h"
#import <Lottie/Lottie.h>

@interface UseLOTAnimationViewViewController ()
@property (nonatomic, strong) UILabel *labelValue;
@property (nonatomic, strong) UISlider *sliderProgress;
@property (nonatomic, strong) LOTAnimationView *animationView1;
@property (nonatomic, strong) LOTAnimationView *animationView2;
@end

@implementation UseLOTAnimationViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelValue];
    [self.view addSubview:self.sliderProgress];
    [self.view addSubview:self.animationView1];
    [self.view addSubview:self.animationView2];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemPlay target:self action:@selector(itemPlayClicked:)];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

#pragma mark - Getter

- (UILabel *)labelValue {
    if (!_labelValue) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat startY = 10;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, startY, screenSize.width, 30)];
        label.textAlignment = NSTextAlignmentCenter;
        label.font = [UIFont systemFontOfSize:17];
        label.textColor = [UIColor blackColor];
        label.text = @"0";
        
        _labelValue = label;
    }
    
    return _labelValue;
}

- (UISlider *)sliderProgress {
    if (!_sliderProgress) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UISlider *slider = [[UISlider alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_labelValue.frame) + 10, screenSize.width, 30)];
        slider.maximumValue = 1.0;
        slider.minimumValue = 0.0;
        [slider addTarget:self action:@selector(sliderProgressValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        _sliderProgress = slider;
    }
    
    return _sliderProgress;
}

- (LOTAnimationView *)animationView1 {
    if (!_animationView1) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 200;
        
        //NSString *pathComponent = @"rotateRefresh/data.json";
        NSString *pathComponent = @"anim1/data.json";
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pathComponent];
        LOTComposition *composition = [LOTComposition animationWithFilePath:path];
        LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:composition inBundle:[NSBundle mainBundle]];
        animationView.frame = CGRectMake((screenSize.width - side) / 2.0, CGRectGetMaxY(_sliderProgress.frame) + 10, side, side);
        animationView.hidden = NO;
        animationView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        _animationView1 = animationView;
    }
    
    return _animationView1;
}

- (LOTAnimationView *)animationView2 {
    if (!_animationView2) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat side = 80;
        
        //NSString *pathComponent = @"rotateRefresh-focus/data.json";
        NSString *pathComponent = @"anim2/data.json";
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pathComponent];
        LOTComposition *composition = [LOTComposition animationWithFilePath:path];
        LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:composition inBundle:[NSBundle mainBundle]];
        animationView.frame = CGRectMake((screenSize.width - side) / 2.0, CGRectGetMaxY(_animationView1.frame) + 10, side, side);
        animationView.hidden = NO;
        animationView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        _animationView2 = animationView;
    }
    
    return _animationView2;
}

#pragma mark - Action

- (void)sliderProgressValueChanged:(UISlider *)sender {
    self.animationView1.animationProgress = sender.value;
    self.animationView2.animationProgress = sender.value;
    
    self.labelValue.text = [NSString stringWithFormat:@"%f", sender.value];
}

- (void)itemPlayClicked:(UIBarButtonItem *)sender {
    [self.animationView1 playToProgress:1 withCompletion:^(BOOL animationFinished) {
        
    }];
    
    [self.animationView2 playToProgress:1 withCompletion:^(BOOL animationFinished) {
        
    }];
}

@end
