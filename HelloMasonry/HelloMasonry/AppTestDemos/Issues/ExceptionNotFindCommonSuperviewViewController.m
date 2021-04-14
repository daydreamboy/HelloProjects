//
//  ExceptionNotFindCommonSuperviewViewController.m
//  HelloMasonry
//
//  Created by wesley_chen on 2021/4/14.
//

#import "ExceptionNotFindCommonSuperviewViewController.h"
#import "WCMacroTool.h"
#import <Masonry/Masonry.h>

@interface ExceptionNotFindCommonSuperviewViewController ()
@property (nonatomic, strong) UILabel *labelText;
@end

@implementation ExceptionNotFindCommonSuperviewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.labelText];
}

#pragma mark - Getter

- (UILabel *)labelText {
    if (!_labelText) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textAlignment = NSTextAlignmentLeft;
        label.font = [UIFont boldSystemFontOfSize:17];
        label.textColor = UICOLOR_RGB(0x171A1D);
        label.text = @"Hello, world!";
        
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.leading.mas_equalTo(self.view.mas_leading).offset(8);
            make.centerY.mas_equalTo(0);
        }];
        
        _labelText = label;
    }
    
    return _labelText;
}

@end
