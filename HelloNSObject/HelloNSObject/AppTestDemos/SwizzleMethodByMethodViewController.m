//
//  SwizzleMethodByMethodViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 3/6/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "SwizzleMethodByMethodViewController.h"
#import "WCObjectTool.h"

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
    NSLog(@"MyView: a customized method not intended for swizzling");
}
@end

@interface UIButton (Category_A)
@end
@implementation UIButton (Category_A)

static void MySetBackgroundColor(id self, SEL _cmd, UIColor *color);
static void (*SetBackgroundColorIMP)(id self, SEL _cmd, UIColor *color);
// Error: Redefinition of MySetBackgroundColor
/*
static void MySetBackgroundColor(id self, SEL _cmd, UIColor *color) {
    SetBackgroundColorIMP(self, _cmd, color);
}
 */

// Warning: this method's name conflict with the swizzled method, maybe called by accident
- (void)my_setFrame:(CGRect)frame {
    NSLog(@"UIButton(Category_A): a customized category method not intended for swizzling");
}

- (void)setBackgroundColor:(UIColor *)backgroundColor {
    [super setBackgroundColor:backgroundColor];
    NSLog(@"%@", NSStringFromSelector(_cmd));
}
@end

@interface UIView (Category_B)
@end
@implementation UIView (Category_B)

static void MySetBackgroundColor(id self, SEL _cmd, UIColor *color);
static void (*SetBackgroundColorIMP)(id self, SEL _cmd, UIColor *color);

static void MySetBackgroundColor(id self, SEL _cmd, UIColor *color) {
    // TODO: do custom work
    SetBackgroundColorIMP(self, _cmd, color);
}

// Note: this a swizzled method for setFrame:
- (void)my_setFrame:(CGRect)frame {
    //NSLog(@"my_setFrame called by %@", self);
    
    // TODO: do custom work
    [self my_setFrame:frame];
}

+ (void)load {
    // Warning: the swizzled method `my_setFrame:` will pollute all UIView's subclasses' setFrame: method
    //[WCObjectTool exchangeIMPForClass:[UIView class] originalSelector:@selector(setFrame:) swizzledSelector:@selector(my_setFrame:)];
    
    [WCObjectTool exchangeIMPForClass:[UIView class] selector1:@selector(setFrame:) selector2:@selector(my_setFrame:)];
    
    // Note: a more safe swizzling by using C funtion (IMP)
    //[WCObjCRuntimeUtility exchangeIMPForSelector:@selector(setBackgroundColor:) onClass:[UIView class] swizzledIMP:(IMP)MySetBackgroundColor originalIMP:(IMP *)&SetBackgroundColorIMP];
}
@end

@implementation SwizzleMethodByMethodViewController

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
