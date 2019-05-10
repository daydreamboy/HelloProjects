//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MPMDataDetector.h"
#import "MPMDataDetector.h"

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

- (NSArray<NSTextCheckingResult *> *)runDataDetector:(NSDataDetector *)dataDetector string:(NSString *)string {
    NSLog(@"-----------------------------------");
    NSArray<NSTextCheckingResult *> *arr = [dataDetector matchesInString:string options:kNilOptions range:NSMakeRange(0, string.length)];
    for (NSTextCheckingResult *checkResult in arr) {
        NSLog(@"%@", [string substringWithRange:checkResult.range]);
    }
    NSLog(@"-----------------------------------");
    
    return arr;
}

- (NSArray<MPMDataDetectorCheckResult *> *)runMPMDataDetector:(MPMDataDetector *)dataDetector string:(NSString *)string {
    NSLog(@"-----------------------------------");
    NSArray<MPMDataDetectorCheckResult *> *arr = [dataDetector matchesInString:string options:kNilOptions];
    for (MPMDataDetectorCheckResult *checkResult in arr) {
        NSLog(@"%@", [string substringWithRange:checkResult.range]);
    }
    NSLog(@"-----------------------------------");
    
    return arr;
}

#pragma mark -

- (void)test_check_hyperlink1 {
    NSString *string;
    NSString *matchString;
    NSArray<NSTextCheckingResult *> *matches;
    NSTextCheckingResult *result;
    
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
    
    // Case 5
    string = @"https://item.taobao.com/item.htm?spm=a230r.1.14.13.63956cb9lNHIdB&id=573299987166&ns=1&abbucket=15#detail";
    [self runDataDetector:detector string:string];
    
    // Case 6
    string = @"https://shop.m.taobao.com/shop/shop_index.htm?shopId=117297345#list?catId=1320425474";
    [self runDataDetector:detector string:string];
    
    // Case 7
    string = @"https://aone.alibaba-inc.com/project/853267/issue?spm=a2o8d.corp_prod_issue_detail.0.0.4a8466a747k4YN#filter/filterType=Advanced&advancedFilters=[{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22statusId%22,%22condition%22:%22include%22,%22value%22:%2228+30+32%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22priorityId%22,%22condition%22:%22include%22,%22value%22:%2294+95%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22dateTime%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22createDate%22,%22condition%22:%22morethanEqual%22,%22value%22:%222019-05-05%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22dateTime%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22createDate%22,%22condition%22:%22lessthanEqual%22,%22value%22:%222019-05-09%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22Module%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22Module%22,%22condition%22:%22exclude%22,%22value%22:%22129611%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22}]";
    [self runDataDetector:detector string:string];
    
    // Case 8
    string = @"https://aone.alibaba-inc.com/project/853267/issue?spm=a2o8d.corp_prod_issue_detail.0.0.4a8466a747k4YN#filter/filterType=Advanced&advancedFilters=[{}]";
    matches = [self runDataDetector:detector string:string];
    result = [matches firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(matchString, @"https://aone.alibaba-inc.com/project/853267/issue?spm=a2o8d.corp_prod_issue_detail.0.0.4a8466a747k4YN#filter/filterType=Advanced&advancedFilters=[{}");
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
    MPMDataDetectorCheckResult *result;
    NSString *string;
    NSString *matchString;
    
    MPMDataDetectorCheckResultType types = MPMDataDetectorCheckResultTypePhoneNumber | MPMDataDetectorCheckResultTypeLink | MPMDataDetectorCheckResultTypeEmoticon;
    MPMDataDetector *detector = [[MPMDataDetector alloc] initWithTypes:types error:nil];
 
    // Case 1
//    string = @"测试https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}";
//    [self runMPMDataDetector:detector string:string];
    
    // Case 2
    string = @"测试https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}，/:^_^,这是表情";
    NSArray<MPMDataDetectorCheckResult *> *matches = [self runMPMDataDetector:detector string:string];
    result = [matches firstObject];
    matchString = [string substringWithRange:result.range];
}


- (void)test_check_http_or_https_links {
    NSString *string;
    NSString *matchString;
    NSArray<MPMDataDetectorCheckResult *> *matches;
    MPMDataDetectorCheckResult *result;
    MPMDataDetector *dataDetector = [[MPMDataDetector alloc] initWithTypes:MPMDataDetectorCheckResultTypeLink error:nil];
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fake http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 3
    string = @"http://www.google.com/item.htm?id=1中文中文中文";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 4
    string = @"http://www.google.com/item.htm?id=1中文中文中文 http://www.google.com/item.htm?id=2中文中文中文";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=2");
        }
    }
    
    // Case 4
    string = @"fakehttps://www.google.com/item.htm?id=1 fakehttps://www.google.com/item.htm?id=2 ";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=2");
        }
    }
}

- (void)test_ {
    NSArray<NSTextCheckingResult *> *matches;
    NSTextCheckingResult *result;
    NSDataDetector *detector = [[NSDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    NSString *string;
    
    // Case 1
    string = @"abchttps://www.google.com/";
    matches = [detector matchesInString:string options:kNilOptions range:NSMakeRange(3, [@"https://www.google.com/" length])];
    result = [matches firstObject];
    XCTAssertTrue(result.range.location == 3);
    XCTAssertTrue(result.range.length == 23);
    
    // Case 2
    string = @"a中文https://www.google.com/ sdf";
    matches = [detector matchesInString:string options:kNilOptions range:NSMakeRange(1, [@"中文https://www.google.com/" length])];
    result = [matches firstObject];
    XCTAssertTrue(result.range.location == 3);
    XCTAssertTrue(result.range.length == 23);
}

@end
