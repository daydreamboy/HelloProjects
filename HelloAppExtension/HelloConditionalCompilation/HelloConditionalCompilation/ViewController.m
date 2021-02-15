//
//  ViewController.m
//  HelloConditionalCompilation
//
//  Created by wesley_chen on 2021/2/15.
//

#import "ViewController.h"
#import <SharedLibrary/SharedTool.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    UIApplication *sharedApplication = [SharedTool getSharedApplication];
    NSLog(@"%@", sharedApplication);
}


@end
