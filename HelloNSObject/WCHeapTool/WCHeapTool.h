//
//  WCHeapTool.h
//  HelloNSObject
//
//  Created by wesley_chen on 2021/6/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

typedef void (^WCHeapObjectEnumerationBlock)(__unsafe_unretained id object, __unsafe_unretained Class actualClass);

@interface WCHeapTool : NSObject

+ (BOOL)allLiveObjectsWithContainerCountForClass:(out NSMutableDictionary<Class, NSArray *> **)containerCountForClass containerSizesForClass:(out NSMutableDictionary **)containerSizesForClass;
+ (BOOL)enumerateLiveObjectsUsingBlock:(WCHeapObjectEnumerationBlock)block;

@end

NS_ASSUME_NONNULL_END
