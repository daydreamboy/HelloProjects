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

#pragma mark - Additions

@interface UIAlertView (Addition)
@property (nonatomic, strong, readonly) NSMutableDictionary *userInfo;
@end

@implementation UIAlertView (Addition)

static const char * const UserInfoObjectTag = "UserInfoObjectTag";

@dynamic userInfo;

- (NSMutableDictionary *)userInfo {
    NSMutableDictionary<NSString *, id> *userInfoM = objc_getAssociatedObject(self, UserInfoObjectTag);
    
    if (userInfoM == nil) {
        userInfoM = [NSMutableDictionary dictionary];
        objc_setAssociatedObject(self, UserInfoObjectTag, userInfoM, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    }
    
    return userInfoM;
}

@end

@interface NSUserDefaults (Addition)
- (NSSet *)setForKey:(NSString *)defaultName;
- (void)setSet:(NSSet *)set forKey:(NSString *)defaultName;
@end

@implementation NSUserDefaults (Addition)
- (NSSet *)setForKey:(NSString *)defaultName {
    NSArray *array = [self arrayForKey:defaultName];
    if (array) {
        return [NSSet setWithArray:array];
    }
    else {
        return nil;
    }
}
- (void)setSet:(NSSet *)set forKey:(NSString *)defaultName {
    if (set) {
        [self setObject:[set allObjects] forKey:defaultName];
    }
    else {
        [self setObject:nil forKey:defaultName];
    }
}
@end


@interface MethodUnrecognizedGuard ()
@property (nonatomic, copy) NSString *className;
@property (nonatomic, assign) SEL unrecognizedSelector;
@property (nonatomic, strong) NSArray<NSString *> *callStackSymbols;
@property (nonatomic, strong) NSArray<NSNumber *> *callStackReturnAddresses;
@end

@implementation MethodUnrecognizedGuard

static id MySetBackgroundColor(id self, SEL _cmd, SEL selector);
static id (*SetBackgroundColorIMP)(id self, SEL _cmd, SEL selector);

static NSMutableSet *sWhiteList = nil;
static NSString *kWhiteList = @"MethodUnrecognizedGuard_kWhiteList";

static id MySetBackgroundColor(id self, SEL _cmd, SEL selector) {
    // TODO: do custom work
    //    SetBackgroundColorIMP(self, _cmd, color);
    //    NSLog(@"_cmd: %@", NSStringFromSelector(selector));
    
    const char *classNameCString = object_getClassName(self);
    NSString *className = [[NSString alloc] initWithUTF8String:classNameCString];
    
    if (!sWhiteList) {
        NSArray *presetWhiteList = @[
                                     @"SomeClassShouldIgnore",
                                     ];

        sWhiteList = [NSMutableSet setWithArray:presetWhiteList];
        
        NSSet *storedWhiteList = [[NSUserDefaults standardUserDefaults] setForKey:kWhiteList];
        if ([storedWhiteList isKindOfClass:[NSSet class]]) {
            [sWhiteList unionSet:storedWhiteList];
        }
    }
    
    BOOL shouldIgnored = NO;
    if ([className hasPrefix:@"_"]) {
        shouldIgnored = YES;
        [sWhiteList addObject:className];
    }
    else {
        if ([sWhiteList containsObject:className]) {
            shouldIgnored = YES;
        }
    }
    
    if (!shouldIgnored) {
        
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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title message:stringM delegate:self.class cancelButtonTitle:@"好的" otherButtonTitles:@"忽略", nil];
    alert.userInfo[@"className"] = (id)_className;
    
    [alert show];
    
    return nil;
}

#pragma mark - UIAlertViewDelegate

+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex != alertView.cancelButtonIndex) {
        if (alertView.userInfo[@"className"]) {
            [sWhiteList addObject:alertView.userInfo[@"className"]];
            
            [[NSUserDefaults standardUserDefaults] setSet:sWhiteList forKey:kWhiteList];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

@end
