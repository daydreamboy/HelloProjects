//
//  NSMutableArray+Cat.h
//  HelloObjCGenerics
//
//  Created by wesley_chen on 05/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

// @see https://stackoverflow.com/questions/32673975/is-there-a-way-to-use-objecttype-in-a-category-on-nsarray
@interface NSMutableArray<ObjectType> (Cat)
- (ObjectType)giveMeACat;
@end
