//
//  GetPropertiesOfClassViewController.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 16/12/8.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "GetPropertiesOfClassViewController.h"

#import <objc/runtime.h>

@interface WCPropertyBox : NSObject
@property (nonatomic, assign) objc_property_t property;
@end

@implementation WCPropertyBox
@end

@interface GetPropertiesOfClassViewController ()

@end

@implementation GetPropertiesOfClassViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self test_get_properties_of_class];
}

- (void)test_get_properties_of_class {
    NSArray *arr = [[self class] propertiesForClass:[UIWindow class]];
    NSLog(@"%@", arr);
}

+ (NSArray *)propertiesForClass:(Class)class
{
    NSMutableArray *boxedProperties = [NSMutableArray array];
    unsigned int propertyCount = 0;
    objc_property_t *propertyList = class_copyPropertyList(class, &propertyCount);
    if (propertyList) {
        for (unsigned int i = 0; i < propertyCount; i++) {
            WCPropertyBox *propertyBox = [[WCPropertyBox alloc] init];
            propertyBox.property = propertyList[i];
            [boxedProperties addObject:propertyBox];
            
            NSString *name = @(property_getName(propertyBox.property));
            NSLog(@"name: %@", name);
        }
        free(propertyList);
    }
    return boxedProperties;
}

@end
