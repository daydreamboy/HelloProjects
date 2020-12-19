//
//  BaseClassC.m
//  Tests_OC
//
//  Created by wesley_chen on 2020/4/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "BaseClassC.h"

@interface BaseClassC ()
@property (nonatomic, strong) NSDictionary *data;
@end

@implementation BaseClassC

- (void)setSomeData:(NSDictionary *)data {
    self.data = data;
}

@end
