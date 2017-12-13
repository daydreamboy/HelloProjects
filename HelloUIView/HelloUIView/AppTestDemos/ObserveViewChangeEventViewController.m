//
//  ObserveViewChangeEventViewController.m
//  HelloUIView
//
//  Created by wesley_chen on 13/12/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ObserveViewChangeEventViewController.h"
#import "WCViewTool.h"

@interface ObserveViewChangeEventViewController ()
@property (nonatomic, assign) BOOL stop;
@property (nonatomic, strong) UIView *observedView;
@end

@implementation ObserveViewChangeEventViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 300, 200)];
    view.backgroundColor = [UIColor blueColor];
    [self.view addSubview:view];
    
    [WCViewTool registerGeometryChangedObserverForView:view];
    [self doSomeRandomAlterationToViewRepeated:view];
    
    self.observedView = view;
}

- (void)viewWillDisappear:(BOOL)animated {
    self.stop = YES;
}

- (void)dealloc {
//    [WCViewTool unregisterGeometryChangeObserverForView:self.observedView];
}

- (void)doSomeRandomAlterationToViewRepeated:(UIView *)view
{
    if (!self.stop) {
        double delayInSeconds = 0.5;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self doSomeRandomAlterationToView:view];
            [self doSomeRandomAlterationToViewRepeated:view];
        });
    }
}

// @see https://gist.github.com/hfossli/7234623
- (void)doSomeRandomAlterationToView:(UIView *)view
{
    switch (arc4random_uniform(9)) {
        case 0:
        {
            NSLog(@"Changing frame");
            CGRect frame = view.frame;
            frame.size.width += (float)arc4random_uniform(100);
            view.frame = frame;
        }
            break;
        case 1:
        {
            NSLog(@"Changing bounds");
            CGRect bounds = view.bounds;
            bounds.size.width = (float)arc4random_uniform(100);
            view.frame = bounds;
        }
            break;
        case 2:
        {
            NSLog(@"Changing center");
            CGPoint center = view.center;
            center.x = (float)arc4random_uniform(100);
            view.center = center;
        }
            break;
        case 3:
        {
            NSLog(@"Changing layer.anchorPoint");
            CGPoint anchor = view.layer.anchorPoint;
            anchor.x = ((float)arc4random_uniform(5) / 10.0);
            view.layer.anchorPoint = anchor;
        }
            break;
        case 4:
        {
            NSLog(@"Changing layer.position");
            CGPoint position = view.layer.position;
            position.x = ((float)arc4random_uniform(5) / 10.0);
            view.layer.position = position;
        }
            break;
        case 5:
        {
            NSLog(@"Changing layer.anchorPointZ");
            CGFloat anchor = view.layer.anchorPointZ;
            anchor = (float)arc4random_uniform(20);
            view.layer.anchorPointZ = anchor;
        }
            break;
        case 6:
        {
            NSLog(@"Changing layer.bounds");
            CGRect bounds = view.layer.bounds;
            bounds.size.width = (float)arc4random_uniform(100);
            view.layer.bounds = bounds;
        }
            break;
        case 7:
        {
            NSLog(@"Changing layer.transform");
            CATransform3D transform = view.layer.transform;
            transform.m32 = (float)arc4random_uniform(100);
            view.layer.transform = transform;
        }
            break;
        case 8:
        {
            NSLog(@"Changing transform");
            CGAffineTransform transform = view.transform;
            transform.a = ((float)arc4random_uniform(5) / 10.0);
            view.transform = transform;
        }
            break;
            
        default:
            
            break;
    }
}

@end
