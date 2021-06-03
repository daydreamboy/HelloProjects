//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/9/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDataTool.h"
#import "WCXCTestCaseTool.h"
#import <CoreGraphics/CoreGraphics.h>

#include <string>

#import "imsc_pack.h"
#import "casc_pack.h"
#import "mimsc_cmd.h"

#define RangeValue(location, length) ([NSValue valueWithRange:NSMakeRange((location), (length))])
#define PointValue(x, y) ([NSValue valueWithCGPoint:NSMakePoint((x), (y))])

using namespace std;

@interface Tests : XCTestCase

@end

@implementation Tests

#pragma mark - Data MIME Info

- (void)test_MIMETypeInfoWithData {
    NSData *data;
    NSString *filePath;
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"amr" ofType:@"amr"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeAmr);

    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"avi" ofType:@"avi"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeAvi);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"mkv" ofType:@"mkv"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeMkv);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"opus" ofType:@"opus"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeOpus);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"webm" ofType:@"webm"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeWebm);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"xpi" ofType:@"xpi"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool MIMETypeInfoWithData:data].type == WCMIMETypeZip && [WCDataTool checkMIMETypeWithData:data type:WCMIMETypeXpi].type == WCMIMETypeXpi);
    
    filePath = [[NSBundle bundleForClass:self.class] pathForResource:@"heic" ofType:@"heic"];
    data = [NSData dataWithContentsOfFile:filePath];
    XCTAssertTrue([WCDataTool checkMIMETypeWithData:data type:WCMIMETypeHeif].type == WCMIMETypeHeif);
}

- (void)test_checkARMType {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"amr"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    WCMIMETypeInfo *MIMEType = [WCDataTool MIMETypeInfoWithData:data];
    NSLog(@"%@", MIMEType);
    
    [self checkARMTypeWithData:data];
}

- (void)test_checkWAV {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"piano2" ofType:@"wav"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    WCMIMETypeInfo *MIMEType = [WCDataTool MIMETypeInfoWithData:data];
    NSLog(@"%@", MIMEType);
    
    [self checkWAVWithData:data];
}

#pragma mark -

- (BOOL)checkARMTypeWithData:(NSData *)data {
    const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
    
    if (data.length < sizeof(bytes)) {
        return NO;
    }
    
    NSData *subdata = [data subdataWithRange:NSMakeRange(0, sizeof(bytes))];
    
    if (memcmp([subdata bytes], bytes, sizeof(bytes)) == 0) {
        // success
        NSLog(@"YES");
    }
    else {
        NSLog(@"NO");
    }
    
    NSData *amrHeader = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    if ([subdata isEqualToData:amrHeader]) {
        NSLog(@"YES");
        return YES;
    }
    else {
        NSLog(@"NO");
        return NO;
    }
}

- (BOOL)checkWAVWithData:(NSData *)data {
    const unsigned char byteOrder1[] = { 0x52, 0x49, 0x46, 0x46 };
    const unsigned char byteOrder2[] = { 0x57, 0x41, 0x56, 0x45 };
    
    if (data.length < 12) {
        return NO;
    }
    
    NSData *subdata1 = [data subdataWithRange:NSMakeRange(0, sizeof(byteOrder1))];
    NSData *subdata2 = [data subdataWithRange:NSMakeRange(8, sizeof(byteOrder2))];
    
    NSData *wavFlag1 = [NSData dataWithBytes:byteOrder1 length:sizeof(byteOrder1)];
    NSData *wavFlag2 = [NSData dataWithBytes:byteOrder2 length:sizeof(byteOrder2)];
    
    
    if ([subdata1 isEqualToData:wavFlag1] && [subdata2 isEqualToData:wavFlag2]) {
        NSLog(@"YES");
        return YES;
    }
    else {
        NSLog(@"NO");
        return NO;
    }
}

#pragma mark - Data Assistant

- (void)test_saveToTmpWithData {
    NSString *string = @"hello, world!";
    [WCDataTool saveToTmpWithData:[string dataUsingEncoding:NSUTF8StringEncoding]];
}

#pragma mark -

