//
//  InterceptDoesNotRecognizeSelectorViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/3/31.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "InterceptDoesNotRecognizeSelectorViewController.h"
#import "WCObjCRuntimeUtility.h"
#import <objc/runtime.h>

@interface GateKeeper : NSObject
@property (nonatomic, assign) SEL unrecognizedSelector;
@property (nonatomic, strong) NSArray<NSString *> *callStackSymbols;
@property (nonatomic, strong) NSArray<NSNumber *> *callStackReturnAddresses;
@end

@implementation GateKeeper
- (void)noneExistedMethod:(id)sender {
    
    NSMutableString *stringM = [NSMutableString string];
    for (NSString *line in _callStackSymbols) {
        [stringM appendFormat:@"%@\n", line];
    }
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSStringFromSelector(_unrecognizedSelector) message:stringM delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:@"复制", nil];
    
    [alert show];
}

@end

@interface InterceptDoesNotRecognizeSelectorViewController ()

@end

static id MySetBackgroundColor(id self, SEL _cmd, SEL selector);
static id (*SetBackgroundColorIMP)(id self, SEL _cmd, SEL selector);

static id MySetBackgroundColor(id self, SEL _cmd, SEL selector) {
    // TODO: do custom work
//    SetBackgroundColorIMP(self, _cmd, color);
//    NSLog(@"_cmd: %@", NSStringFromSelector(selector));
    
    const char *className = object_getClassName(self);
    printf("_className: %s\n", className);
    
    if (strcmp(className, "InterceptDoesNotRecognizeSelectorViewController") == 0) {
        
        GateKeeper *handle = [GateKeeper new];
        handle.unrecognizedSelector = selector;
        handle.callStackSymbols = [NSThread callStackSymbols];
        handle.callStackReturnAddresses = [NSThread callStackReturnAddresses];
        
        // http://stackoverflow.com/questions/1451342/objective-c-find-caller-of-method
        NSUInteger lineNo = 3;
        NSString *sourceString = [[NSThread callStackSymbols] objectAtIndex:lineNo];
        // Example: 1   UIKit                               0x00540c89 -[UIApplication _callInitializationDelegatesForURL:payload:suspended:] + 1163
        NSCharacterSet *separatorSet = [NSCharacterSet characterSetWithCharactersInString:@" -[]+?.,"];
        NSMutableArray *array = [NSMutableArray arrayWithArray:[sourceString  componentsSeparatedByCharactersInSet:separatorSet]];
        [array removeObject:@""];
        
        NSLog(@"Stack = %@", [array objectAtIndex:0]);
        NSLog(@"Framework = %@", [array objectAtIndex:1]);
        NSLog(@"Memory address = %@", [array objectAtIndex:2]);
        NSLog(@"Class caller = %@", [array objectAtIndex:3]);
        NSLog(@"Function caller = %@", [array objectAtIndex:4]);
        
        Method method = class_getInstanceMethod([GateKeeper class], @selector(noneExistedMethod:));
        IMP imp = method_getImplementation(method);
        
        BOOL added = class_addMethod([GateKeeper class], selector, imp, NULL);
        if (added) {
            NSLog(@"added");
        }
        else {
            NSLog(@"not added");
        }
        
        return handle;
    }
    
    return SetBackgroundColorIMP(self, _cmd, selector);
}

@implementation InterceptDoesNotRecognizeSelectorViewController

+ (void)load {
    [WCObjCRuntimeUtility exchangeIMPForSelector:@selector(forwardingTargetForSelector:) onClass:[NSObject class] swizzledIMP:(IMP)MySetBackgroundColor originalIMP:(IMP *)&SetBackgroundColorIMP];
}

#pragma mark - Test Methods

- (IBAction)test_callNoneExistMethod:(id)sender {
    [self performSelector:@selector(noneExistedMethod2:arg2:) withObject:self]; // will crash
}

- (IBAction)test_callNoneExistMethod3:(id)sender {
    //    UIView *obj = [[NSClassFromString(@"UIView") alloc] initWihtBounds:CGRectMake(0, 0, 100, 100)];
    
    [self performSelector:@selector(noneExistedMethod2:arg2:) withObject:self]; // will crash
}


@end
