//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"
#import <PodspecResourceBundle/Manager.h>

@interface Demo1ViewController ()
@property (nonatomic, strong) UIImageView *imageView1;
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    Manager *manager = [Manager new];
    UIImage *image1 = [manager image1];
    NSLog(@"image1: %@", image1);
    UIImage *image2 = [manager image2];
    NSLog(@"image2: %@", image2);
}

@end
