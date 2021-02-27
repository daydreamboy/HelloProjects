//
//  SwizzleMethodByCFunctionViewController.m
//  HelloNSObject
//
//  Created by wesley_chen on 2019/9/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "SwizzleMethodByCFunctionViewController.h"
#import "WCObjectTool.h"

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
    NSLog(@"<%@: %p>: %@", NSStringFromClass([self class]), self, NSStringFromSelector(_cmd));
}
@end


static void MySetBackgroundColor(id self, SEL _cmd, UIColor *color);
static void (*SetBackgroundColorIMP)(id self, SEL _cmd, UIColor *color);

static void MySetBackgroundColor(id self, SEL _cmd, UIColor *color) {
    // TODO: do custom work
    NSLog(@"<%@: %p>: hook %@", NSStringFromClass([self class]), self, NSStringFromSelector(_cmd));
    SetBackgroundColorIMP(self, _cmd, color);
}

@interface SwizzleMethodByCFunctionViewController ()

@end

@implementation SwizzleMethodByCFunctionViewController

- (instancetype)init {
    self = [super init];
    if (self) {
        // Note: a more safe swizzling by using C funtion (IMP)
        [WCObjectTool exchangeIMPWithClass:[UIView class] swizzledIMP:(IMP)MySetBackgroundColor originalSelector:@selector(setBackgroundColor:) originalIMPPtr:(IMP *)&SetBackgroundColorIMP];
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
}

@end
