//
//  Person.h
//  HelloNSExpression
//
//  Created by wesley_chen on 2018/12/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Job.h"

@interface Person : NSObject

- (instancetype)initWithName:(NSString *)name;
- (NSString *)setName:(NSString *)name;
- (NSString *)name;

- (Job *)setJob:(Job *)job;
- (Job *)job;

@end
