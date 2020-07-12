//
//  Tests_UIPasteboard.m
//  Tests
//
//  Created by wesley_chen on 2020/7/12.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>

@interface Tests_UIPasteboard : XCTestCase

@end

@implementation Tests_UIPasteboard

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_create_general_pasteboard {
    UIPasteboard *output1;
    UIPasteboard *output2;
    UIPasteboard *output3;
    
    output1 = [UIPasteboard generalPasteboard];
    output2 = [UIPasteboard pasteboardWithName:UIPasteboardNameGeneral create:NO];
    output3 = [UIPasteboard pasteboardWithName:UIPasteboardNameGeneral create:YES];
    
    XCTAssertTrue(output1 == output2);
    XCTAssertTrue(output1 == output3);
}

- (void)test_create_named_pasteboard {
    UIPasteboard *output1;
    UIPasteboard *output2;
    UIPasteboard *output3;
    UIPasteboard *output4;
    
    // Case 1
    output1 = [UIPasteboard pasteboardWithName:@"pasteboard1" create:YES];
    output2 = [UIPasteboard pasteboardWithName:@"pasteboard2" create:YES];
    
    output3 = [UIPasteboard pasteboardWithName:@"pasteboard1" create:YES];
    output4 = [UIPasteboard pasteboardWithName:@"pasteboard2" create:NO];
    
    XCTAssertFalse(output1 == output2);
    XCTAssertTrue(output1 == output3);
    XCTAssertTrue(output2 == output4);
    
    // Case 2
    output1 = [UIPasteboard pasteboardWithUniqueName];
    output2 = [UIPasteboard pasteboardWithUniqueName];
    XCTAssertFalse(output1 == output2);
}

- (void)test_pasteboardType {
    NSLog(@"Strings:\n%@\n", UIPasteboardTypeListString);
    NSLog(@"URLs:\n%@\n", UIPasteboardTypeListURL);
    NSLog(@"Images:\n%@\n", UIPasteboardTypeListImage);
    NSLog(@"Colors:\n%@\n", UIPasteboardTypeListColor);
    NSLog(@"Automatic:\n%@\n", UIPasteboardTypeAutomatic);
}

- (void)test_single_items {
    id output;
    NSData *data;
    id value;
    NSString *string;
    NSError *error;
    NSDictionary *dict;
    
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"myPasteboard" create:YES];
    
    // Case 1
    pasteboard.string = @"123";
    pasteboard.URL = [NSURL URLWithString:@"https://www.baidu.com/"];
    pasteboard.image = [UIImage imageNamed:@"image.jpeg"];
    pasteboard.color = [UIColor redColor];
    
    XCTAssertNil(pasteboard.string);
    XCTAssertNil(pasteboard.URL);
    XCTAssertNil(pasteboard.image);
    XCTAssertNotNil(pasteboard.color);
    
    // Case 2
    [pasteboard setValue:@"123" forPasteboardType:(id)kUTTypeText];
    output = [pasteboard valueForPasteboardType:(id)kUTTypeText];
    data = [pasteboard dataForPasteboardType:(id)kUTTypeText];
    
    string = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    XCTAssertEqualObjects(output, @"123");
    XCTAssertEqualObjects(string, @"123");
    
    // Case 3
    [pasteboard setValue:@{ @"text": @"123" } forPasteboardType:(id)kUTTypeText];
    value = [pasteboard valueForPasteboardType:(id)kUTTypeText];
    XCTAssertFalse([value isKindOfClass:[NSDictionary class]]);
    
    data = [pasteboard dataForPasteboardType:(id)kUTTypeText];
    dict = [NSPropertyListSerialization propertyListWithData:data options:kNilOptions format:NULL error:&error];
    XCTAssertTrue([dict isKindOfClass:[NSDictionary class]]);
    XCTAssertEqualObjects(dict[@"text"], @"123");
}

- (void)test_multiple_items {
    id output;
    NSData *data;
    NSArray<id> *values;
    NSString *string;
    NSError *error;
    NSDictionary *dict;
    
    UIPasteboard *pasteboard = [UIPasteboard pasteboardWithName:@"myPasteboard" create:YES];
    
    // Case 1
    pasteboard.strings = @[ @"1", @"2", @"3" ];
    
    pasteboard.URLs = @[
        [NSURL URLWithString:@"https://www.baidu.com/"],
        [NSURL URLWithString:@"https://www.taobao.com/"],
    ];
    
    XCTAssertTrue(pasteboard.strings.count == 2);
    XCTAssertEqualObjects(pasteboard.strings[0], @"https://www.baidu.com/");
    XCTAssertEqualObjects(pasteboard.strings[1], @"https://www.taobao.com/");
    
    XCTAssertEqualObjects(pasteboard.URLs[0], [NSURL URLWithString:@"https://www.baidu.com/"]);
    XCTAssertEqualObjects(pasteboard.URLs[1], [NSURL URLWithString:@"https://www.taobao.com/"]);
    
    // Case 2
    [pasteboard setItems:@[
        @{
            (id)kUTTypeText: @"hello, world"
        },
        @{
            (id)kUTTypeText: [UIColor redColor]
        },
        @{
            (id)kUTTypeJPEG: UIImageJPEGRepresentation([UIImage imageNamed:@"image.jpeg"], 1)
        }
    ]];
    
    XCTAssertTrue(pasteboard.items.count == 3);
    
    values = [pasteboard valuesForPasteboardType:(id)kUTTypeText inItemSet:[NSIndexSet indexSetWithIndex:1]];
    data = values.firstObject;
    XCTAssertTrue([data isKindOfClass:[NSData class]]);
    
    id valueByUnarchiver = [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:data error:&error];
    id valueByPlist = [NSPropertyListSerialization propertyListWithData:data options:kNilOptions format:NULL error:&error];
    XCTAssertTrue([valueByUnarchiver isKindOfClass:[UIColor class]]);
    XCTAssertTrue([valueByPlist isKindOfClass:[NSDictionary class]]);
}

@end
