//
//  NSObject+Subclass.h
//  HelloCreateDynamicClass
//
//  Created by wesley_chen on 04/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef struct selBlockPair {
    SEL sel;
    id (^__unsafe_unretained block)(id, ...);
} selBlockPair;

#define selBlockPair_nil    ((struct selBlockPair) { 0, 0 })
#define selBlockPair_list   (struct selBlockPair [])
#define selBlockPair_cast   (id (^)(id, ...))

// @see https://stackoverflow.com/questions/12674502/create-custom-dynamic-classes-in-objective-c
@interface NSObject (Subclass)
+ (Class)newSubclassNamed:(NSString *)name protocols:(Protocol **)protocols impls:(selBlockPair *)impls;
@end
