//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/9/5.
//
//

#import "LoginViewController.h"
#import "ModalViewController.h"

@interface LoginViewController ()
@property (nonatomic, strong) UIButton *buttonLogin;
@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
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
        [button setTitle:@"登录" forState:UIControlStateNormal];
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
    ModalViewController *modalViewController = [ModalViewController new];
    [self presentViewController:modalViewController animated:YES completion:nil];
}

@end
