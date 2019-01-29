//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPMDataDetector.h"
#import "WCDataDetector.h"

@interface Test_NSDataDetector : XCTestCase

@end

@implementation Test_NSDataDetector

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

#pragma mark -

- (void)runDataDetector:(NSDataDetector *)dataDetector string:(NSString *)string {
    NSLog(@"-----------------------------------");
    NSArray<NSTextCheckingResult *> *arr = [dataDetector matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *checkResult in arr) {
        NSLog(@"%@", [string substringWithRange:checkResult.range]);
    }
    NSLog(@"-----------------------------------");
}

- (void)runMPMDataDetector:(MPMDataDetector *)dataDetector string:(NSString *)string {
    NSLog(@"-----------------------------------");
    NSArray<MPMDataDetectorCheckResult *> *arr = [dataDetector matchesInString:string options:kNilOptions];
    for (MPMDataDetectorCheckResult *checkResult in arr) {
        NSLog(@"%@", [string substringWithRange:checkResult.range]);
    }
    NSLog(@"-----------------------------------");
}

#pragma mark -

- (void)test_check_hyperlink1 {
    NSString *string;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    
    // Case 1
    string = @"http://www.baidu.com/测试连接";
    [self runDataDetector:detector string:string];
    
    // Case 2
    string = @"测试www.google.com/search?newwindow=1&ei=SZdaW9WZC4He8AOOip_oCQ&q=%E4%B8%AD%E5%9B%BD&oq=%E4%B8%AD%E5%9B%BD&gs_l=psy-ab.3..0l10.84214383.84218699.0.84219033.17.16.0.0.0.0.388.1696.2-1j4.6.0....0...1c.1j4.64.psy-ab..12.4.1431.0..0i10k1j0i131k1j0i13k1j0i13i10k1.214.fgai0ZJ2g_k,这是链接";
    [self runDataDetector:detector string:string];
    
    // Case 3
    string = @"测试www.google.com/search?newwindow=1&ei=SZdaW9WZC4He8AOOip_oCQ&q=%E4%B8%AD%E5%9B%BD&oq=%E4%B8%AD%E5%9B%BD&gs_l=psy-ab.3..0l10.84214383.84218699.0.84219033.17.16.0.0.0.0.388.1696.2-1j4.6.0....0...1c.1j4.64.psy-ab..12.4.1431.0..0i10k1j0i131k1j0i13k1j0i13i10k1.214.fgai0ZJ2g_k，这是链接";
    [self runDataDetector:detector string:string];
    
    // Case 4
    string = @"测试https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}";
    [self runDataDetector:detector string:string];
}

- (void)test_check_hyperlink2 {
//    NSString *string;
//    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeRegularExpression error:nil];
//    detector
}

- (void)test_check_email {
    NSString *mail = @"so@so.com";
    NSDataDetector *dataDetector = [NSDataDetector dataDetectorWithTypes:NSTextCheckingTypeLink error:nil];
    NSTextCheckingResult *firstMatch = [dataDetector firstMatchInString:mail options:0 range:NSMakeRange(0, mail.length)];
    BOOL result = [firstMatch.URL isKindOfClass:[NSURL class]] && [firstMatch.URL.scheme isEqualToString:@"mailto"];
    NSLog(@"result: %@", result ? @"YES" : @"NO");
    XCTAssertTrue(result);
}

- (void)test_MPMDataDetector {
    NSString *string;
    MPMDataDetectorCheckResultType types = MPMDataDetectorCheckResultTypePhoneNumber | MPMDataDetectorCheckResultTypeLink | MPMDataDetectorCheckResultTypeEmoticon;
    MPMDataDetector *detector = [[MPMDataDetector alloc] initWithTypes:types error:nil];
 
    // Case 1
//    string = @"测试https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}";
//    [self runMPMDataDetector:detector string:string];
    
    // Case 2
    string = @"测试https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}，/:^_^,这是表情";
    [self runMPMDataDetector:detector string:string];
}

@end
