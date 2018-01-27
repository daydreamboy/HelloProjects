//
//  GlobalAndMallocBlocks.h
//  HelloBlocks
//
//  Created by wesley_chen on 27/01/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface GlobalBlocks : NSObject
+ (id)block1;
+ (id)block2;
+ (id)block3;
+ (id)block4;
+ (id)block5;
@end

@interface MallocBlocks : NSObject
+ (id)block1;
+ (id)block2;
+ (id)block3;

@end
