//
//  ImageTransformer.m
//  HelloCoreData
//
//  Created by wesley_chen on 12/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "ImageTransformer.h"
#import <UIKit/UIKit.h>

@implementation ImageTransformer

+ (Class)transformedValueClass {
    return [NSData class];
}

+ (BOOL)allowsReverseTransformation {
    return YES;
}

- (id)transformedValue:(id)value {
    if ([value isKindOfClass:[UIImage class]]) {
        return UIImagePNGRepresentation(value);
    }
    return nil;
}

- (id)reverseTransformedValue:(id)value {
    if ([value isKindOfClass:[NSData class]]) {
        return [UIImage imageWithData:value];
    }
    return nil;
}

@end
