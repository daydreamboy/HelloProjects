//
//  SwizzleMethodByBlockViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/1/9.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "SwizzleMethodByBlockViewController.h"
#import "WCObjectTool.h"
#import <objc/message.h>

@interface SwizzleMethodByBlockViewController ()
@property (nonatomic, strong) UILabel *label;
@end

@implementation SwizzleMethodByBlockViewController

+ (void)load {
    SEL originalSelector = NSSelectorFromString(@"viewWillAppear:");
    SEL swizzledSelector = [WCObjectTool swizzledSelectorWithSelector:originalSelector];
    
    // swizzle block's arguments must match the swizzled selector
    void (^swizzleBlock)(UIViewController *, BOOL) = ^(UIViewController *slf, BOOL animated) {
        NSLog(@"swizzled block called");
        // change method signature to match the swizzledSelector
        ((void(*)(id, SEL, BOOL))objc_msgSend)(slf, swizzledSelector, animated);
    };
    
    [WCObjectTool exchangeIMPWithClass:[SwizzleMethodByBlockViewController class] originalSelector:originalSelector swizzledSelector:swizzledSelector swizzledBlock:swizzleBlock];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SEL originalSelector = NSSelectorFromString(@"viewWillAppear:");
    SEL swizzledSelector = [WCObjectTool swizzledSelectorWithSelector:originalSelector];
    
    void (^swizzleBlock)(UIViewController *, BOOL) = ^(UIViewController *slf, BOOL animated) {
        NSLog(@"swizzled block called");
        // change method signature to match the swizzledSelector
        ((void(*)(id, SEL, BOOL))objc_msgSend)(slf, swizzledSelector, animated);
    };
    
    [WCObjectTool exchangeIMPWithClass:[SwizzleMethodByBlockViewController class] originalSelector:originalSelector swizzledSelector:swizzledSelector swizzledBlock:swizzleBlock];
    
    self.view.backgroundColor = [UIColor whiteColor];
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    UITextField *textField = [[UITextField alloc] initWithFrame:CGRectMake(0, 64, screenSize.width, 30)];
    textField.layer.cornerRadius = 2.0f;
    textField.layer.borderWidth = 1.0f / [UIScreen mainScreen].scale;
    textField.layer.borderColor = [UIColor darkGrayColor].CGColor;
    textField.placeholder = @"Typing here...";
    [self.view addSubview:textField];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
#if TARGET_OS_SIMULATOR
    label.text = @"Connect to hardware keyboard to test shortcuts";
#else
    label.text = @"Test shortcuts on simulator";
#endif
    label.textColor = [UIColor darkGrayColor];
    [label sizeToFit];
    label.center = CGPointMake(screenSize.width / 2.0, screenSize.height / 2.0);
    [self.view addSubview:label];
    self.label = label;
    
    [self test];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    NSLog(@"%@", NSStringFromSelector(_cmd));
    NSLog(@"this is orignal viewWillAppear:");
}

#pragma mark - Test Methods

- (void)test {
#if TARGET_OS_SIMULATOR
//    [[WCKeyboardShortcutManager defaultManager] registerSimulatorShortcutWithKey:@"b" modifiers:0 action:^{
//        [self.navigationController popViewControllerAnimated:YES];
//    } description:@"Pop current view controller"];
#endif
//
//    [self registerSimulatorShortcutWithKey:@"g" modifiers:0 action:^{
//        [self showExplorerIfNeeded];
//        [self.explorerViewController toggleMenuTool];
//    } description:@"Toggle FLEX globals menu"];
//    
//    [self registerSimulatorShortcutWithKey:@"v" modifiers:0 action:^{
//        [self showExplorerIfNeeded];
//        [self.explorerViewController toggleViewsTool];
//    } description:@"Toggle view hierarchy menu"];
//    
//    [self registerSimulatorShortcutWithKey:@"s" modifiers:0 action:^{
//        [self showExplorerIfNeeded];
//        [self.explorerViewController toggleSelectTool];
//    } description:@"Toggle select tool"];
//    
//    [self registerSimulatorShortcutWithKey:@"m" modifiers:0 action:^{
//        [self showExplorerIfNeeded];
//        [self.explorerViewController toggleMoveTool];
//    } description:@"Toggle move tool"];
//    
//    [self registerSimulatorShortcutWithKey:@"n" modifiers:0 action:^{
//        [self toggleTopViewControllerOfClass:[FLEXNetworkHistoryTableViewController class]];
//    } description:@"Toggle network history view"];
//    
//    [self registerSimulatorShortcutWithKey:UIKeyInputDownArrow modifiers:0 action:^{
//        if ([self isHidden]) {
//            [self tryScrollDown];
//        } else {
//            [self.explorerViewController handleDownArrowKeyPressed];
//        }
//    } description:@"Cycle view selection\n\t\tMove view down\n\t\tScroll down"];
//    
//    [self registerSimulatorShortcutWithKey:UIKeyInputUpArrow modifiers:0 action:^{
//        if ([self isHidden]) {
//            [self tryScrollUp];
//        } else {
//            [self.explorerViewController handleUpArrowKeyPressed];
//        }
//    } description:@"Cycle view selection\n\t\tMove view up\n\t\tScroll up"];
//    
//    [self registerSimulatorShortcutWithKey:UIKeyInputRightArrow modifiers:0 action:^{
//        if (![self isHidden]) {
//            [self.explorerViewController handleRightArrowKeyPressed];
//        }
//    } description:@"Move selected view right"];
//    
//    [self registerSimulatorShortcutWithKey:UIKeyInputLeftArrow modifiers:0 action:^{
//        if ([self isHidden]) {
//            [self tryGoBack];
//        } else {
//            [self.explorerViewController handleLeftArrowKeyPressed];
//        }
//    } description:@"Move selected view left"];
//    
//    [self registerSimulatorShortcutWithKey:@"?" modifiers:0 action:^{
//        [self toggleTopViewControllerOfClass:[FLEXKeyboardHelpViewController class]];
//    } description:@"Toggle (this) help menu"];
//    
//    [self registerSimulatorShortcutWithKey:UIKeyInputEscape modifiers:0 action:^{
//        [[[self topViewController] presentingViewController] dismissViewControllerAnimated:YES completion:nil];
//    } description:@"End editing text\n\t\tDismiss top view controller"];
//    
//    [self registerSimulatorShortcutWithKey:@"o" modifiers:UIKeyModifierCommand|UIKeyModifierShift action:^{
//        [self toggleTopViewControllerOfClass:[FLEXFileBrowserTableViewController class]];
//    } description:@"Toggle file browser menu"];
}

@end
