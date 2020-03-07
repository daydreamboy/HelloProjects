//
//  MyCycle.h
//  Tests
//
//  Created by wesley_chen on 2020/3/5.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCycleJSExport <JSExport>

@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign, readonly) CGFloat diameter;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

- (instancetype)initWithRadius:(JSValue *)radius x:(JSValue *)x y:(JSValue *)y;

@end

@interface MyCycle : NSObject <MyCycleJSExport>

@end

NS_ASSUME_NONNULL_END
