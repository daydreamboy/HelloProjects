//
//  GetSizeClassViewController.m
//  HelloUITraitCollection
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "GetSizeClassViewController.h"
#import "WCTraitCollectionTool.h"

@interface GetSizeClassViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation GetSizeClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.label];
    
    [self updateLabel];
}

- (void)traitCollectionDidChange:(UITraitCollection *)previousTraitCollection {
    NSLog(@"traitCollectionDidChange: %@", previousTraitCollection);
    
    [self updateLabel];
}

- (void)updateLabel {
    CGSize superViewSize = self.view.bounds.size;
    
    self.label.text = [WCTraitCollectionTool stringInfoWithTraitCollection:self.traitCollection];
    [self.label sizeToFit];
    self.label.center = CGPointMake(superViewSize.width / 2.0, superViewSize.height / 2.0);
}

#pragma mark - Getter

- (UILabel *)label {
    if (!_label) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.textColor = [UIColor redColor];
        _label = label;
    }
    
    return _label;
}

@end
