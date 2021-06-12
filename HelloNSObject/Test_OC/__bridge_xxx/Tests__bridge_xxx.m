//
//  Tests__bridge_xxx.m
//  Test_OC
//
//  Created by wesley_chen on 2021/6/12.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests__bridge_xxx : XCTestCase

@end

@implementation Tests__bridge_xxx

- (void)test___bridge {
    __weak id weakText = nil;
    {
        CFStringRef stringRef = CFStringCreateWithCString(NULL, "Hello World via bridge", kCFStringEncodingUTF8);
        NSString *text = (__bridge id)stringRef;
        NSLog(@"%@", text);
        
        weakText = text;
        CFRelease(stringRef);
    }
    XCTAssertNil(weakText);
    
    {
        CFStringRef stringRef = CFStringCreateWithCString(NULL, "Hello World via bridge", kCFStringEncodingUTF8);
        NSString *text = (__bridge id)stringRef;
        NSLog(@"%@", text);
        
        weakText = text;
        
        // Warning: stringRef is leaked without calling CFRelease
        //CFRelease(stringRef);
    }
    XCTAssertNotNil(weakText);
}

- (void)test___bridge_transfer {
    __weak id weakText = nil;
    {
        CFStringRef stringRef = CFStringCreateWithCString(NULL, "Hello World via bridge transfer", kCFStringEncodingUTF8);
        NSString *text = (__bridge_transfer id)stringRef;
        NSLog(@"%@", text);
        
        weakText = text;
    }
    
    XCTAssertNil(weakText);
}

- (void)test___bridge_retained {
    __weak id weakText = nil;
    {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", @"Hello World via bridge retained"];
        
        weakText = text;
    }
    XCTAssertNil(weakText);
    
    {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", @"Hello World via bridge retained"];
        CFStringRef stringRef = (__bridge_retained CFStringRef)text;
        
        weakText = text;
        
        CFRelease(stringRef);
    }
    XCTAssertNil(weakText);
    
    {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", @"Hello World via bridge retained"];
        CFStringRef stringRef = (__bridge_retained CFStringRef)text;
        
        weakText = text;
        
        // Warning: stringRef is leaked without calling CFRelease
        //CFRelease(stringRef);
    }
    XCTAssertNotNil(weakText);
}

#pragma mark -

- (void)test_NSString_memory {
    __weak id weakText = nil;
    
    // Case 1: literal NSString is always not released
    {
        NSString *text = @"Hello World via bridge retained";
        
        weakText = text;
    }
    XCTAssertNotNil(weakText);
    
    {
        @autoreleasepool {
            NSString *text = @"Hello World via bridge retained";
            
            weakText = text;
        }
    }
    XCTAssertNotNil(weakText);
    
    // Case 2: NSString's some api translated as literal NSString
    {
        NSString *text = [NSString stringWithString:@"Hello World via bridge retained"];
        
        weakText = text;
    }
    XCTAssertNotNil(weakText);
    
    {
        NSString *text = [[NSString alloc] initWithString:@"Hello World via bridge retained"];
        
        weakText = text;
    }
    XCTAssertNotNil(weakText);
    
    // Case 3: use @autoreleasepool and factory method, e.g. stringWithFormat, to make NSString can be released
    {
        NSString *text = [NSString stringWithFormat:@"%@", @"Hello World via bridge retained"];
        
        weakText = text;
    }
    XCTAssertNotNil(weakText);
    
    {
        @autoreleasepool {
            NSString *text = [NSString stringWithFormat:@"%@", @"Hello World via bridge retained"];
            
            weakText = text;
        }
    }
    XCTAssertNil(weakText);
    
    // Case 4: use alloc/initWithFormat to make NSString can be released
    {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", @"Hello World via bridge retained"];
        NSLog(@"%@", [text class]);
        
        weakText = text;
    }
    XCTAssertNil(weakText);
    
    // Case 5: use alloc/initWithFormat to make NSString can be released, not always works
    {
        NSString *text = [[NSString alloc] initWithFormat:@"%@", @"Hello"];
        NSLog(@"%@", [text class]);
        
        weakText = text;
    }
    XCTAssertNotNil(weakText);
}

@end
