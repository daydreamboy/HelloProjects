//
//  WCXCTestCaseTool.h
//  Test
//
//  Created by wesley_chen on 2021/3/20.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCXCTestCaseTool : NSObject

@end

@interface WCXCTestCaseTool ()
+ (BOOL)timingMesaureAverageWithCount:(NSUInteger)count block:(void (^)(void))block;
@end

NS_ASSUME_NONNULL_END
