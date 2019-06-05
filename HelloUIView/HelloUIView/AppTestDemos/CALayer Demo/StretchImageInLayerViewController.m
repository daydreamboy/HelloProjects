//
//  StretchImageInLayerViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 2019/6/5.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "StretchImageInLayerViewController.h"
#import "WCResizableImageLayer.h"

@interface StretchImageInLayerViewController ()
@property (nonatomic, strong) UIView *hostView;
@end

@implementation StretchImageInLayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.hostView];
}

#pragma mark - Getter

- (UIView *)hostView {
    if (!_hostView) {
        _hostView = [[UIView alloc] initWithFrame:CGRectMake(0, 80, 200, 30)];
        
        // Note: image from https://www.ioscreator.com/tutorials/stretchable-images-ios7-tutorial
        WCResizableImageLayer *resizableImageLayer = [[WCResizableImageLayer alloc] initWithImage:[UIImage imageNamed:@"stretchableImage.png"] capInsets:UIEdgeInsetsMake(0, 5, 0, 5)];
        resizableImageLayer.frame = _hostView.bounds;
        
        [_hostView.layer addSublayer:resizableImageLayer];
    }
    
    return _hostView;
}

@end
