//
//  ModalViewController.m
//  HelloMemoryLeak
//
//  Created by wesley chen on 16/9/5.
//
//

#import "ModalViewController.h"
#import "AppDelegate.h"

@interface ModalViewController ()
@property (nonatomic, strong) UIButton *buttonLogin;
@end

@implementation ModalViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor greenColor];
    [self.view addSubview:self.buttonLogin];
}

- (void)dealloc {
    NSLog(@"dealloc from %@", self);
}

#pragma mark - Getters

- (UIButton *)buttonLogin {
    if (!_buttonLogin) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        CGFloat width = 120.0f;
        CGFloat height = 30.0f;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.frame = CGRectMake((screenSize.width - width) / 2.0, (screenSize.height - height) / 2.0, width, height);
        [button setTitle:@"结束登录" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        button.backgroundColor = [UIColor whiteColor];
        button.titleLabel.font = [UIFont boldSystemFontOfSize:16.0f];
        button.layer.borderWidth = 2.5f;
        button.layer.borderColor = [UIColor blackColor].CGColor;
        
        [button addTarget:self action:@selector(buttonLoginClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonLogin = button;
    }
    
    return _buttonLogin;
}

#pragma mark - Actions

- (void)buttonLoginClicked:(id)sender {
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    [appDelegate switchRootViewController];
}

@end
