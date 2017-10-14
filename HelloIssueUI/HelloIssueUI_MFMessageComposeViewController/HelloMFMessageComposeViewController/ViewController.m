//
//  ViewController.m
//  HelloMFMessageComposeViewController
//
//  Created by wesley chen on 3/4/17.
//  Copyright © 2017 wesley chen. All rights reserved.
//

#import "ViewController.h"
#import <MessageUI/MessageUI.h>
#import <objc/runtime.h>

@implementation UIViewController (Wrong_Swizzled)

+ (void)load {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        Class class = NSClassFromString(@"UIViewController");
        [self exchangeSelectorForClass:class origin:@selector(canBecomeFirstResponder) substitute:@selector(canBecomeFirstResponder_intercepted)];
    });
}

- (BOOL)canBecomeFirstResponder_intercepted {
    BOOL yesOrNo = [self canBecomeFirstResponder_intercepted];
    NSLog(@"%@: %@", self, yesOrNo ? @"YES": @"NO");
    return YES; // FIXME: 这里总是返回YES，影响到系统的view controller，MFMessageComposeViewController有一定概率显示不了键盘
}

+ (void)exchangeSelectorForClass:(Class)cls origin:(SEL)origin substitute:(SEL)substitute {
    Method origMethod = class_getInstanceMethod(cls, origin);
    Method replaceMethod = class_getInstanceMethod(cls, substitute);
    
    if (class_addMethod(cls, origin, method_getImplementation(replaceMethod), method_getTypeEncoding(replaceMethod))) {
        class_replaceMethod(cls, substitute, method_getImplementation(origMethod), method_getTypeEncoding(origMethod));
    }
    else {
        method_exchangeImplementations(origMethod, replaceMethod);
    }
}

@end

@interface ViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)buttonSendSMSClicked:(id)sender {
    NSString *receiverPhoneNumber = @"123";
    NSString *content = @"test";
    
    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    NSString *phoneNumber = [receiverPhoneNumber copy];
    if (phoneNumber.length) {
        NSMutableArray *arrM = [NSMutableArray array];
        [arrM addObject:phoneNumber];
        controller.recipients = arrM;
    }
    controller.body = content;
    controller.messageComposeDelegate = self;
    
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark - MFMessageComposeViewControllerDelegate

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result {
    switch (result) {
            case MessageComposeResultSent: {
                break;
            }
            case MessageComposeResultCancelled:
            case MessageComposeResultFailed:
        default: {
            [self dismissViewControllerAnimated:YES completion:nil];
            break;
        }
    }
}

@end
