//
//  objc_runtime_name_dummy.h
//  Tests_OC
//
//  Created by wesley_chen on 2021/2/15.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

#define __service(...) __attribute__((objc_runtime_name("COM_"#__VA_ARGS__)))

__attribute__((objc_runtime_name("7eceb275788590faefc1097c0f903ce5")))
@protocol MySecretProtcol <NSObject>
- (void)test_objc_runtime_name;
@end

__attribute__((objc_runtime_name("544cd1f719a0cb56dce50fd51b39852d")))
@interface MySecretClass : NSObject
@end


@protocol MyService <NSObject>
- (void)doSomething;
@end

__service(MyServiceImpl)
@interface MyServiceImpl : NSObject <MyService>

@end

NS_ASSUME_NONNULL_END
