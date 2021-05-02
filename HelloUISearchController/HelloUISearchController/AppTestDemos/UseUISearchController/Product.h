//
//  Product.h
//  HelloUISearchController
//
//  Created by wesley_chen on 2021/5/2.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// @see https://stackoverflow.com/a/58487536
typedef NSString * ProductCodingKeys NS_TYPED_ENUM;
extern ProductCodingKeys const ProductCodingKeyTitle;
extern ProductCodingKeys const ProductCodingKeyYearIntroduced;
extern ProductCodingKeys const ProductCodingKeyIntroPrice;
extern ProductCodingKeys const ProductCodingKeyType;

extern const struct ProductExpressionKeysStruct
{
    __unsafe_unretained NSString *title;
    __unsafe_unretained NSString *yearIntroduced;
    __unsafe_unretained NSString *introPrice;
    __unsafe_unretained NSString *type;
} ProductExpressionKeys;

typedef NS_ENUM(NSUInteger, ProductType) {
    ProductTypeAll,
    ProductTypeBirthdays,
    ProductTypeWeddings,
    ProductTypeFunerals,
};

@interface Product : NSObject <NSCoding>
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) int yearIntroduced;
@property (nonatomic, assign) double introPrice;
@property (nonatomic, assign) int type;

- (instancetype)initWithTitle:(NSString *)title yearIntroduced:(int)yearIntroduced introPrice:(double)introPrice type:(int)type;
- (NSString *)formattedIntroPrice;
+ (NSString *)productTypeNameWithType:(ProductType)type;

@end

NS_ASSUME_NONNULL_END
