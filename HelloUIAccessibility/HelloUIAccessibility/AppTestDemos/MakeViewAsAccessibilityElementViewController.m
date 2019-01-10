//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "MakeViewAsAccessibilityElementViewController.h"

@interface MakeViewAsAccessibilityElementViewController ()
@property (nonatomic, strong) UIView *viewParent;
@end

@implementation MakeViewAsAccessibilityElementViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.viewParent];
}

#pragma mark - Getters

- (UIView *)viewParent {
    if (!_viewParent) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        view.backgroundColor = [UIColor yellowColor];
        view.isAccessibilityElement = YES;
        view.accessibilityElementsHidden = NO;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(10, 10, 40, 40);
        button.backgroundColor = [UIColor redColor];
        [view addSubview:button];
        
        _viewParent = view;
    }
    
    return _viewParent;
}

@end
