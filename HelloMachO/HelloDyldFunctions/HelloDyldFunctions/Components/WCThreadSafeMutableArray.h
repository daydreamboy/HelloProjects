//
//  WCThreadSafeMutableArray.h
//  HelloDyldFunctions
//
//  Created by wesley_chen on 2018/8/7.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCThreadSafeMutableArray : NSMutableDictionary
- (instancetype)init;
- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (NSUInteger)count;
- (void)addObject:(id)object;
//- (NSEnumerator *)keyEnumerator;
@end
