//
//  WCTupleClass.h
//  Tests_C
//
//  Created by wesley_chen on 2019/6/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTupleClass : NSObject

+ (id)sentinel;

- (instancetype)initWithObjects:(void *)objects, ...;

@end

NS_ASSUME_NONNULL_END
