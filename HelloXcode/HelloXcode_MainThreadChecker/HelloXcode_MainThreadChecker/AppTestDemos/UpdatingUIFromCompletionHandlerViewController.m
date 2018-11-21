//
//  UpdatingUIFromCompletionHandlerViewController.m
//  HelloXcode_MainThreadChecker
//
//  Created by wesley_chen on 2018/11/21.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UpdatingUIFromCompletionHandlerViewController.h"

@interface UpdatingUIFromCompletionHandlerViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation UpdatingUIFromCompletionHandlerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    [self test_Updating_UI_from_a_Completion_Handler];
    //[self test_solution];
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 30)];
        
        _label = label;
    }
    
    return _label;
}

#pragma mark - Test Methods

- (void)test_Updating_UI_from_a_Completion_Handler {
    NSString *url = @"https://www.baidu.com/";
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        self.label.text = [NSString stringWithFormat:@"%lu bytes downloaded", data.length];
        // Error: label updated on background thread
    }];
    [task resume];
}

- (void)test_solution {
    NSString *url = @"https://www.baidu.com/";
    
    NSURL *URL = [NSURL URLWithString:url];
    NSURLSessionTask *task = [[NSURLSession sharedSession] dataTaskWithURL:URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        dispatch_async(dispatch_get_main_queue(), ^{ // Correct
            self.label.text = [NSString stringWithFormat:@"%lu bytes downloaded", data.length];
        });
    }];
    [task resume];
}

@end
