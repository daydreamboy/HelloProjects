//
//  ItemContainer.h
//  HelloObjCGenerics
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ItemContainer<__covariant ObjectType> : NSObject
- (void)addItem:(ObjectType)item forKey:(NSString *)key;
@end
