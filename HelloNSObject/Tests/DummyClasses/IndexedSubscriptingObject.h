//
//  IndexedSubscriptingObject.h
//  Tests
//
//  Created by wesley_chen on 2019/5/28.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface IndexedSubscriptingObject<__covariant ObjectType> : NSObject

- (nullable ObjectType)objectAtIndexedSubscript:(NSUInteger)index;
- (void)setObject:(nullable ObjectType)object atIndexedSubscript:(NSUInteger)index;

@end

NS_ASSUME_NONNULL_END
