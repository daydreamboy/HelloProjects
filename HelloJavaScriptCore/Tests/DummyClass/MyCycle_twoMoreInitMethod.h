//
//  MyCycle_twoMoreInitMethod.h
//  Tests
//
//  Created by wesley_chen on 2020/3/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCycle_twoMoreInitMethodJSExport <JSExport>
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat diameter;

- (instancetype)init;
- (instancetype)initRadius:(JSValue *)radius;
@end

@interface MyCycle_twoMoreInitMethod : NSObject <MyCycle_twoMoreInitMethodJSExport>

@end

NS_ASSUME_NONNULL_END
