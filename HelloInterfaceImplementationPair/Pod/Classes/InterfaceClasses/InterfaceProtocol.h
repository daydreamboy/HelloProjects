//
//  Interface.h
//  HelloNSDataDetector
//
//  Created by wesley_chen on 12/07/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol InterfaceProtocol <NSObject>

@property (nonatomic, copy) NSString *someString;
@property (nonatomic, copy, readonly) NSString *readonlyString;
@property (nonatomic, assign) NSInteger numberInteger;

@property (nonatomic, copy, readonly) void (^helloBlock)(void);
- (void)setHelloBlock:(void (^)(void))helloBlock;

- (void)setHelloWhoBlock:(void (^)(NSString *who))helloWhoBlock;
- (void)helloToPersion:(NSString *)who;

@end
