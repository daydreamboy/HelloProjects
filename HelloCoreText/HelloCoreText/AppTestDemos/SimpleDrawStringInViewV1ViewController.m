//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "SimpleDrawStringInViewV1ViewController.h"

#import "CTViewV1.h"

@interface SimpleDrawStringInViewV1ViewController ()

@end

@implementation SimpleDrawStringInViewV1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    CTViewV1 *view = [[CTViewV1 alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, screenSize.height - 64)];
    view.backgroundColor = [UIColor whiteColor];
    view.layer.borderColor = [UIColor redColor].CGColor;
    view.layer.borderWidth = 1.0;
    [self.view addSubview:view];
}

@end
