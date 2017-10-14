//
//  InterceptDoesNotRecognizeSelectorViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/3/31.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "InterceptDoesNotRecognizeSelectorViewController.h"
#import "WCObjCRuntimeUtility.h"

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
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:NSStringFromSelector(_unrecognizedSelector) message:stringM delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
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
        
        return handle;
    }
    
    return SetBackgroundColorIMP(self, _cmd, selector);
}

@implementation InterceptDoesNotRecognizeSelectorViewController

+ (void)load {
    [WCObjCRuntimeUtility exchangeIMPForSelector:@selector(forwardingTargetForSelector:) onClass:[NSObject class] swizzledIMP:(IMP)MySetBackgroundColor originalIMP:(IMP *)&SetBackgroundColorIMP];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (IBAction)test_callNoneExistMethod:(id)sender {
    [self performSelector:@selector(noneExistedMethod:) withObject:self]; // will crash
}

@end
