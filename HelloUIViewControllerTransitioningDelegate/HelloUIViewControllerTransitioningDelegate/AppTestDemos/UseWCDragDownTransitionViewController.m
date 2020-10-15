//
//  UseWCDragDownTransitionViewController.m
//  HelloUIViewControllerTransitioningDelegate
//
//  Created by wesley_chen on 2020/10/15.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#import "UseWCDragDownTransitionViewController.h"
#import "DragDownPresentedViewController.h"
#import "WCDragDownTransitionAnimator.h"
#import "WCMacroTool.h"

@interface UseWCDragDownTransitionViewController () <UIViewControllerTransitioningDelegate>
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) WCDragDownTransitionAnimator *dragDownTransition;
@end

@implementation UseWCDragDownTransitionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.imageView];
}

#pragma mark - Getters

- (UIImageView *)imageView {
    if (!_imageView) {
        UIImage *image = [UIImage imageNamed:@"Xcode"];
        CGFloat side = 200;
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, side, side)];
        imageView.image = image;
        imageView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0 + side);
        imageView.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewTapped:)];
        [imageView addGestureRecognizer:tapGesture];
        
        _imageView = imageView;
    }
    
    return _imageView;
}

#pragma mark - Actions

- (void)imageViewTapped:(UITapGestureRecognizer *)recognizer {
    DragDownPresentedViewController *vc = [DragDownPresentedViewController new];
    vc.transitioningDelegate = self;
    CGRect rectInWindow = [self.imageView.superview convertRect:self.imageView.frame toView:nil];
    self.dragDownTransition = [[WCDragDownTransitionAnimator alloc] initWithFromRect:rectInWindow presentedViewController:vc];
    self.dragDownTransition.transitionInDuration = 0.1;
    self.dragDownTransition.transitionOutDuration = 0.3;
    
    weakify(self);
    [self presentViewController:vc animated:YES completion:^{
        strongifyWithReturn(self, return;);
        [self.dragDownTransition enableInteractorOnView:vc.imageView];
    }];
}

#pragma mark - UIViewControllerTransitioningDelegate

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return self.dragDownTransition;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return self.dragDownTransition;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return [self.dragDownTransition handleInteractionControllerForDismissal:animator];
}

@end
