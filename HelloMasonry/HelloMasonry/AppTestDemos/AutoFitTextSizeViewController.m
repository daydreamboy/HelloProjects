//
//  AutoFitTextSizeViewController.m
//  HelloMasonry
//
//  Created by wesley_chen on 2021/4/14.
//

#import "AutoFitTextSizeViewController.h"
#import "WCMacroTool.h"
#import <Masonry/Masonry.h>

@interface AutoFitTextSizeViewController ()
@property (nonatomic, strong) UILabel *labelText;
@end

@implementation AutoFitTextSizeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.labelText];
    
    // @see https://stackoverflow.com/questions/17497002/when-will-or-wont-updateviewconstraints-be-called-on-my-view-controller-for-m
    [self.view setNeedsUpdateConstraints];
}

- (void)updateViewConstraints {
    [self.labelText mas_makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view.mas_leading).offset(8);
        make.centerY.mas_equalTo(0);
    }];
    
    [super updateViewConstraints];
}

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


@end
