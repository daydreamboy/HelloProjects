//
//  WCPropertyDictionary.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2020/12/22.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCPropertyDictionary : NSObject

- (instancetype)init;
- (NSDictionary *)toDictionary;
- (NSMutableDictionary *)toMutableDictionary;

@end

NS_ASSUME_NONNULL_END
