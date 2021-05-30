//
//  WCFileTool.h
//  HelloNSData
//
//  Created by wesley_chen on 2021/5/30.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCFileTool : NSObject

@end

@interface WCFileTool ()
+ (BOOL)createNewFileAtPath:(NSString *)path overwrite:(BOOL)overwrite error:(NSError * _Nullable * _Nullable)error;
@end

NS_ASSUME_NONNULL_END
