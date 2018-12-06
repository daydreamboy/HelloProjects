//
//  Person.h
//  Tests
//
//  Created by wesley_chen on 2018/12/4.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Person : NSObject

@property NSString *firstName;
@property NSString *lastName;
@property NSNumber *age;

+ (NSArray<Person *> *)people;

@end
