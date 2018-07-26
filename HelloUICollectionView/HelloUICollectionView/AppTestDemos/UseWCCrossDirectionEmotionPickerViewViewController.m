//
//  UseWCCrossDirectionEmotionPickerViewViewController.m
//  HelloUICollectionView
//
//  Created by wesley_chen on 2018/7/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UseWCCrossDirectionEmotionPickerViewViewController.h"
#import "WCCrossDirectionEmotionPickerView.h"

@interface UseWCCrossDirectionEmotionPickerViewViewController ()
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) WCCrossDirectionEmotionPickerView *emotionPickerView;
@end

@implementation UseWCCrossDirectionEmotionPickerViewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.textField];
}

#pragma mark - Getters

- (UITextField *)textField {
    if (!_textField) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        CGFloat paddingH = 20;
        UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(paddingH, 100, screenSize.width - 2 * paddingH, 30)];
        textField.inputView =
        
        _textField = textField;
    }
    
    return _textField;
}

- (WCCrossDirectionEmotionPickerView *)emotionPickerView {
    if (!_emotionPickerView) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        _emotionPickerView = [[WCCrossDirectionEmotionPickerView alloc] initWithFrame:CGRectMake(0, 0, screenSize.width, 216)];
    }
    
    return _emotionPickerView;
}

@end
