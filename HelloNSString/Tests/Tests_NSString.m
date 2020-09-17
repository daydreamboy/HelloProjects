//
//  Tests_NSString.m
//  Tests
//
//  Created by wesley_chen on 2018/10/26.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCStringTool.h"

typedef NS_ENUM(NSUInteger, WCStringShowMode) {
    WCStringShowModeUnknown,
    WCStringShowModeNoneEmoticon,
    WCStringShowModeOnly1To3Emoticon,
    WCStringShowModeOnly4MoreEmoticon,
    WCStringShowModeMixedTextEmoticon,
};

#if __has_feature(objc_arc)

#define toCF (__bridge CFTypeRef)
#define fromCF (__bridge id)

#else

#define toCF (CFTypeRef)
#define fromCF (id)

#endif

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

- (void)test_format {
    //const char bytes[] = { 0x41, 0x4A };
    
    // @see https://stackoverflow.com/a/17938106
    const char *bytes;
    bytes = (char[3]){ 0x41, 0x4A };
    
    printf("%02hhx\n", (unsigned char)bytes[0]);
    printf("%02hhx\n", (unsigned char)bytes[1]);
    printf("%02x\n", (unsigned char)bytes[1]);
}

- (void)test_CFStringTransform_pinyin {
    // @see https://stackoverflow.com/a/34304188
    CFMutableStringRef string;
    
    // Case 1
    string = CFStringCreateMutableCopy(NULL, 0, CFSTR("中文"));
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSLog(@"%@", string);
    XCTAssertEqualObjects(fromCF string, @"zhong wen");
    CFRelease(string);
    
    // Case 2
    string = CFStringCreateMutableCopy(NULL, 0, CFSTR("长春"));
    CFStringTransform(string, NULL, kCFStringTransformMandarinLatin, NO);
    CFStringTransform(string, NULL, kCFStringTransformStripDiacritics, NO);
    NSLog(@"%@", string);
    XCTAssertEqualObjects(fromCF string, @"zhang chun");
    CFRelease(string);
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

- (void)test_xxx {
    NSString *string;
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"Emoticon_new" ofType:@"plist"];
    NSDictionary *dict = [NSDictionary dictionaryWithContentsOfFile:plistPath];
    NSArray *array = [dict allValues];
    NSMutableString *pattern = [NSMutableString string];
    NSUInteger maxLen = 0;
    NSMutableDictionary *emoticonCodeTestMap = [NSMutableDictionary dictionary];
    for (NSArray *items in array) {
        NSString *code = items[1];
        if ([code length] > maxLen) {
            maxLen = [code length];
        }
        [pattern appendString:code];
        emoticonCodeTestMap[code] = @(YES);
        NSLog(@"%@", code);
    }
    NSLog(@"%@", pattern);
    NSLog(@"%ld", maxLen);
    
    WCStringShowMode mode = 0;
    
    // Case WCStringShowModeMixedTextEmoticon
    string = @"/:^_^abc/:^_^/:^_^/:^_^/:^_^/:***";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    string = @"/:087/:0877";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    string = @"/:0877/:087";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);

    string = @"/:/:/:^_^";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    string = @"abc";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    string = @"/:007😁/:007";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    string = @"We’re/:^_^/:^$^/:Q/:815";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    string = @"/:087/:?/:girl/:813/:clock/:807/:'\"\"/:$/:068/:819/:810/:074/:P/:012/:>@</:(OK)/:809/:046/:072/:803/:@/:^W^/:-W/:083/:015/:>O</:C/:027/:028/:O/:812/:^$^/:018/:036/:>W</:b/:)-(/:081/:811/:047/:804/:U*U/:066/:816/:qp/:!/:801/:044/:075/:*&*/:043/:H/:052/:815/:045/:071/:008/:(&)/:814/:-F/:086/:077/:man/:818/:R/:802/:079/:069/:085/:^_^/:>_</:O=O/:808/:806/:076/:8*8/:^O^/:048/:065/:~B/:080/:007/:Y/:817/:084/:020/:plane/:(Zz...)/:026/:067/:\"/:Q/:039/:805/:073/:%/:^x^/:lip ";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeMixedTextEmoticon);
    
    // Case WCStringShowModeOnly1To3Emoticon
    string = @"/:^_^";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeOnly1To3Emoticon);
    
    string = @"/:087/:087";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeOnly1To3Emoticon);
    
    string = @"/:^_^/:^_^/:^_^";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeOnly1To3Emoticon);
    
    // Case WCStringShowModeOnly4MoreEmoticon
    string = @"/:^_^/:^_^/:^_^/:^_^";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeOnly4MoreEmoticon);
    
    string = @"/:087/:?/:girl/:813/:clock/:807/:'\"\"/:$/:068/:819/:810/:074/:P/:012/:>@</:(OK)/:809/:046/:072/:803/:@/:^W^/:-W/:083/:015/:>O</:C/:027/:028/:O/:812/:^$^/:018/:036/:>W</:b/:)-(/:081/:811/:047/:804/:U*U/:066/:816/:qp/:!/:801/:044/:075/:*&*/:043/:H/:052/:815/:045/:071/:008/:(&)/:814/:-F/:086/:077/:man/:818/:R/:802/:079/:069/:085/:^_^/:>_</:O=O/:808/:806/:076/:8*8/:^O^/:048/:065/:~B/:080/:007/:Y/:817/:084/:020/:plane/:(Zz...)/:026/:067/:\"/:Q/:039/:805/:073/:%/:^x^/:lip";
    mode = [self detectEmoticonRenderModeWithString:string emoticonCodeTestMap:emoticonCodeTestMap];
    XCTAssertTrue(mode == WCStringShowModeOnly4MoreEmoticon);
}

