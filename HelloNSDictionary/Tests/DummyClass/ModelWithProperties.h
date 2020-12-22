//
//  ModelWithProperties.h
//  HelloNSDictionary
//
//  Created by wesley_chen on 2020/12/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCPropertyDictionary.h"

NS_ASSUME_NONNULL_BEGIN

@interface ModelWithProperties : WCPropertyDictionary
@property (nonatomic, strong) NSString *string;
@property (nonatomic, strong) NSNumber *number;
@property (nonatomic, assign) NSUInteger integerValue;
@property (nonatomic, strong) id object;
@end

NS_ASSUME_NONNULL_END
