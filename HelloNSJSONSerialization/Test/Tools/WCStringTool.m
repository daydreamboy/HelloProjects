//
//  WCStringTool.m
//  Test
//
//  Created by wesley_chen on 2021/6/1.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCStringTool.h"

@implementation WCStringTool

+ (nullable NSString *)unicodePointStringWithString:(NSString *)string {
    if (![string isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // A -> \U00000041, so length multiply by 10
    NSMutableString *unicodePointString = [NSMutableString stringWithCapacity:string.length * 10];
    
    [string enumerateSubstringsInRange:NSMakeRange(0, string.length) options:NSStringEnumerationByComposedCharacterSequences usingBlock:^(NSString * _Nullable substring, NSRange substringRange, NSRange enclosingRange, BOOL * _Nonnull stop) {
        
        NSUInteger lengthByUnichar = [substring length];
        
        if (lengthByUnichar == 1) {
            unichar buffer[2] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unichar) usedLength:NULL encoding:NSUTF16StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            [unicodePointString appendFormat:@"\\U%08X", buffer[0]];
        }
        else {
            // Note: suppose the maximum length of emoji code point is 20
            const int bufferSize = 21;
            unsigned int buffer[bufferSize] = {0};
            
            [substring getBytes:buffer maxLength:sizeof(unsigned int) * (bufferSize - 1) usedLength:NULL encoding:NSUTF32StringEncoding options:0 range:NSMakeRange(0, substring.length) remainingRange:NULL];
            
            for (int i = 0; i < bufferSize; ++i) {
                unsigned int unicodePoint = buffer[i];
                if (unicodePoint == 0) {
                    break;
                }
                
                [unicodePointString appendFormat:@"\\U%08X", unicodePoint];
            }
        }
    }];

    return unicodePointString;
}

@end
