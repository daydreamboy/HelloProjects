//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "ColorizeHairLineOfNavBarViewController.h"
#import "WCNavigationBarTool.h"

@interface ColorizeHairLineOfNavBarViewController ()

@end

@implementation ColorizeHairLineOfNavBarViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [WCNavigationBarTool setNavBar:navigationBar hairLineColor:[UIColor redColor]];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    UINavigationBar *navigationBar = self.navigationController.navigationBar;
    [WCNavigationBarTool setNavBar:navigationBar hairLineColor:nil];
}

@end
