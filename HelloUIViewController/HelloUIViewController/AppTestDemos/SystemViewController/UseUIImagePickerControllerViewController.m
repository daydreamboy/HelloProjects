//
//  UseUIImagePickerControllerViewController.m
//  HelloUIViewController
//
//  Created by wesley_chen on 2021/1/12.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "UseUIImagePickerControllerViewController.h"

@interface UseUIImagePickerControllerViewController ()
@property (nonatomic, strong) UIButton *buttonChoosePhoto;
@end

@implementation UseUIImagePickerControllerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.buttonChoosePhoto];
}

#pragma mark - Getter

- (UIButton *)buttonChoosePhoto {
    if (!_buttonChoosePhoto) {
        CGSize screenSize = [[UIScreen mainScreen] bounds].size;
        
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        [button setTitle:@"Choose a photo" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button sizeToFit];
        button.frame = ({
            CGRect frame = button.frame;
            frame.origin.x = (screenSize.width - button.bounds.size.width) / 2.0;
            frame.origin.y = 10;
            frame;
        });
        [button addTarget:self action:@selector(buttonChoosePhotoClicked:) forControlEvents:UIControlEventTouchUpInside];
        
        _buttonChoosePhoto = button;
    }
    
    return _buttonChoosePhoto;
}

#pragma mark -

- (void)buttonChoosePhotoClicked:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    [self presentViewController:vc animated:YES completion:nil];
}

@end
