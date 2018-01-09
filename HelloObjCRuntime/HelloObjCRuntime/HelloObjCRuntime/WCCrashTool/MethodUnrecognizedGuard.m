//
//  MethodUnrecognizedGuard.m
//  HelloObjCRuntime
//
//  Created by wesley_chen on 04/01/2018.
//  Copyright © 2018 wesley chen. All rights reserved.
//

#import "MethodUnrecognizedGuard.h"
#import "WCObjCRuntimeUtility.h"
#import <objc/runtime.h>
#import <UIKit/UIKit.h>

@implementation MethodUnrecognizedGuard

static id MySetBackgroundColor(id self, SEL _cmd, SEL selector);
static id (*SetBackgroundColorIMP)(id self, SEL _cmd, SEL selector);

static id MySetBackgroundColor(id self, SEL _cmd, SEL selector) {
    // TODO: do custom work
    //    SetBackgroundColorIMP(self, _cmd, color);
    //    NSLog(@"_cmd: %@", NSStringFromSelector(selector));
    
    const char *classNameCString = object_getClassName(self);
    NSString *className = [[NSString alloc] initWithUTF8String:classNameCString];
    
    NSArray *whiteClassNameList = @[
                                    @"InterceptDoesNotRecognizeSelectorViewController",
                                    @"UIView",
                                    ];
    
    if ([whiteClassNameList containsObject:className]) {
        
        MethodUnrecognizedGuard *handler = [MethodUnrecognizedGuard new];
        handler.className = className;
        handler.unrecognizedSelector = selector;
        handler.callStackSymbols = [NSThread callStackSymbols];
        handler.callStackReturnAddresses = [NSThread callStackReturnAddresses];
        
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
        
        Method method = class_getInstanceMethod([MethodUnrecognizedGuard class], @selector(noneExistedMethod));
        IMP imp = method_getImplementation(method);
        
        BOOL added = class_addMethod([MethodUnrecognizedGuard class], selector, imp, NULL);
        if (added) {
            NSLog(@"added");
        }
        else {
            NSLog(@"not added");
        }
        
        return handler;
    }
    
    return SetBackgroundColorIMP(self, _cmd, selector);
}

#pragma mark - Public Methods

+ (void)inject {
    [WCObjCRuntimeUtility exchangeIMPForSelector:@selector(forwardingTargetForSelector:) onClass:[NSObject class] swizzledIMP:(IMP)MySetBackgroundColor originalIMP:(IMP *)&SetBackgroundColorIMP];
}

#pragma mark -

- (id)noneExistedMethod {
    
    NSMutableString *stringM = [NSMutableString string];
    for (NSString *line in _callStackSymbols) {
        [stringM appendFormat:@"%@\n", line];
    }
    
    NSString *title = [NSString stringWithFormat:@"%@ %@", _className, NSStringFromSelector(_unrecognizedSelector)];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:stringM delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:@"复制", nil];
    
    [alert show];
    
    return nil;
}

@end
