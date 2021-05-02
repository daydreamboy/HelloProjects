//
//  Product.m
//  HelloUISearchController
//
//  Created by wesley_chen on 2021/5/2.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "Product.h"

ProductCodingKeys const ProductCodingKeyTitle = @"ProductCodingKeyTitle";
ProductCodingKeys const ProductCodingKeyYearIntroduced = @"ProductCodingKeyYearIntroduced";
ProductCodingKeys const ProductCodingKeyIntroPrice = @"ProductCodingKeyIntroPrice";
ProductCodingKeys const ProductCodingKeyType = @"ProductCodingKeyType";

const struct ProductExpressionKeysStruct ProductExpressionKeys =
{
    .title = @"title",
    .yearIntroduced = @"yearIntroduced",
    .introPrice = @"introPrice",
    .type = @"type",
};

@implementation Product

- (instancetype)initWithTitle:(NSString *)title yearIntroduced:(int)yearIntroduced introPrice:(double)introPrice type:(int)type {
    self = [super init];
    if (self) {
        _title = title;
        _yearIntroduced = yearIntroduced;
        _introPrice = introPrice;
        _type = type;
    }
    return self;
}

- (NSString *)formattedIntroPrice {
    NSNumberFormatter *formatter = [NSNumberFormatter new];
    formatter.numberStyle = NSNumberFormatterCurrencyStyle;
    formatter.formatterBehavior = NSDateFormatterBehaviorDefault;
    
    return [formatter stringFromNumber:@(_introPrice)];
}

+ (NSString *)productTypeNameWithType:(ProductType)type {
    switch (type) {
        case ProductTypeAll:
            return NSLocalizedString(@"AllTitle", @"");
        case ProductTypeBirthdays:
            return NSLocalizedString(@"BirthdaysTitle", @"");
        case ProductTypeWeddings:
            return NSLocalizedString(@"WeddingsTitle", @"");
        case ProductTypeFunerals:
            return NSLocalizedString(@"FuneralsTitle", @"");
        default:
            return @"";
    }
}

#pragma mark - NSCoding

- (void)encodeWithCoder:(nonnull NSCoder *)coder {
    [coder encodeObject:_title forKey:ProductCodingKeyTitle];
    [coder encodeInt:_yearIntroduced forKey:ProductCodingKeyTitle];
    [coder encodeDouble:_introPrice forKey:ProductCodingKeyIntroPrice];
    [coder encodeInt:_type forKey:ProductCodingKeyType];
}

- (nullable instancetype)initWithCoder:(nonnull NSCoder *)coder {
    self = [super init];
    
    if (self) {
        _title = [coder decodeObjectForKey:ProductCodingKeyTitle];
        _yearIntroduced = [coder decodeIntForKey:ProductCodingKeyYearIntroduced];
        _introPrice = [coder decodeDoubleForKey:ProductCodingKeyIntroPrice];
        _type = [coder decodeIntForKey:ProductCodingKeyType];
    }
    
    return self;
}

@end
