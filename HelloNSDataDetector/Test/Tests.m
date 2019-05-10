//
//  Tests.m
//  Test
//
//  Created by wesley_chen on 2019/2/20.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCDataDetector.h"

@interface Tests : XCTestCase
@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_check_all_links {
    NSString *string;
    NSString *matchString;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"fakehttps://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"fakehttps://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fake http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 3
    string = @"中文http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 4
    string = @"http://www.google.com/item.htm?id=1中文中文中文";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
}

- (void)test_check_http_or_https_links {
    NSString *string;
    NSString *matchString;
    NSArray<NSTextCheckingResult *> *matches;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    dataDetector.forceDetectHttpScheme = YES;
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fake http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 3
    string = @"http://www.google.com/item.htm?id=1中文中文中文";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
    
    // Case 4
    string = @"http://www.google.com/item.htm?id=1中文中文中文http://www.google.com/item.htm?id=2中文中文中文";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=2");
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
            XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=1");
            XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=2");
            XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=2");
        }
    }
    
    // Case 5
    string = @"https://shop.m.taobao.com/shop/shop_index.htm?shopId=117297345#list?catId=1320425474";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    XCTAssertTrue(matches.count == 1);
    result = [matches firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"https://shop.m.taobao.com/shop/shop_index.htm?shopId=117297345#list?catId=1320425474");
    XCTAssertEqualObjects(matchString, @"https://shop.m.taobao.com/shop/shop_index.htm?shopId=117297345#list?catId=1320425474");
    
    // Case 6
    string = @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_={%22appId%22:%2212087020@iphoneos%22}&l_={%22id%22:%226e8bff6bcede1e921cddec4cf9fc47c7%22,%22errorType%22:%22IOS_CRASH%22,%22begin%22:%221555573250414%22,%22end%22:%221555573250414%22,%22subject%22:%22crash%22,%22version%22:%228.6.11.3%22,%22compareVersion%22:%228.6.11.3%22,%22date%22:%221555573250414%22,%22compareDate%22:%221555486850414%22,%22precision%22:%2260%22}";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    XCTAssertTrue(matches.count == 1);
    result = [matches firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertNotEqualObjects(result.URL.absoluteString, @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_={%22appId%22:%2212087020@iphoneos%22}&l_={%22id%22:%226e8bff6bcede1e921cddec4cf9fc47c7%22,%22errorType%22:%22IOS_CRASH%22,%22begin%22:%221555573250414%22,%22end%22:%221555573250414%22,%22subject%22:%22crash%22,%22version%22:%228.6.11.3%22,%22compareVersion%22:%228.6.11.3%22,%22date%22:%221555573250414%22,%22compareDate%22:%221555486850414%22,%22precision%22:%2260%22}");
    XCTAssertEqualObjects(matchString, @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_={%22appId%22:%2212087020@iphoneos%22}&l_={%22id%22:%226e8bff6bcede1e921cddec4cf9fc47c7%22,%22errorType%22:%22IOS_CRASH%22,%22begin%22:%221555573250414%22,%22end%22:%221555573250414%22,%22subject%22:%22crash%22,%22version%22:%228.6.11.3%22,%22compareVersion%22:%228.6.11.3%22,%22date%22:%221555573250414%22,%22compareDate%22:%221555486850414%22,%22precision%22:%2260%22}");
    
    // Case 7
    string = @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_=[{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22statusId%22,%22condition%22:%22include%22,%22value%22:%2228+30+32%22,}]";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    XCTAssertTrue(matches.count == 1);
    result = [matches firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertNotEqualObjects(result.URL.absoluteString, @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_={%22appId%22:%2212087020@iphoneos%22}&l_={%22id%22:%226e8bff6bcede1e921cddec4cf9fc47c7%22,%22errorType%22:%22IOS_CRASH%22,%22begin%22:%221555573250414%22,%22end%22:%221555573250414%22,%22subject%22:%22crash%22,%22version%22:%228.6.11.3%22,%22compareVersion%22:%228.6.11.3%22,%22date%22:%221555573250414%22,%22compareDate%22:%221555486850414%22,%22precision%22:%2260%22}");
    XCTAssertEqualObjects(matchString, @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_={%22appId%22:%2212087020@iphoneos%22}&l_={%22id%22:%226e8bff6bcede1e921cddec4cf9fc47c7%22,%22errorType%22:%22IOS_CRASH%22,%22begin%22:%221555573250414%22,%22end%22:%221555573250414%22,%22subject%22:%22crash%22,%22version%22:%228.6.11.3%22,%22compareVersion%22:%228.6.11.3%22,%22date%22:%221555573250414%22,%22compareDate%22:%221555486850414%22,%22precision%22:%2260%22}");
    
    // Abnormal Case 1: { not allowed by NSDataDetector, see test case in NSDataDetector
    string = @"https://aone.alibaba-inc.com/project/853267/issue?spm=a2o8d.corp_prod_issue_detail.0.0.4a8466a747k4YN#filter/filterType=Advanced&advancedFilters=[{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22statusId%22,%22condition%22:%22include%22,%22value%22:%2228+30+32%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22priorityId%22,%22condition%22:%22include%22,%22value%22:%2294+95%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22dateTime%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22createDate%22,%22condition%22:%22morethanEqual%22,%22value%22:%222019-05-05%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22dateTime%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22createDate%22,%22condition%22:%22lessthanEqual%22,%22value%22:%222019-05-09%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22Module%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22Module%22,%22condition%22:%22exclude%22,%22value%22:%22129611%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22}]";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    XCTAssertTrue(matches.count == 1);
    result = [matches firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(matchString, @"https://aone.alibaba-inc.com/project/853267/issue?spm=a2o8d.corp_prod_issue_detail.0.0.4a8466a747k4YN#filter/filterType=Advanced&advancedFilters=[");
}

- (void)test_check_only_https_links {
    NSString *string;
    NSString *matchString;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    dataDetector.forceDetectHttpScheme = YES;
    dataDetector.allowedLinkSchemes = @[@"https"];
    
    // Case 1
    string = @"fakehttps://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    matchString = [string substringWithRange:result.range];
    XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.google.com/item.htm?id=1");
    XCTAssertEqualObjects(matchString, @"https://www.google.com/item.htm?id=1");
    
    // Case 2
    string = @"fakehttp://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    XCTAssertNil(result);
    
    // Case 3
    string = @"http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    XCTAssertNil(result);
    
    // Case 4
    string = @"中文http://www.google.com/item.htm?id=1";
    result = [[dataDetector matchesInString:string options:kNilOptions] firstObject];
    XCTAssertNil(result);
}

- (void)test_check_multiple_links {
    NSString *string;
    NSString *matchString;
    NSArray<NSTextCheckingResult *> *matches;
    NSTextCheckingResult *result;
    WCDataDetector *dataDetector = [[WCDataDetector alloc] initWithTypes:NSTextCheckingTypeLink error:nil];
    
    // Case 1
    string = @"谷歌http://www.google.com/item.htm?id=1 百度http://www.baidu.com/ 搜狗https://www.sougou.com/";
    matches = [dataDetector matchesInString:string options:kNilOptions];
    
    for (NSInteger i = 0; i < matches.count; i++) {
        result = matches[i];
        matchString = [string substringWithRange:result.range];
        
        if (i == 0) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.google.com/item.htm?id=1");
            XCTAssertEqualObjects(matchString, @"http://www.google.com/item.htm?id=1");
        }
        else if (i == 1) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"http://www.baidu.com/");
            XCTAssertEqualObjects(matchString, @"http://www.baidu.com/");
        }
        else if (i == 2) {
            XCTAssertEqualObjects(result.URL.absoluteString, @"https://www.sougou.com/");
            XCTAssertEqualObjects(matchString, @"https://www.sougou.com/");
        }
    }
}

@end
