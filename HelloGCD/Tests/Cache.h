//
//  Cache.h
//  Tests
//
//  Created by wesley_chen on 2019/5/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol Cache <NSObject>
- (id)objectForKey:(NSString *)key;
- (void)setObject:(id)object forKey:(NSString *)key;
- (void)removeObject:(id)object forKey:(NSString *)key;
@end

NS_ASSUME_NONNULL_END