- (WCStringShowMode)detectEmoticonRenderModeWithString:(NSString *)string emoticonCodeTestMap:(NSDictionary *)emoticonCodeTestMap {
    NSArray *ranges = [WCStringTool rangesOfSubstringWithString:string substring:@"/:"];
    
    if (ranges.count == 0) {
        return WCStringShowModeMixedTextEmoticon;
    }
    
    NSRange range = [[ranges firstObject] rangeValue];
    if (range.location != 0) {
        return WCStringShowModeMixedTextEmoticon;
    }
    
    WCStringShowMode renderMode = WCStringShowModeMixedTextEmoticon;
    
    if (1 <= ranges.count && ranges.count <= 3) {
        renderMode = WCStringShowModeOnly1To3Emoticon;
    }
    else {
        renderMode = WCStringShowModeOnly4MoreEmoticon;
    }
    
    for (NSUInteger i = 0; i < ranges.count; ++i) {
        NSRange range = [ranges[i] rangeValue];
        NSRange nextRange = i + 1 < ranges.count ? [ranges[i + 1] rangeValue] : NSMakeRange(string.length, 0);
        
        NSUInteger startIndex = range.location;
        NSUInteger endIndex = nextRange.location;
        
        BOOL foundCode = NO;
        NSRange testRange = NSMakeRange(startIndex, endIndex - startIndex);
        NSString *testCode = [WCStringTool substringWithString:string range:testRange byVisualization:NO];
        if (testCode.length && emoticonCodeTestMap[testCode]) {
            foundCode = YES;
        }
        
        if (!foundCode) {
            renderMode = WCStringShowModeMixedTextEmoticon;//WCStringShowModeUnknown;
            break;
        }
    }
    
    return renderMode;
}

- (void)test_methods {
    NSString *string;
    NSString *output;
    
    // Case 1
    string = @"abcd";
    output = [self.class nickNameFromUserName:string];
    
    // Case 2
    NSLog(@"");
}

+ (NSString *)nickNameFromUserName:(NSString *)userName
{
    NSString *result = [userName stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    result = [result stringByReplacingOccurrencesOfString:@"." withString:@""];//去除字符串中所有的.号
    result = [result stringByReplacingOccurrencesOfString:@"," withString:@""];//去除字符串中所有的,号
    if ([result length] <= 2)
    {
        return result;
    }

    // 是纯英文
    NSString *regex = @"^[a-zA-Z\\s]+$";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex];
    BOOL isPureEnglish = [predicate evaluateWithObject:result];
    NSCharacterSet *characterSet = [NSCharacterSet characterSetWithCharactersInString:@"    \n"];
    NSArray *splitResults = [result componentsSeparatedByCharactersInSet:characterSet];
    
    if (isPureEnglish) {
        if (splitResults.count >= 2) {
            // matches 中的前两位
            NSString *firstLetter = splitResults[0];
            NSString *secondLetter = splitResults[1];
            unichar firstChar = firstLetter.length > 0 ? [firstLetter characterAtIndex:0] : '\0';
            unichar secondChar = secondLetter.length > 0 ? [secondLetter characterAtIndex:0] : '\0';
            result = [NSString stringWithFormat:@"%C%C",firstChar, secondChar];
        } else {
            // result 前两位
            result = [result substringToIndex:MIN(result.length, 2)];
        }
    } else {
        if (splitResults.count >= 2) {
            // matches 中的倒数两位
            NSString *firstLetter = splitResults[splitResults.count - 2];
            NSString *secondLetter = splitResults[splitResults.count - 1];
            unichar firstChar = firstLetter.length > 0 ? [firstLetter characterAtIndex:0] : '\0';
            unichar secondChar = secondLetter.length > 0 ? [secondLetter characterAtIndex:0] : '\0';
            result = [NSString stringWithFormat:@"%C%C",firstChar, secondChar];
        } else {
            // result 倒数两位
            result = [result substringWithRange:NSMakeRange([result length] - 2, 2)];
        }
    }
    return result;
}

@end
