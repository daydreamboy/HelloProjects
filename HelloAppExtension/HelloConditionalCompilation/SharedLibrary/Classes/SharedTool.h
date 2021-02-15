//
//  SharedTool.h
//  SharedLibrary
//
//  Created by wesley_chen on 2021/2/15.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SharedTool : NSObject

+ (nullable UIApplication *)getSharedApplication;

@end

NS_ASSUME_NONNULL_END
