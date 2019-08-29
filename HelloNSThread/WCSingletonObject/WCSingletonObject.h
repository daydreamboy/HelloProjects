//
//  WCSingletonObject.h
//  WCSingletonObject
//
//  Created by wesley_chen on 2019/7/17.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCSingletonObject : NSObject

@property (nonatomic, assign, getter=isShared) BOOL shared;

#pragma mark - For Subclass

+ (instancetype)sharedInstance;
+ (void)destroySharedInstance;

#pragma mark - For WCSingletonObject

+ (BOOL)checkShareInstanceExistsWithClassName:(NSString *)className;

@end

NS_ASSUME_NONNULL_END
