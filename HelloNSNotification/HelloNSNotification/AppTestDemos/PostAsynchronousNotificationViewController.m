//
//  PostAsynchronousNotificationViewController.m
//  HelloNSNotification
//
//  Created by wesley_chen on 2020/12/6.
//

#import "PostAsynchronousNotificationViewController.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"

#define kNotificationAsync1 @"kNotificationAsync1"

@interface PostAsynchronousNotificationViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@end

@implementation PostAsynchronousNotificationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.pickerView];
    
    UIBarButtonItem *postItem = [[UIBarButtonItem alloc] initWithTitle:@"Post" style:UIBarButtonItemStylePlain target:self action:@selector(postItemClicked:)];
    self.navigationItem.rightBarButtonItem = postItem;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handlekNotificationAsync1:) name:kNotificationAsync1 object:nil];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    self.pickerView.frame = FrameSetOrigin(self.pickerView.frame, NAN, y);
}

#pragma mark - Getters

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        _pickerView = [[UIPickerView alloc] init];
        _pickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds), screenSize.width, CGRectGetHeight(_pickerView.bounds));
        _pickerView.delegate = self;
        _pickerView.dataSource = self;
        _pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
    }
    
    return _pickerView;
}

#pragma mark - Action

- (void)postItemClicked:(id)sender {
    NSNotification *notification = [NSNotification notificationWithName:kNotificationAsync1 object:nil userInfo:@{ @"key": @"value" }];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostNow];
    [[NSNotificationQueue defaultQueue] enqueueNotification:notification postingStyle:NSPostNow];
}

#pragma mark - NSNotification

- (void)handlekNotificationAsync1:(NSNotification *)notification {
    NSLog(@"handle notification: %@", notification.name);
}

@end
