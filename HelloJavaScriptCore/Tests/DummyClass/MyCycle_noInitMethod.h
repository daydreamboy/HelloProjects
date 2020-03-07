//
//  MyCycle_noInitMethod.h
//  Tests
//
//  Created by wesley_chen on 2020/3/6.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

NS_ASSUME_NONNULL_BEGIN

@protocol MyCycle_noInitMethodJSExport <JSExport>
@property (nonatomic, assign) CGFloat radius;
@property (nonatomic, assign) CGFloat diameter;
@end

@interface MyCycle_noInitMethod : NSObject <MyCycle_noInitMethodJSExport>
- (instancetype)init;
@end

NS_ASSUME_NONNULL_END
