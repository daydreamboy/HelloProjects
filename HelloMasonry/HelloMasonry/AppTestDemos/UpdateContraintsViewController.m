//
//  UpdateContraintsViewController.m
//  HelloMasonry
//
//  Created by wesley_chen on 2021/4/14.
//

#import "UpdateContraintsViewController.h"
#import "WCMacroTool.h"
#import <Masonry/Masonry.h>

@interface UpdateContraintsViewController ()
@property (nonatomic, strong) UILabel *labelText;
@property (nonatomic, strong) UIButton *buttonChangeHeight;
@end

@implementation UpdateContraintsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonChangeHeight];
    [self.view addSubview:self.labelText];
    
    UIStepper *stepper = [UIStepper new];
    [stepper addTarget:self action:@selector(stepperValueChanged:) forControlEvents:UIControlEventValueChanged];
    stepper.value = 17;
    stepper.minimumValue = 17;
    stepper.maximumValue = 80;
    
    UIBarButtonItem *adjustItem = [[UIBarButtonItem alloc] initWithCustomView:stepper];
    self.navigationItem.rightBarButtonItem = adjustItem;
    
    
    // @see https://stackoverflow.com/questions/17497002/when-will-or-wont-updateviewconstraints-be-called-on-my-view-controller-for-m
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [self.labelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(8);
        make.centerY.mas_equalTo(0);
        make.height.mas_equalTo(0);
    }];
    
    [super updateViewConstraints];
}

#pragma mark - Action

- (void)stepperValueChanged:(UIStepper *)sender {
    int fontSize = (int)sender.value;
    self.labelText.font = [UIFont boldSystemFontOfSize:fontSize];
}

#pragma mark - Getter

- (UILabel *)labelText {
    if (!_labelText) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = UICOLOR_RGB(0x171A1D);
        label.text = @"Hello, world!";
        label.layer.borderColor = [UIColor redColor].CGColor;
        label.layer.borderWidth = 1.0 / [UIScreen mainScreen].scale;

        _labelText = label;
    }
    
    return _labelText;
}

- (UIButton *)buttonChangeHeight {
    if (!_buttonChangeHeight) {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Change Height" forState:UIControlStateNormal];
        [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [button sizeToFit];
        button.frame = CGRectMake(0, 10, button.frame.size.width, button.frame.size.height);
        
        _buttonChangeHeight = button;
    }
    
    return _buttonChangeHeight;
}

#pragma mark - Action

- (void)buttonClicked:(id)sender {
    [self.labelText mas_updateConstraints:^(MASConstraintMaker *make) {
        make.height.mas_equalTo(100);
    }];
}

@end
