//
//  Person.h
//  Tests
//
//  Created by wesley_chen on 2019/2/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <JavaScriptCore/JavaScriptCore.h>

@class Person;

@protocol PersonJSExports <JSExport>
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger ageToday;
@property (nonatomic, assign) NSInteger birthYear;

- (NSString *)getFullName;
+ (instancetype)createWithFirstName:(NSString *)firstName lastName:(NSString *)lastName;
@end

@interface Person : NSObject <PersonJSExports>
@property (nonatomic, copy) NSString *firstName;
@property (nonatomic, copy) NSString *lastName;
@property (nonatomic, assign) NSInteger ageToday;
@property (nonatomic, assign) NSInteger birthYear;
@end
