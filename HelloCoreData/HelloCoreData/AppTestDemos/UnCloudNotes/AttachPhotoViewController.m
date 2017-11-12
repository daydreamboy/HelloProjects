//
//  AttachPhotoViewController.m
//  HelloCoreData
//
//  Created by wesley_chen on 12/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "AttachPhotoViewController.h"

@interface AttachPhotoViewController () <UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) UIImagePickerController *imagePickerController;
@end

@implementation AttachPhotoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.title = self.note.title;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.imagePickerController.view];
}

- (void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    
    self.imagePickerController.view.frame = self.view.bounds;
}

#pragma mark - Getters

- (UIImagePickerController *)imagePickerController {
    if (!_imagePickerController) {
        UIImagePickerController *controller = [UIImagePickerController new];
        controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        controller.delegate = self;
        [self addChildViewController:controller];
        
        _imagePickerController = controller;
    }
    
    return _imagePickerController;
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    if (self.note) {
        self.note.image = info[UIImagePickerControllerOriginalImage];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
