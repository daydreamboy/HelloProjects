//
//  Tests_NSURL.m
//  Test
//
//  Created by wesley_chen on 2018/9/27.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSURL : XCTestCase

@end

@implementation Tests_NSURL

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_NSURL {
    NSString *url;
    NSURL *URL;
    
    // Case 1: URL is nil, query not allow `{` and `}`
    // Note: Chrome and Safari can open the url
    url = @"https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}";
    URL = [NSURL URLWithString:url];
    XCTAssertNil(URL);

    // Case 2: URL is ok, because url encode `{` and `}` to `%7B` and `%7D`
    url = @"https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam=%7B%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22%7D";
    URL = [NSURL URLWithString:url];
    XCTAssertNotNil(URL);
    
    // Case 3: @see https://stackoverflow.com/questions/48576329/ios-urlstring-not-working-always
    url = @"http://akns-images.eonline.com/eol_images/Entire_Site/2018029/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg?fit=inside|900:auto";
    URL = [NSURL URLWithString:url];
    XCTAssertNil(URL);
    
    // Case 4
    url = @"https://item.taobao.com/item.htm?spm=a230r.1.14.13.63956cb9lNHIdB&id=573299987166&ns=1&abbucket=15#detail";
    URL = [NSURL URLWithString:url];
    XCTAssertNotNil(URL);
    
    // Case 5
    url = @"https://shop.m.taobao.com/shop/shop_index.htm?shopId=117297345#list?catId=1320425474";
    URL = [NSURL URLWithString:url];
    XCTAssertNotNil(URL);
    XCTAssertEqualObjects(URL.fragment, @"list?catId=1320425474");
    
    // Case 6: contains invalid characters: 中文中文中文
    url = @"http://www.google.com/item.htm?id=1中文中文中文";
    URL = [NSURL URLWithString:url];
    XCTAssertNil(URL);
    
    // Case 7: url accepted by Chrome, but contains invalid characters: {}
    url = @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=/converge/detail/:appId&g_={%22appId%22:%2212087020@iphoneos%22}&l_={%22id%22:%226e8bff6bcede1e921cddec4cf9fc47c7%22,%22errorType%22:%22IOS_CRASH%22,%22begin%22:%221555573250414%22,%22end%22:%221555573250414%22,%22subject%22:%22crash%22,%22version%22:%228.6.11.3%22,%22compareVersion%22:%228.6.11.3%22,%22date%22:%221555573250414%22,%22compareDate%22:%221555486850414%22,%22precision%22:%2260%22}";
    url = @"https://ha.emas.alibaba-inc.com/#/page/crash?r_={}";
    URL = [NSURL URLWithString:url];
    XCTAssertNil(URL);
    
    // Case 8: url accepted by Chrome, but contains invalid characters: {}
    url = @"https://aone.alibaba-inc.com/project/853267/issue?spm=a2o8d.corp_prod_issue_detail.0.0.4a8466a747k4YN#filter/filterType=Advanced&advancedFilters=[{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22statusId%22,%22condition%22:%22include%22,%22value%22:%2228+30+32%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22list%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22priorityId%22,%22condition%22:%22include%22,%22value%22:%2294+95%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22dateTime%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22createDate%22,%22condition%22:%22morethanEqual%22,%22value%22:%222019-05-05%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22dateTime%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22createDate%22,%22condition%22:%22lessthanEqual%22,%22value%22:%222019-05-09%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22},{%22type%22:%22Module%22,%22leftParentheses%22:%22false%22,%22fieldName%22:%22Module%22,%22condition%22:%22exclude%22,%22value%22:%22129611%22,%22rightParentheses%22:%22false%22,%22andOr%22:%22AND%22}]";
    URL = [NSURL URLWithString:url];
    XCTAssertNil(URL);
    
    // Case 9:
    url = @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=[";
    URL = [NSURL URLWithString:url];
    XCTAssertNotNil(URL);
    
    // Case 10:
    url = @"https://ha.emas.alibaba-inc.com/#/page/crash?r_=[]";
    URL = [NSURL URLWithString:url];
    XCTAssertNotNil(URL);
    
    // Case 11: url contains invisible characters at the end
    url = @"https://www.baidu.com/​";
    URL = [NSURL URLWithString:url];
    XCTAssertNil(URL);
    
    url = [url stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    URL = [NSURL URLWithString:url];
    XCTAssertNotNil(URL);
}

- (void)test_pathExtension {
    NSString *url;
    NSURL *URL;
    
    url = @"http://xx/xxx.gif?suffix=jpg";
    URL = [NSURL URLWithString:url];
    XCTAssertEqualObjects([URL pathExtension], @"gif");
}

@end
