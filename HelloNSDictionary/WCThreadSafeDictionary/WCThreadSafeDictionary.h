//
//  WCThreadSafeDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2018/7/24.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCThreadSafeDictionary : NSMutableDictionary
- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (NSDictionary *)initWithContentsOfFile:(NSString *)path;
- (instancetype)initWithCoder:(NSCoder *)decoder;
- (instancetype)initWithObjects:(const id [])objects forKeys:(const id<NSCopying> [])keys count:(NSUInteger)count;
- (NSUInteger)count;
- (id)objectForKey:(id)key;
- (NSEnumerator *)keyEnumerator;
- (void)setObject:(id)object forKey:(id<NSCopying>)key;
- (void)removeObjectForKey:(id)key;
@end
