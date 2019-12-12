//
//  PrimitivePropertyObject.h
//  Tests
//
//  Created by wesley_chen on 2019/12/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface PrimitivePropertyObject : NSObject

@property (nonatomic, assign) int integerNumber;
@property (nonatomic, assign) float floatNumber;
@property (nonatomic, assign) CGSize size;
@property (nonatomic, assign) CGRect rect;

@end

NS_ASSUME_NONNULL_END
