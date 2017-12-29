//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "SimulateMemoryWarningViewController.h"

@interface SimulateMemoryWarningViewController ()
@property (nonatomic, strong) UIButton *button;
@end

@implementation SimulateMemoryWarningViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.button];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Alert" message:@"Memory warning received" delegate:nil cancelButtonTitle:@"Ok" otherButtonTitles:nil];
    [alertView show];
#pragma GCC diagnostic pop
}

- (UIButton *)button {
    if (!_button) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Trigger Memory Warning" forState:UIControlStateNormal];
        [button sizeToFit];
        button.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _button = button;
    }
    
    return _button;
}

#pragma mark - Actions

- (void)buttonClicked:(id)sender {
#if DEBUG
    // @see https://stackoverflow.com/a/2785175
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wundeclared-selector"
#pragma GCC diagnostic ignored "-Warc-performSelector-leaks"
    SEL memoryWarningSel = @selector(_performMemoryWarning);
    if ([[UIApplication sharedApplication] respondsToSelector:memoryWarningSel]) {
        [[UIApplication sharedApplication] performSelector:memoryWarningSel];
    }
    else {
        NSLog(@"Whoops UIApplication no loger responds to -_performMemoryWarning");
    }
#pragma GCC diagnostic pop

#else
    NSLog(@"Warning: performFakeMemoryWarning called on a non debug build");
#endif
}

@end