- (void)test_subdataArrayWithData_referringRanges {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"main" ofType:@"dx"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSArray *output;
    
    NSData *header;
    NSData *majorVersion;
    NSData *compileVersion;
    NSData *nameLength;
    NSData *name;
    NSData *version;
    NSData *mainLocation; // 组件区
    NSData *mainSize;
    NSData *mappingLocation;
    NSData *mappingSize;
    NSData *stringLocation;
    NSData *stringSize;
    NSData *exprLocation;
    NSData *exprSize;
    NSData *enumLocation;
    NSData *enumSize;
    
    WCReferringRange *nameLengthRange = ReferringRangeValue(@8, @2, nil, nil);
    WCReferringRange *nameRange = ReferringRangeValue(@10, nil, nil, LengthRefer(nameLengthRange, 2));
    WCReferringRange *versionRange = ReferringRangeValue(nil, @2, LocationRelativeRefer(nameRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    WCReferringRange *mainLocationRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(versionRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *mainSizeRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(mainLocationRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    WCReferringRange *mappingLocationRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(mainSizeRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *mappingSizeRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(mappingLocationRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    WCReferringRange *stringLocationRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(mappingSizeRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *stringSizeRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(stringLocationRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    WCReferringRange *exprLocationRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(stringSizeRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *exprSizeRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(exprLocationRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    WCReferringRange *enumLocationRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(exprSizeRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *enumSizeRange = ReferringRangeValue(nil, @4, LocationRelativeRefer(enumLocationRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    NSArray *ranges = @[
        ReferringRangeValue(@0, @5, nil, nil), // header
        ReferringRangeValue(@5, @1, nil, nil), // majorVersion
        ReferringRangeValue(@6, @2, nil, nil), // compileVersion
        nameLengthRange, // name length,
        nameRange, // Refer to name length (10, nil, nil, lengthToReferIndex, 2)
        versionRange,
        mainLocationRange,
        mainSizeRange,
        mappingLocationRange,
        mappingSizeRange,
        stringLocationRange,
        stringSizeRange,
        exprLocationRange,
        exprSizeRange,
        enumLocationRange,
        enumSizeRange
    ];
    
    output = [WCDataTool subdataArrayWithData:data referringRanges:ranges];
    NSLog(@"%@", output);
    
    header = output[0];
    majorVersion = output[1];
    compileVersion = output[2];
    nameLength = output[3];
    name = output[4];
    version = output[5];
    mainLocation = output[6];
    mainSize = output[7];
    mappingLocation = output[8];
    mappingSize = output[9];
    stringLocation = output[10];
    stringSize = output[11];
    exprLocation = output[12];
    exprSize = output[13];
    enumLocation = output[14];
    enumSize = output[15];
    
    // Analyze
    NSLog(@"total: %ld", (long)data.length);
    NSLog(@"header: %@", [WCDataTool ASCIIStringWithData:header]);
    NSLog(@"majorVersion: %hhd", [WCDataTool charValueWithData:majorVersion]);
    NSLog(@"compileVersion: %hd", [WCDataTool shortValueWithData:compileVersion]);
    NSLog(@"nameLength: %hd", [WCDataTool shortValueWithData:nameLength]);
    NSLog(@"name: %@", [WCDataTool ASCIIStringWithData:name]);
    NSLog(@"mainLocation: %d", [WCDataTool intValueWithData:mainLocation]);
    NSLog(@"mainSize: %d", [WCDataTool intValueWithData:mainSize]);
    NSLog(@"mappingLocation: %d", [WCDataTool intValueWithData:mappingLocation]);
    NSLog(@"mappingSize: %d", [WCDataTool intValueWithData:mappingSize]);
    NSLog(@"stringLocation: %d", [WCDataTool intValueWithData:stringLocation]);
    NSLog(@"stringSize: %d", [WCDataTool intValueWithData:stringSize]);
    NSLog(@"exprLocation: %d", [WCDataTool intValueWithData:exprLocation]);
    NSLog(@"exprSize: %d", [WCDataTool intValueWithData:exprSize]);
    NSLog(@"enumLocation: %d", [WCDataTool intValueWithData:enumLocation]);
    NSLog(@"enumSize: %d", [WCDataTool intValueWithData:enumSize]);
    
    // Note: stringSize不包括头部的countRange
    NSData *stringSectionData = [data subdataWithRange:NSMakeRange([WCDataTool intValueWithData:stringLocation], [WCDataTool intValueWithData:stringSize] + 2)];
    [self parseStringSectionWithData:stringSectionData];
    
    NSData *mainSectionData = [data subdataWithRange:NSMakeRange([WCDataTool intValueWithData:mainLocation], [WCDataTool intValueWithData:mainSize])];
    [self parseMainSectionWithData:mainSectionData];
}

- (void)parseMainSectionWithData:(NSData *)data {
    
    WCReferringRange *firstTagRange = ReferringRangeValue(0, @1, nil, nil); // \0
    WCReferringRange *widgetIDRange = ReferringRangeValue(nil, @8, LocationRelativeRefer(firstTagRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *widgetCountOfBasicAttrsRange = ReferringRangeValue(nil, @2, LocationRelativeRefer(widgetIDRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    NSArray *ranges = @[
        firstTagRange,
        widgetIDRange,
        widgetCountOfBasicAttrsRange
    ];
    
    WCReferringRange *propertyTypeRange = ReferringRangeValue(nil, @2, LocationRelativeRefer(widgetCountOfBasicAttrsRange, WCRangeLocationRelativeAtEnd, 0), nil);
    WCReferringRange *propertyID = ReferringRangeValue(nil, @8, LocationRelativeRefer(propertyTypeRange, WCRangeLocationRelativeAtEnd, 0), nil);
    
    // 基本属性(属性值是静态的)
    // 动态属性(属性存在表达式)
    // 事件属性(属性存在事件)
    
    NSArray *elementRange = @[
        firstTagRange,
        widgetIDRange,
        widgetCountOfBasicAttrsRange
    ];
    
}

- (void)parseStringSectionWithData:(NSData *)data {
    NSLog(@"-----string section-----");
    NSArray *stringsData;
    WCReferringRange *countRange = ReferringRangeValue(@0, @2, nil, nil);
    NSArray *ranges = @[
        countRange
    ];
    
    stringsData = [WCDataTool subdataArrayWithData:data referringRanges:ranges];
    NSData *numberOfStringsData = stringsData[0];
    short numberOfStrings = [WCDataTool shortValueWithData:numberOfStringsData];
    
    NSMutableArray *rangesM = [NSMutableArray array];
    [rangesM addObject:countRange];
    
    WCReferringRange *previousRange = countRange;
    for (short i = 0; i < numberOfStrings; ++i) {
        WCReferringRange *keyRange = ReferringRangeValue(nil, @8, LocationRelativeRefer(previousRange, WCRangeLocationRelativeAtEnd, 0), nil);
        WCReferringRange *lengthRange = ReferringRangeValue(nil, @2, LocationRelativeRefer(keyRange, WCRangeLocationRelativeAtEnd, 0), nil);
        WCReferringRange *valueRange = ReferringRangeValue(nil, nil, LocationRelativeRefer(lengthRange, WCRangeLocationRelativeAtEnd, 0), LengthRefer(lengthRange, 2));
        previousRange= valueRange;
        
        [rangesM addObject:keyRange];
        [rangesM addObject:lengthRange];
        [rangesM addObject:valueRange];
    }
    
    stringsData = [WCDataTool subdataArrayWithData:data referringRanges:rangesM];
    NSLog(@"%@", stringsData);
    
    for (NSUInteger i = 1; i < stringsData.count; i = i + 3) {
        NSLog(@"key: %ld", [WCDataTool longValueWithData:stringsData[i]]);
        NSLog(@"length: %hd", [WCDataTool shortValueWithData:stringsData[i + 1]]);
        NSLog(@"string: %@", [WCDataTool ASCIIStringWithData:stringsData[i + 2]]);
    }
}

#pragma mark - Data Translation

- (void)test_longLongValueWithData {
    long long output;
    
    NSData *data = [@"A" dataUsingEncoding:NSUTF8StringEncoding];
    
    output = [WCDataTool charValueWithData:data];
    NSLog(@"%lld", output);
    
    output = [WCDataTool shortValueWithData:data];
    NSLog(@"%lld", output);
    
    output = [WCDataTool intValueWithData:data];
    NSLog(@"%lld", output);
    
    output = [WCDataTool longValueWithData:data];
    NSLog(@"%lld", output);

    output = [WCDataTool longLongValueWithData:data];
    NSLog(@"%lld", output);

//    NSLog(@"%zu", sizeof(int));
//    NSLog(@"%zu", sizeof(long));
//    NSLog(@"%zu", sizeof(long long));
}

#pragma mark - Data Query

#pragma mark > Image Data Info

- (void)test_imageSizeWithData {
    CGSize output;
    NSData *data;
    NSString *imagePath;
    
    // Case 1
    imagePath = [[NSBundle mainBundle] pathForResource:@"png" ofType:@"png"];
    data = [NSData dataWithContentsOfFile:imagePath];
    output = [WCDataTool imageSizeWithData:data];
    XCTAssertTrue(output.width == 500);
    XCTAssertTrue(output.height == 208);
    
    // Case 2
    imagePath = [[NSBundle mainBundle] pathForResource:@"gif" ofType:@"gif"];
    data = [NSData dataWithContentsOfFile:imagePath];
    output = [WCDataTool imageSizeWithData:data];
    XCTAssertTrue(output.width == 304);
    XCTAssertTrue(output.height == 102);
    
    // Case 3
    imagePath = [[NSBundle mainBundle] pathForResource:@"jpg" ofType:@"jpeg"];
    data = [NSData dataWithContentsOfFile:imagePath];
    output = [WCDataTool imageSizeWithData:data];
    XCTAssertTrue(output.width == 1000);
    XCTAssertTrue(output.height == 1500);
    
    // Case 4
    imagePath = [[NSBundle mainBundle] pathForResource:@"bmp" ofType:@"bmp"];
    data = [NSData dataWithContentsOfFile:imagePath];
    output = [WCDataTool imageSizeWithData:data];
    XCTAssertTrue(output.width == 512);
    XCTAssertTrue(output.height == 512);
}

#pragma mark - Data mmap file

- (void)test_dataUsingMmapWithFilePath {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"big_json" ofType:@"json"];
    NSLog(@"%@", filePath);
    
    [WCXCTestCaseTool timingMesaureAverageWithCount:100 block:^{
        @autoreleasepool {
            __unused NSData *data = [NSData dataWithContentsOfFile:filePath];
        }
    }];
    
    [WCXCTestCaseTool timingMesaureAverageWithCount:100 block:^{
        @autoreleasepool {
            __unused NSData *data = [WCDataTool dataUsingMmapWithFilePath:filePath];
        }
    }];
}

- (void)test_createFileUsingMmapWithPath_data_overwrite_error_1 {
    NSString *filePath = [[NSBundle bundleForClass:[self class]] pathForResource:@"big_json" ofType:@"json"];
    NSLog(@"%@", filePath);
    NSString *outputPath1 = [[[NSBundle bundleForClass:[self class]] bundlePath] stringByAppendingPathComponent:[NSUUID UUID].UUIDString];
    NSString *outputPath2 = [[[NSBundle bundleForClass:[self class]] bundlePath] stringByAppendingPathComponent:[NSUUID UUID].UUIDString];
    
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    
    [WCXCTestCaseTool timingMesaureAverageWithCount:100 block:^{
        @autoreleasepool {
            NSError *error = nil;
            [data writeToFile:outputPath1 options:kNilOptions error:&error];
            XCTAssertNil(error);
        }
    }];
    
    [WCXCTestCaseTool timingMesaureAverageWithCount:100 block:^{
        @autoreleasepool {
            NSError *error = nil;
            [WCDataTool createFileUsingMmapWithPath:outputPath2 data:data overwrite:YES error:&error];
            XCTAssertNil(error);
        }
    }];
}

- (void)test_createFileUsingMmapWithPath_data_overwrite_error_2 {
    NSLog(@"home: %@", NSHomeDirectory());
    
    NSString *resultStr = @"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";
    
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:[NSUUID UUID].UUIDString];
    NSError *error;
    NSData *data;
    BOOL success;
    NSTimeInterval start, end;
    
    
    // Case 1:
    
    data = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
    success = [WCDataTool createFileUsingMmapWithPath:filePath data:data overwrite:YES error:&error];
    XCTAssertTrue(success);
    
    start = CACurrentMediaTime();
    data = [NSData dataWithContentsOfFile:filePath];
    end = CACurrentMediaTime();
    NSLog(@"1: %f", end - start);
    
    start = CACurrentMediaTime();
    data = [WCDataTool dataUsingMmapWithFilePath:filePath];
    end = CACurrentMediaTime();
    NSLog(@"2: %f", end - start);
}

#pragma mark -

- (void)test_float {
    long double f = 28.0 / (488.0 / 12.0);
    NSLog(@"%Lf", f);
}

- (void)test_1 {
    NSString *resultStr = @"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";
    
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:resultStr options:0];
    
    string wStr (decodeData.length, '0');
    memcpy((char *)wStr.data(), decodeData.bytes, decodeData.length);
    string respStr;
    string key;
    MPM::CCascRspSiteApp rsp;
    PACKRETCODE code = rsp.UnpackData(wStr, key);
    if (code == PACK_RIGHT) {
        respStr = rsp.GetRspData();
    }
    if (!respStr.empty()) {
        NSLog(@"not empty!");
    }
    else {
        NSLog(@"empty!");
    }
}

- (void)test_2 {
    NSString *resultStr = @"iAYAAAEBAGMAAAAAAAAI2BIBBgGHrgAAAAAI0HiczVpbi5y5ETWBQDD5EaZh/DRxSqqSVDVgEhvWkLdAHneWIKkkzwSPZ5jpye7G+D3/Mn8l55t1z8WX3Q1svu3GmO8i2urjo1PnlPTb3zz686NHj37X327reavny83vr6/G5cXl+cW43H6/PPj3u81Fvaxnm6Ov3228buvmaLM53OyG4K5fX23Pz/7uY9brN1u8256ejattPbvYHNHhpp/Uy6uxxcDr7fyD4v1ZvdqOy83RrG+uxvtvDjf14uLUN0cBr8b25ByXm9dj+SYf/9x+fzE2R0rvMZnD/3z9+MmTJ++Wv/D5YTpPjp5s3h1v3pxebY+XSR5vxnfL1fHm2T8uXh9vDo83b+vZuHlyc3fm6eamJpNMEtUt1Wk2aw82W5XZXZPazeDryzc3g0+224uj4+M/4s/pW8weg8ez07NnF5fj2Q/oPevnZ3h7dt5O34zTs29Hw93E9fXFm/PquPHzb98ul3+9PH2F58/8/E/Lr3seni7D/uLPRccMTbmULK0NZiJjslazlzm4Lz/o6dX1nKffPV8uvz317cnzQERPT8bp65Pt88AsT8+Gn9a/nf4L3xwzF7On8/L8DN/f356cXF/UtwdfpQNLB5qXixdfHbzERT54iScvD77Sgxevlrd49VIPjJYLfXXwsgQ54BfLQLODF3rzuBwsML0//Pmgx9GFZuGaM7XUY1YisThSIe1d5GeB/osBXnLUEWni385CAkIULx48zRxH7unzgHMU3QEehfM9wGNhUtojvGfDR/qUXkpI7sw5gt9VJ6c2ra+Ld8InZK8WLXMaIbFyiiVS4paD2hcIrjF/Ae/AQiGEfQI8VgWxPQwRago9CSlH00KuRSyvC7jbiL1zrouwVQ9TZYbUyRkC5+kLBP8RwLnEUGSP8E7a3GPJKsVEc3HX1gw/eFQ2s7Qu3pIBb/ZYe4K8jUrUGtvUli2SRv+fBUWwYOzX4ff/GzTagWaobxlVuHTu1aiHUk2biMQReLb0ASUI9B0rs+o9lKxIuq8CP0ztF0bpHumYOKXKzROmHmqBfZDMLtxpRi/tY77+ygBzQrHFl06eRVpVNctpNA+WO+yP7JZ9SGEHcJZwf9WrRloRX59VKnFjiTWHHgjmh9rMksewOmnP8C1dTKjPBrfGVmISSxaDBJG+mMyfJrAKB03rAVzy4EK10EhBIFespfZiLOADHKftGcC0rLOYSyt1+LA4bfGPxTJBHb2EHcB6a4RhK+/bBC34hevB22vV7iyGUIQpz9SSDSXow5xB5r7pw1DjnMwRPLDKQAYqM3ePYoNGiLwrU/eCRiSKD3xYMs0rElhnYG/VW/TZAxZai5i7pzGmkY2xZwjPPlw6Q9EKcQmTUuy5efYOe8C+QzjkfGcE0gMK52BRVgTYgk/NYc6YWJDXuvXZtZUIPQa3943CfTG1uUJ6YXJn75ZmR6GIWHpCsZefpjDcuYa8HsAUXHmYRIkF6qb4iEZkBWjwyCPtGcDcZaiWkKfDaNsoLcPl9loK55La+ABwusP3IX9DDJrjevBGbovoltKEtQUkXvzvwlMUoJzHjHsGb5I0CkXYR87UHTTO3QSYw1dYiuNzvR6CMt9rPWgMvCJ/C7Sqxaaj6DBzpMrKc7TWSmAaVfYM4AnNbfBYI5UJ2yOdGEVrSJrCTqHuAEZOuwNYHzA45MJrpgzUN1HNNtgjDAxZiD1OtwjLA1rvmwTn2JpMUaCZge6YXkcmmkl6l3CLMCeVL7jgGEqIIushnFljlMXjDJbRvSIQFYmtZmtL43XPEB5Lk5RyH6wQNE9aHbceo/Ho7PVTDTZO9xkMg7xmiUtdvEDQZE6XHAKEIcAEswSk/e77ZtJC9Zxyno00oSBXiK3AB08zm51n28HLtoOXPypx2YqtmDKktsQlUcuGasdNE8QX5U7b1M5lz+CtcwDEWBGGlgZwryqEmFTh1lNB8fqUvUUfsJdiTrSiA4ZnGG4mWhuV3iBmjWDPlqQDUud9g3dMomUnJbfKMFuoyIUIyJY+pOT2Kbwi9/eKSlRaMV8sjqz3MLyHwj5L6ZorRBgLTwKPfUNXZFBL5M1qHL2nydm9IsFxQm228hnpjQ924pKxrVjZ3CbSxcjSBsIxXGUYmbvOBl6w1H3Thh5RyczJlHtEPetmSEIaSw9IGbcNnttwnB70zlbElUqCudFQe4pga0W4LAhtDArHhpqxZ7g2mIRRRlja6xpg0LqGNFUxb1zXXWcy3DqycJ+0FlasZlaR1ANhwpiYROQ3U+0FGXN6xLs9Q5ZTaoTQkzMF5J6ao83qIolb4TTtx5EN8BYr+jCfmOZgy55gcYo0JMUYksLldu9936ANpS6dvVCjwtBAa4nbpNFnDYOSfoA22+1uBbTiAbgitiJzIbRew5ys8LRazagN2IXh2nLH8tszeC166KYVVFiapsYBEbNCIVqtzWzXali81l2n4aNuepEV6Uu9D+WcHDmi6ixIasoVcxCbCaF4z/AllwSIpFNichS2hJTrSQqJjzTpU3wTlYfakNOKnTLUXLiuiPVGhmS2bLTV2LrAyyCptX0LwYQQ0QiQ5R6m5YKV13qvblCM0dItfYXu9jIfsJcg0ms6Bu6oo40DO7zXWDZcc66pwOjCMGTeN3hbm3BjVEYtCDvUjDKi+wSyFPson2FveiC+Eal5xa224RHTzD0vpy1ajV0JypscodK57x17HSmrtm4el60KGAVIQkRhFhdjmTujm8Mde8N99upyjGRNbdCmWFmc2E2GDxjzCCGmOXU5ULZn6IbkqYJ+xrAMEF6JIIUGcZS42j1+Sl550MFJrGs2cGqAYegZecwKvGOsqMqheeRZ25Che4Zu1Dqw2JfN95ZjQQIeN52m3jVy6reWl+Kt6dUH/UdwPsUVpRflwEpJncJ0K6OxekfZgJ9AgIdKfILvN+83h7vDxR+OIi/Hi28OI++e3558Xt58fPZ5N+hybPu5j2UM3T68OxeNx3DfBYU+FviYuIx4//ibx49uPv8F9zKPtgAAAAA=";
    
    NSData *decodeData = [[NSData alloc] initWithBase64EncodedString:resultStr options:0];
    
    string wStr (decodeData.length, '0');
    memcpy((char *)wStr.data(), decodeData.bytes, decodeData.length);
    string respStr;
    string key;
    MPM::CCascRspSiteApp rsp;
    PACKRETCODE code = rsp.UnpackData(wStr, key);
    if (code == PACK_RIGHT) {
        respStr = rsp.GetRspData();
    }
    if (!respStr.empty()) {
        NSLog(@"not empty!");
        NSLog(@"%s", respStr.c_str());
    }
    else {
        NSLog(@"empty!");
    }
}

@end
