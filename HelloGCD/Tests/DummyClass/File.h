//
//  File.h
//  Tests
//
//  Created by wesley_chen on 2019/9/12.
//  Copyright © 2019 wesley chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface File : NSObject
@property (nonatomic, copy) NSString *name;
@property (nonatomic, copy) NSString *content;
@property (nonatomic, copy) NSString *path;
@end

NS_ASSUME_NONNULL_END
