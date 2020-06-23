//
//  WCStringTool.m
//  HelloUIImage
//
//  Created by wesley_chen on 2020/6/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

+ (NSString *)prettySizeWithMemoryBytes:(unsigned long long)memoryBytes {
    NSString *sizeString = [NSByteCountFormatter stringFromByteCount:memoryBytes countStyle:NSByteCountFormatterCountStyleBinary];
    return sizeString;
}

@end
