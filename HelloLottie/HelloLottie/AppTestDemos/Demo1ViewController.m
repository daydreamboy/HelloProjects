//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"
#import <Lottie/Lottie.h>

@interface Demo1ViewController ()
@property (nonatomic, strong) LOTAnimationView *animationView1;
@property (nonatomic, strong) LOTAnimationView *animationView2;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.animationView1];
    [self.view addSubview:self.animationView2];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self.animationView1 playToProgress:1 withCompletion:^(BOOL animationFinished) {
        
    }];
    
    [self.animationView2 playToProgress:1 withCompletion:^(BOOL animationFinished) {
        
    }];
}

#pragma mark - Getter

- (LOTAnimationView *)animationView1 {
    if (!_animationView1) {
        NSString *pathComponent = @"rotateRefresh/data.json";
        //NSString *pathComponent = @"anim1/data.json";
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pathComponent];
        LOTComposition *composition = [LOTComposition animationWithFilePath:path];
        LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:composition inBundle:[NSBundle mainBundle]];
        animationView.frame = CGRectMake(0, 0, 200, 200);
        animationView.hidden = NO;
        animationView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        _animationView1 = animationView;
    }
    
    return _animationView1;
}

- (LOTAnimationView *)animationView2 {
    if (!_animationView2) {
        NSString *pathComponent = @"rotateRefresh-focus/data.json";
        //NSString *pathComponent = @"anim2/data.json";
        NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pathComponent];
        LOTComposition *composition = [LOTComposition animationWithFilePath:path];
        LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:composition inBundle:[NSBundle mainBundle]];
        animationView.frame = CGRectMake(0, 300, 80, 80);
        animationView.hidden = NO;
        animationView.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        animationView.layer.borderColor = [UIColor redColor].CGColor;
        
        _animationView2 = animationView;
    }
    
    return _animationView2;
}

@end
