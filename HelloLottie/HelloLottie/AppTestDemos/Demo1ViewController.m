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
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *pathComponent = @"rotateRefresh/data.json";
    pathComponent = @"rotateRefresh-focus/data.json";
    
    NSString *path = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:pathComponent];
    LOTComposition *composition = [LOTComposition animationWithFilePath:path];
    LOTAnimationView *animationView = [[LOTAnimationView alloc] initWithModel:composition inBundle:[NSBundle mainBundle]];
    animationView.frame = CGRectMake(0, 0, 200, 200);
    animationView.hidden = NO;
    
    [self.view addSubview:animationView];
    [animationView playToProgress:1 withCompletion:^(BOOL animationFinished) {
        
    }];
}

@end
