//
//  Job.h
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Job : NSObject

- (instancetype)initWithName:(NSString *)name;

- (NSString *)name;
- (NSString *)setName:(NSString *)name;

@end
