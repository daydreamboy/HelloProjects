//
//  Test_property.m
//  Test
//
//  Created by wesley_chen on 2019/9/8.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <objc/runtime.h>

@interface WCPropertyBox : NSObject
@property (nonatomic, assign) objc_property_t property;
@end

@implementation WCPropertyBox
@end


@interface Test_property : XCTestCase

@end

@implementation Test_property

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_get_properties_of_class {
    NSArray *arr = [[self class] propertiesForClass:[UIWindow class]];
    NSLog(@"%@", arr);
}

+ (NSArray *)propertiesForClass:(Class)class {
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
