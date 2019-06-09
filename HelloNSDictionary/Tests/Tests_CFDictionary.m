//
//  Tests_CFDictionary.m
//  Tests
//
//  Created by wesley_chen on 2019/6/7.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <CoreFoundation/CoreFoundation.h>

@interface Tests_CFDictionary : XCTestCase

@end

@implementation Tests_CFDictionary

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_CFMutableDictionaryRef_with_custom_key_types {
    CFMutableDictionaryRef dict;
    NSInteger output1;
    NSString *output2;
    
    // @see https://blog.spacemanlabs.com/2011/08/integers-in-your-collections-nsnumbers-not-my-friend/
    // Casse 1: create dictionary with both non-retained keys and values
    dict = CFDictionaryCreateMutable(NULL, 0, NULL, NULL);
    
    // Setting values
    CFDictionarySetValue(dict, (void *)5, (void *)10);
    
    output1 = (NSInteger)CFDictionaryGetValue(dict, (void *)5);
    
    CFRelease(dict);
    dict = NULL;
    
    XCTAssertTrue(output1 == 10);
    
    // Case 2: create dictionary with non-retained keys and retained values
    dict = CFDictionaryCreateMutable(NULL, 0, NULL, &kCFTypeDictionaryValueCallBacks);
    
    CFDictionarySetValue(dict, (void *)5, @"ultrajoke");
    output2 = (NSString *)CFDictionaryGetValue(dict, (void *)5);
    
    CFRelease(dict);
    dict = NULL;
    
    XCTAssertEqualObjects(output2, @"ultrajoke");
}

// @see https://byronlo.wordpress.com/tag/cfmutabledictionary/
static const void *MyCFDictionaryRetainCallback(CFAllocatorRef allocator, const void *value)
{
    id object = (__bridge id)value;
    return CFRetain((__bridge CFTypeRef)(object));
}

static void MyCFDictionaryReleaseCallback(CFAllocatorRef allocator, const void *value)
{
    id object = (__bridge id)value;
    CFRelease((__bridge CFTypeRef)(object));
}

- (void)test_CFMutableDictionaryRef_with_custom_key_value_callbacks {
    CFMutableDictionaryRef dict;
    NSString *output;
    
    CFDictionaryKeyCallBacks keyCallbacks =
    {
        0,
        MyCFDictionaryRetainCallback,
        MyCFDictionaryReleaseCallback,
        CFCopyDescription,
        CFEqual,
        NULL
    };
    
    CFDictionaryValueCallBacks valueCallbacks =
    {
        0,
        MyCFDictionaryRetainCallback,
        MyCFDictionaryReleaseCallback,
        CFCopyDescription,
        CFEqual
    };
    
    // Note: create dictionary with both key and value retained
    dict = CFDictionaryCreateMutable(NULL, 0, &keyCallbacks, &valueCallbacks);
    CFDictionaryAddValue(dict, CFSTR("key"), CFSTR("value"));
    
    output = CFDictionaryGetValue(dict, (__bridge CFStringRef)@"key");
    
    CFRelease(dict);
    dict = NULL;
    
    XCTAssertEqualObjects(output, @"value");
}

@end
