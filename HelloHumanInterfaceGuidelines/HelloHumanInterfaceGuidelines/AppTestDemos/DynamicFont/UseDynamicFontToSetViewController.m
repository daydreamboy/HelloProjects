//
//  UseDynamicFontToSetViewController.m
//  HelloHumanInterfaceGuidelines
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "UseDynamicFontToSetViewController.h"
#import "WCTheme.h"
#import "WCMacroTool.h"
#import "WCViewTool.h"
#import "UseDynamicFontToGetViewController.h"
#import "AppFontProvider.h"

@interface UseDynamicFontToSetViewController () <UIPickerViewDelegate, UIPickerViewDataSource>
@property (nonatomic, strong) UILabel *labelBody;
@property (nonatomic, strong) UILabel *labelCallout;
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) NSArray *fontProviderList;
@property (nonatomic, assign) NSUInteger currentIndex;
@end

@implementation UseDynamicFontToSetViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"default"];
        [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"small"];
        [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"medium"];
        [[WCDynamicFontManager sharedManager] registerDynamicFontProvider:[AppFontProvider new] forName:@"large"];
        
        self.fontProviderList = [WCDynamicFontManager sharedManager].fontProviderNames;
        
        NSInteger location = [self.fontProviderList indexOfObject:[WCDynamicFontManager sharedManager].currentFontProviderName];
        _currentIndex = location == NSNotFound ? 0 : location;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelBody];
    [self.view addSubview:self.pickerView];
    
    UIBarButtonItem *nextItem = [[UIBarButtonItem alloc] initWithTitle:@"Next" style:UIBarButtonItemStylePlain target:self action:@selector(nextItemClicked:)];
    self.navigationItem.rightBarButtonItem = nextItem;
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    CGFloat y = CGRectGetHeight(self.view.bounds) - CGRectGetHeight(_pickerView.bounds) - [WCViewTool safeAreaInsetsWithView:self.view].bottom;
    self.pickerView.frame = FrameSetOrigin(self.pickerView.frame, NAN, y);
}

#pragma mark - Getter

- (UILabel *)labelBody {
    if (!_labelBody) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, screenSize.width, 30)];
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;
        label.textAlignment = NSTextAlignmentCenter;
        label.text = @"Hello, 你好!";
        
        WCThemeSetDynamicFont(label, AppFontKey_label_body, [UIFont systemFontOfSize:12], ^(id object, UIFont *newFont) {
            UILabel *label = (UILabel *)object;
            CGRect frame = label.frame;
            [label sizeToFit];
            CGRect textBounds = label.bounds;
            frame.size.width = CGRectGetWidth(textBounds);
            frame.size.height = CGRectGetHeight(textBounds);
            frame.origin.x = (screenSize.width - frame.size.width) / 2.0;
            
            label.frame = frame;
        });
        
        _labelBody = label;
    }
    
    return _labelBody;
}

- (UIPickerView *)pickerView {
    if (!_pickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIPickerView *pickerView = [[UIPickerView alloc] init];
        pickerView.frame = CGRectMake(0, CGRectGetHeight(self.view.bounds) - CGRectGetHeight(pickerView.bounds) - CGRectGetHeight(self.navigationController.navigationBar.bounds), screenSize.width, CGRectGetHeight(pickerView.bounds));
        pickerView.delegate = self;
        pickerView.dataSource = self;
        pickerView.backgroundColor = [[UIColor lightGrayColor] colorWithAlphaComponent:0.2];
        [pickerView selectRow:_currentIndex inComponent:0 animated:NO];
        
        _pickerView = pickerView;
    }
    
    return _pickerView;
}

#pragma mark - Action

- (void)nextItemClicked:(id)sender {
    [self.navigationController pushViewController:[UseDynamicFontToGetViewController new] animated:YES];
}

#pragma mark - UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return self.fontProviderList[row];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    NSInteger index = [self.pickerView selectedRowInComponent:0];
    [[WCDynamicFontManager sharedManager] setCurrentFontProviderName:self.fontProviderList[index]];
}

#pragma mark - UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.fontProviderList count];
}

@end
