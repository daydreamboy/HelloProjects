//
//  Name.h
//  Tests
//
//  Created by wesley_chen on 2020/8/11.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Name : NSObject
@property (nonatomic, strong) NSMutableOrderedSet<NSString *> *patterns;

+ (instancetype)nameWithPatterns:(NSArray<NSString *> *)patterns;

@end

NS_ASSUME_NONNULL_END
