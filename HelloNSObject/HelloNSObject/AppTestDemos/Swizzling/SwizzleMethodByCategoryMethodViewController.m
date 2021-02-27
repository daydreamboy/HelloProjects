//
//  SwizzleMethodByCategoryMethodViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 3/6/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "SwizzleMethodByCategoryMethodViewController.h"
#import "WCObjectTool.h"
#import "WCSwizzleTool.h"

@interface MyViewController : UIViewController @end
@implementation MyViewController
- (void)my_setFrame:(CGRect)frame {
    // Note: Ok, this method is not swizzled
    NSLog(@"MyViewController: a customized method not intended for swizzling");
}
@end

@interface MyView : UIView @end
@implementation MyView
// Warning: this method's name conflict with the swizzled method, maybe called by accident
- (void)my_setFrame:(CGRect)frame {
    // Note: this method not for swizzling, but maybe called by child class, e.g. -[UIButton(Category_A) my_setFrame:]
    NSLog(@"MyView: a customized method not intended for swizzling");
}
@end

@interface UIButton (Category_A)
@end
@implementation UIButton (Category_A)

// Warning: this method's name conflict with the swizzled method, maybe called by accident
- (void)my_setFrame:(CGRect)frame {
    NSLog(@"UIButton(Category_A): a customized category method not intended for swizzling");
}

@end

@interface UIView (Category_B)
@end
@implementation UIView (Category_B)

// Note: this a swizzled method for setFrame:
- (void)my_setFrame:(CGRect)frame {
    NSLog(@"<%@: %p>: my_setFrame called", NSStringFromClass([self class]), self);
    
    // TODO: do custom work
    [self my_setFrame:frame];
}

@end

@implementation SwizzleMethodByCategoryMethodViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Warning: the swizzled method `my_setFrame:` will pollute all UIView's subclasses' setFrame: method
        [WCSwizzleTool exchangeIMPWithClass:[UIView class] selector1:@selector(setFrame:) selector2:@selector(my_setFrame:)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    [button setTitle:@"A button" forState:UIControlStateNormal];
    [button sizeToFit];
    button.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    [self.view addSubview:button];
    
    MyView *aView = [[MyView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    aView.backgroundColor = [UIColor greenColor];
    aView.center = CGPointMake(self.view.bounds.size.width / 2.0, self.view.bounds.size.height / 2.0);
    [self.view addSubview:aView];
    
    MyViewController *myVC = [[MyViewController alloc] init];
    myVC.view.frame = CGRectMake(0, 64, 50, 50);
    myVC.view.backgroundColor = [UIColor redColor];
    [self.view addSubview:myVC.view];
}

@end
