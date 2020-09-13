//
//  WCTraitCollectionTool.h
//  HelloUITraitCollection
//
//  Created by wesley_chen on 2020/9/14.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCTraitCollectionTool : NSObject

+ (NSString *)stringFromSizeClass:(UIUserInterfaceSizeClass)sizeClass;

+ (nullable NSString *)stringInfoWithTraitCollection:(UITraitCollection *)traitCollection;

@end

NS_ASSUME_NONNULL_END
