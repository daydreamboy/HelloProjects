//
//  Tests_NSString.m
//  Tests
//
//  Created by wesley_chen on 2018/10/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSString : XCTestCase

@end

@implementation Tests_NSString

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_substringWithRange {
    NSString *string;
    NSString *substring;
    
    // Case
    string = @"";
    substring = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = nil;
    substring = [string substringWithRange:NSMakeRange(0, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = @"";
    XCTAssertThrows([string substringWithRange:NSMakeRange(1, 0)]);
    
    // Case
    string = @"123";
    substring = [string substringWithRange:NSMakeRange(2, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = @"123";
    substring = [string substringWithRange:NSMakeRange(3, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = @"123";
    XCTAssertThrows([string substringWithRange:NSMakeRange(3, 1)]);
    
    // Case
    string = @"123";
    XCTAssertThrows([string substringWithRange:NSMakeRange(4, 0)]);
}

- (void)test_rangeOfCharacterFromSet {
    NSString *string;
    NSRange range;
    
    // Case 1
    string = @"abcd";
    range = [string rangeOfCharacterFromSet:[NSCharacterSet characterSetWithCharactersInString:@"[,]"]];
    XCTAssertTrue(range.location == NSNotFound);
}

- (void)test_componentsSeparatedByString {
    NSString *string;
    NSUInteger count;
    NSArray *components;
    
    // Case 1
    string = @"pow";
    components = [string componentsSeparatedByString:@":"];
    count = components.count;
    XCTAssert(count == 1);
    
    // Case 2
    string = @"pow:";
    components = [string componentsSeparatedByString:@":"];
    count = components.count;
    XCTAssert(count == 2);
    
    // Case 3
    string = @":";
    components = [string componentsSeparatedByString:@":"];
    count = components.count;
    XCTAssert(count == 2);
}

- (void)test_componentsSeparatedByString_include_separator {
    NSString *string;
    NSString *separator;
    NSArray *components;
    NSArray *componentsIncludeSeparator;
    
    /*
     separator = `:`
     
     // 1
     :pow
     -->
     "" pow

     // 2
     pow:
     -->
     pow ""

     // 3
     :pow:
     -->
     "" pow ""

     // 4
     :
     -->
     "" ""

     // 5
     ::
     -->
     "" "" ""

     // 6
     pow:pow
     -->
     pow pow
     */
    
    NSArray *(^getComponent)(NSArray *component, NSString *separator) = ^NSArray *(NSArray *components, NSString *separator) {
        NSUInteger numberOfSeparator = components.count - 1;
        NSUInteger count = 0;
        NSMutableArray *componentsIncludeSeparator = [NSMutableArray arrayWithCapacity:components.count];
        
        for (NSUInteger i = 0; i < components.count; ++i) {
            NSString *component = components[i];
            if (component.length == 0) {
                if (count < numberOfSeparator) {
                    [componentsIncludeSeparator addObject:separator];
                }
                ++count;
            }
            else {
                [componentsIncludeSeparator addObject:component];
                
                if (i + 1 < components.count) {
                    NSString *nextComponent = components[i + 1];
                    if (nextComponent.length > 0) {
                        [componentsIncludeSeparator addObject:separator];
                    }
                }
            }
        }
        
        return componentsIncludeSeparator;
    };
    
    // Case 1
    string = @"pow";
    separator = @":";
    components = [string componentsSeparatedByString:separator];
    
    XCTAssert(components.count == 1);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 1);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 2
    string = @":pow";
    components = [string componentsSeparatedByString:separator];
    XCTAssert(components.count == 2);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 2);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 2
    string = @"pow:";
    components = [string componentsSeparatedByString:separator];
    XCTAssert(components.count == 2);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 2);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 2
    string = @":pow:";
    components = [string componentsSeparatedByString:separator];
    XCTAssert(components.count == 3);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 3);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 3
    string = @":";
    components = [string componentsSeparatedByString:separator];
    XCTAssert(components.count == 2);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 1);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 3
    string = @"::";
    components = [string componentsSeparatedByString:separator];
    XCTAssert(components.count == 3);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 2);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 3
   string = @"pow:pow";
   components = [string componentsSeparatedByString:separator];
   XCTAssert(components.count == 2);
   componentsIncludeSeparator = getComponent(components, separator);
   XCTAssertTrue(componentsIncludeSeparator.count == 3);
   XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
    
    // Case 3
    string = @"abc";
    separator = @"b";
    components = [string componentsSeparatedByString:separator];
    XCTAssert(components.count == 2);
    componentsIncludeSeparator = getComponent(components, separator);
    XCTAssertTrue(componentsIncludeSeparator.count == 3);
    XCTAssertEqualObjects([componentsIncludeSeparator componentsJoinedByString:@""], string);
}

- (void)test_commonPrefixWithString_options {
    NSString *string1;
    NSString *string2;
    NSString *output;
    
    // Case 1
    string1 = @"http://www.google.com/item.htm?id=1中文中文中文";
    string2 = @"http://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87";
    output = [string1 commonPrefixWithString:string2 options:kNilOptions];
    XCTAssertEqualObjects(output, @"http://www.google.com/item.htm?id=1");
    
    // Case 2
    string1 = @"abcdhttp://www.google.com/item.htm?id=1中文中文中文";
    string2 = @"http://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87";
    output = [string1 commonPrefixWithString:string2 options:kNilOptions];
    XCTAssertEqualObjects(output, @"");
    
    // Case 2
    string1 = @"abcdhttp://www.google.com/item.htm?id=1中文中文中文";
    string2 = @"ehttp://www.google.com/item.htm?id=1%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87%E4%B8%AD%E6%96%87";
    output = [string1 commonPrefixWithString:string2 options:kNilOptions];
    XCTAssertEqualObjects(output, @"");
}

- (void)test {
#define STR_OF_JSON(...) @#__VA_ARGS__
    NSString *string;
    
    string = STR_OF_JSON({
        "url" : "https:\/\/ossgw.alicdn.com\/rapid-oss-bucket\/publish\/1557840001032\/alimp_message_imba_default.zip"
    });
    
    NSError *jsonError = nil;
    id jsonObject = [NSJSONSerialization JSONObjectWithData:[string dataUsingEncoding:NSUTF8StringEncoding] options:0 error:&jsonError];
    if(!jsonError && jsonObject){
        
    }
    else {
        
    }
    
    string = @"https:\/\/ossgw.alicdn.com\/rapid-oss-bucket\/publish\/1557840001032\/alimp_message_imba_default.zip";
    NSLog(@"%@", string);
}

@end
