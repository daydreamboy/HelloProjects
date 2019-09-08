//
//  CreateDynamicDelegateViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/4/7.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "CreateDynamicDelegateViewController.h"
#import "NSObject+WCObjCRuntime.h"
#import "WCRTProtocol.h"
#import "AppDelegate.h"
#import <objc/runtime.h>
#import "AllModelsProtocol.h"

@interface CreateDynamicDelegateViewController () <Model_B, Model_A>
@property (nonatomic, weak) id<Model_B> delegate;
@end

@implementation CreateDynamicDelegateViewController

- (NSString *)name {
    return @"Model_B";
}

- (void)setName:(NSString *)name {
    NSLog(@"do nothing");
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self test1];
    [self test2];
    [self test3];
}

- (void)test1 {
    id<Model_A> model1 = [self createDelegateWithProtocolName:@"Model_B"];
    model1.name = @"";
    [model1 setName:@""];
    
    NSLog(@"%@", model1.name);
    NSLog(@"%@", [model1 name]);
}

- (void)test2 {
    [self requestWithParamBlock:^(id<Model_A> param) {
        [param setName:@"Changed"];
    } completion:^{
        
    }];
}

- (void)requestWithParamBlock:(void (^)(id<Model_A> param))preparation completion:(void (^)(void))completion {
    id<Model_A> model = [self createDelegateWithProtocolName:@"Model_A"];
    [model setName:@"Default"];
    preparation(model);
    NSString *name = [model name];
    NSLog(@"%@", name);
}

- (id)createDelegateWithProtocolName:(NSString *)protocolName {
    WCRTProtocol *protocol = [WCRTProtocol protocolWithName:protocolName];
    NSString *name = [protocol name];
    NSLog(@"name: %@", name);
    
    NSArray *array = [protocol methodsRequired:NO instance:NO]; // nil
    array = [protocol methodsRequired:NO instance:YES];
    
    array = [protocol methodsRequired:YES instance:NO];
    array = [protocol methodsRequired:YES instance:YES];
    NSLog(@"array: %@", array);
    
    return nil;
}

- (void)test3 {
    Protocol *p1 = objc_allocateProtocol("Model_A");
    objc_registerProtocol(p1);
    unsigned int count = 0;
    struct objc_method_description *list = protocol_copyMethodDescriptionList(p1, YES, YES, &count);
    for (unsigned int i = 0; i < count; i++) {
        struct objc_method_description des = list[i];
        SEL selector = des.name;
        char *signature = des.types;
        NSLog(@"%@: %@", NSStringFromSelector(selector), [NSString stringWithUTF8String:signature]);
    }
    
    Protocol *aProtocol = objc_allocateProtocol("TestingRuntimeDelegate");
    AppDelegate *appInstance = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    NSLog(@"conformed Protocol ..%d", class_conformsToProtocol([self.delegate class], aProtocol));
    
    protocol_addMethodDescription(aProtocol, @selector(itIsTestDelegate), "methodSignature", NO, NO);
    objc_registerProtocol(aProtocol);
    
    class_addProtocol([appInstance class], aProtocol);
    //NSLog(@"adding Protocol %d",class_addProtocol([appInstance class], aProtocol));
    
    if ([self.delegate conformsToProtocol:@protocol(Model_B)])
    {
        NSLog(@"conformed Protocol ..");
    }
    else
    {
        NSLog(@"conformed Protocol ..%d",class_conformsToProtocol([appInstance class], aProtocol));
        class_conformsToProtocol([self.delegate class], aProtocol);
        /*
        [appInstance performSelector:@selector(itIsTestDelegate)];
         */
    }
}

@end
