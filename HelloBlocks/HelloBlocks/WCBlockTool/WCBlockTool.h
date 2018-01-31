//
//  WCBlockTool.h
//  HelloBlocks
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WCBlockTool : NSObject
+ (BOOL)isBlock:(id _Nullable)block;
@end

@interface WCBlockDescriptor : NSObject

@property (nonatomic, strong, readonly) NSMethodSignature *_Nullable blockSignature;
/**
 The sinagure types: @[ return_type, block_self_type, arg1_type, arg2_type, ... ]
 */
@property (nonatomic, strong, readonly) NSArray<NSString *> *_Nullable blockSignatureTypes;
@property (nonatomic, strong, readonly) id _Nullable block;

- (instancetype _Nullable)initWithBlock:(id _Nullable)block;
- (BOOL)isEqualToSigature:(NSMethodSignature *_Nullable)methodSignature;
- (BOOL)isEqual:(WCBlockDescriptor *_Nullable)object;

@end
