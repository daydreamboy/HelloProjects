//
//  AllModelsProtocol.h
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/4/7.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol Model_A <NSObject>

#pragma mark - Instance Methods
@required
@property (nonatomic, copy) NSString *name;

@optional
@property (nonatomic, assign) NSUInteger age;

#pragma mark - Class Methods

+ (void)classMethodRequired;

@optional
+ (void)classMethodOptional;

@end

@protocol Model_B <NSObject>
@property (nonatomic, copy) NSString *name;
@end
