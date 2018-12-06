//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCURLTool.h"
#import "WCURLTool_Testing.h"

@interface Model : NSObject {
    @public
    NSString *_string2;
}
//@property (nonatomic, copy) NSString *string;
@end

@implementation Model
@end

@interface Test : XCTestCase
@property (nonatomic, assign) NSRange range;
@end

@implementation Test

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_URLComponentsWithUrlString {
    NSString *urlString;
    WCURLComponents *components;
    
    // Case 1
    urlString = @"http://a:80/b/c/d;p?q";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"http");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"a");
    XCTAssertEqualObjects(components.port, @80);
    XCTAssertEqualObjects(components.path, @"/b/c/d");
    XCTAssertNil(components.pathExtension);
    XCTAssertEqualObjects(components.parameterString, @"p");
    XCTAssertEqualObjects(components.query, @"q");
    XCTAssertNil(components.fragment);
    XCTAssertNil(components.queryItems);
    XCTAssertNil(components.queryKeyValues);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange([urlString rangeOfString:@";p"].location + 1, 1)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"q"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, NSMakeRange(0, 0)));
    
    // Case 2
    urlString = @"http://username:password@www.example.com:8080/index.html?key1=value1&key2=value2#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"http");
    XCTAssertEqualObjects(components.user, @"username");
    XCTAssertEqualObjects(components.password, @"password");
    XCTAssertEqualObjects(components.host, @"www.example.com");
    XCTAssertEqualObjects(components.port, @8080);
    XCTAssertEqualObjects(components.path, @"/index.html");
    XCTAssertEqualObjects(components.pathExtension, @"html");
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"key1=value1&key2=value2");
    XCTAssertEqualObjects(components.fragment, @"jumpLocation");
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    XCTAssertEqualObjects([components.queryItems[1] name], @"key2");
    XCTAssertEqualObjects([components.queryItems[1] value], @"value2");
    XCTAssertTrue(components.queryKeyValues.count == 2);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, [urlString rangeOfString:@"username"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, [urlString rangeOfString:@"password"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"www.example.com"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"8080"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/index.html"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, [urlString rangeOfString:@"html"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"key1=value1&key2=value2"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Case 3
    urlString = @"http://a:80/b/c/d?q=http://a:80/b/c/d#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"http");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"a");
    XCTAssertEqualObjects(components.port, @80);
    XCTAssertEqualObjects(components.path, @"/b/c/d");
    XCTAssertNil(components.pathExtension);
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"q=http://a:80/b/c/d");
    XCTAssertEqualObjects(components.fragment, @"jumpLocation");
    XCTAssertEqualObjects([components.queryItems[0] name], @"q");
    XCTAssertEqualObjects([components.queryItems[0] value], @"http://a:80/b/c/d");
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"q=http://a:80/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Case 4
    urlString = @"http://a:80/b/c/d;p?key1=value1#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    XCTAssertNil(components.pathExtension);
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange([urlString rangeOfString:@";p"].location + 1, 1)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"key1=value1"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Case 5
    urlString = @"http://www.ics.uci.edu/pub/ietf/uri/#Related";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"http");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"www.ics.uci.edu");
    XCTAssertNil(components.port);
    XCTAssertEqualObjects(components.path, @"/pub/ietf/uri/");
    XCTAssertNil(components.pathExtension);
    XCTAssertNil(components.parameterString);
    XCTAssertNil(components.query);
    XCTAssertEqualObjects(components.fragment, @"Related");
    XCTAssertNil(components.queryItems);
    XCTAssertNil(components.queryKeyValues);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"www.ics.uci.edu"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/pub/ietf/uri/"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"Related"]));
    
    // Case 6
    urlString = @"wangx://ut/card?page=Page_Message&event=2101&arg1=&arg2=&arg3=&flags=k1,k2,k3&cardtype=1001";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.queryKeyValues[@"page"], @"Page_Message");
    XCTAssertEqualObjects(components.queryKeyValues[@"event"], @"2101");
    XCTAssertEqualObjects(components.queryKeyValues[@"arg1"], @"");
    XCTAssertEqualObjects(components.queryKeyValues[@"arg2"], @"");
    XCTAssertEqualObjects(components.queryKeyValues[@"arg3"], @"");
    XCTAssertEqualObjects(components.queryKeyValues[@"flags"], @"k1,k2,k3");
    XCTAssertEqualObjects(components.queryKeyValues[@"cardtype"], @"1001");
    
    // Case 7
    urlString = @"wangwang://hongbao/query?hongbaoId=13314001535794922&hongbaoType=0&sender=cntaobaoqn店铺测试账号001:晨凉&note=恭喜发财，大吉大利！&hongbaoSubType=0";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.queryKeyValues[@"hongbaoId"], @"13314001535794922");
    XCTAssertEqualObjects(components.queryKeyValues[@"hongbaoType"], @"0");
    XCTAssertEqualObjects(components.queryKeyValues[@"sender"], @"cntaobaoqn店铺测试账号001:晨凉");
    XCTAssertEqualObjects(components.queryKeyValues[@"note"], @"恭喜发财，大吉大利！");
    XCTAssertEqualObjects(components.queryKeyValues[@"hongbaoSubType"], @"0");
    
    // Case 8
    urlString = @"http://m.cp.360.cn/news/mobile/150410515.html?act=1&reffer=ios&titleRight=share&empty=";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.queryKeyValues[@"act"], @"1");
    XCTAssertEqualObjects(components.queryKeyValues[@"reffer"], @"ios");
    XCTAssertEqualObjects(components.queryKeyValues[@"titleRight"], @"share");
    XCTAssertEqualObjects(components.queryKeyValues[@"empty"], @"");
    
    // Case 9
    urlString = @"wangxs://multiaction/and?multi=%5B%22wangx%3A%2F%2Fh5%2Fopen%3Furl%3Dhttp%253a%252f%252fwww.taobao.com%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3DpopBubble%26strategy%3Dtransient%26bubbleBizType%3Dtest%26conversationId%3Dcnhhupanww%E5%BA%97%E9%93%BA%E6%B5%8B%E8%AF%95%E8%B4%A6%E5%8F%B7003%22%5D";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.queryKeyValues[@"multi"], @"%5B%22wangx%3A%2F%2Fh5%2Fopen%3Furl%3Dhttp%253a%252f%252fwww.taobao.com%22%2C%22wangx%3A%2F%2Fmenu%2Fdismiss%3Fmenuname%3DMenuNameForShowType%26container%3DpopBubble%26strategy%3Dtransient%26bubbleBizType%3Dtest%26conversationId%3Dcnhhupanww%E5%BA%97%E9%93%BA%E6%B5%8B%E8%AF%95%E8%B4%A6%E5%8F%B7003%22%5D");
    
    // Case 10
    urlString = @"https://qngateway.taobao.com/gw/wwjs/multi.resource.emoticon.query?id=144";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.queryKeyValues[@"id"], @"144");
    
    // Case 11
    urlString = @"http://interface.im.taobao.com/mobileimweb/fileupload/downloadPriFile.do?type=0&fileId=8f3371144e1317eabc789ea175644e57.jpg&suffix=jpg&width=750&height=555&mediaSize=516784&fromId=cntaobaowc%E6%B5%8B%E8%AF%95%E8%B4%A6%E5%8F%B71000&thumb_width=80&thumb_height=80";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.queryKeyValues[@"type"], @"0");
    XCTAssertEqualObjects(components.queryKeyValues[@"fileId"], @"8f3371144e1317eabc789ea175644e57.jpg");
    XCTAssertEqualObjects(components.queryKeyValues[@"suffix"], @"jpg");
    XCTAssertEqualObjects(components.queryKeyValues[@"width"], @"750");
    XCTAssertEqualObjects(components.queryKeyValues[@"height"], @"555");
    XCTAssertEqualObjects(components.queryKeyValues[@"mediaSize"], @"516784");
    XCTAssertEqualObjects(components.queryKeyValues[@"fromId"], @"cntaobaowc%E6%B5%8B%E8%AF%95%E8%B4%A6%E5%8F%B71000");
    XCTAssertEqualObjects(components.queryKeyValues[@"thumb_width"], @"80");
    XCTAssertEqualObjects(components.queryKeyValues[@"thumb_height"], @"80");
    
    // Case 12: base64 string
    urlString = @"wangx://p2pconversation/sendText?text=aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=&toLongId=amFjaw==";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.scheme, @"wangx");
    XCTAssertEqualObjects(components.host, @"p2pconversation");
    XCTAssertEqualObjects(components.path, @"/sendText");
    XCTAssertEqualObjects(components.queryKeyValues[@"text"], @"aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=");
    XCTAssertEqualObjects(components.queryKeyValues[@"toLongId"], @"amFjaw==");
    
    // Case 13: base64 string
    urlString = @"wangx://p2pconversation/sendText?toLongId=amFjaw==&text=aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.scheme, @"wangx");
    XCTAssertEqualObjects(components.host, @"p2pconversation");
    XCTAssertEqualObjects(components.path, @"/sendText");
    XCTAssertEqualObjects(components.queryKeyValues[@"text"], @"aHR0cHM6Ly9kZXRhaWwudG1hbGwuY29tL2l0ZW0uaHRtP2lkPTU3MzY2NjQ2MDM1NSZhbGlfcmVmaWQ9YTNfNDIwNDMyXzEwMDY6MTExMDgxNzMyMjpOOiVFOSU5QiU4NiVFNiU4OCU5MCVFNyU4MSVCNjpmYzc4NjljYjZlM2M3OGU4ZjJkYjZkYjg4NTNkNzViZSZhbGlfdHJhY2tpZD0xX2ZjNzg2OWNiNmUzYzc4ZThmMmRiNmRiODg1M2Q3NWJlJnNwbT1hMjMwci4xLjE0LjE=");
    XCTAssertEqualObjects(components.queryKeyValues[@"toLongId"], @"amFjaw==");
    
    // Abnormal Case 1
    urlString = @"http://a:80/b/c/d;p?key1=#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], [urlString rangeOfString:@"key1"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], NSMakeRange(0, 0)));
    XCTAssertNil(components.pathExtension);
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange([urlString rangeOfString:@";p"].location + 1, 1)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"key1="]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Abnormal Case 2
    urlString = @"http://a:80/b/c/d;p?=value1#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], [urlString rangeOfString:@"value1"]));
    XCTAssertNil(components.pathExtension);
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange([urlString rangeOfString:@";p"].location + 1, 1)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"=value1"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Abnormal Case 3
    urlString = @"http://a:80/b/c/d;p?=#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], NSMakeRange(0, 0)));
    XCTAssertNil(components.pathExtension);
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange([urlString rangeOfString:@";p"].location + 1, 1)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"="]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Abnormal Case 4
    urlString = @"http://a:80/b/c/d;p?==#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertTrue([components.queryItems count] == 1);
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"=");
    XCTAssertNil(components.pathExtension);
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"a"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, [urlString rangeOfString:@"80"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/b/c/d"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange([urlString rangeOfString:@";p"].location + 1, 1)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"=="]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, [urlString rangeOfString:@"jumpLocation"]));
    
    // Abnormal Case 5
    urlString = @"https://detail.tmall.com/item.htm?id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"https");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"detail.tmall.com");
    XCTAssertNil(components.port);
    XCTAssertEqualObjects(components.path, @"/item.htm");
    XCTAssertEqualObjects(components.pathExtension, @"htm");
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 5);
    XCTAssertEqualObjects([components.queryItems[0] name], @"id");
    XCTAssertEqualObjects([components.queryItems[0] value], @"568371443233");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], [urlString rangeOfString:@"id"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], [urlString rangeOfString:@"568371443233"]));
    XCTAssertEqualObjects([components.queryItems[1] name], @"spm");
    XCTAssertEqualObjects([components.queryItems[1] value], @"a223v.7835278.t0.1.3cbe2312nwviTo");
    XCTAssertTrue(NSEqualRanges([components.queryItems[1] rangeOfName], [urlString rangeOfString:@"spm"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[1] rangeOfValue], [urlString rangeOfString:@"a223v.7835278.t0.1.3cbe2312nwviTo"]));
    XCTAssertEqualObjects([components.queryItems[2] name], @"pvid");
    XCTAssertEqualObjects([components.queryItems[2] value], @"be2a1b12-f24f-4050-9227-e7c3448fd8b8");
    XCTAssertTrue(NSEqualRanges([components.queryItems[2] rangeOfName], [urlString rangeOfString:@"pvid"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[2] rangeOfValue], [urlString rangeOfString:@"be2a1b12-f24f-4050-9227-e7c3448fd8b8"]));
    XCTAssertEqualObjects([components.queryItems[3] name], @"scm");
    XCTAssertEqualObjects([components.queryItems[3] value], @"1007.12144.81309.9011_8949");
    XCTAssertTrue(NSEqualRanges([components.queryItems[3] rangeOfName], [urlString rangeOfString:@"scm"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[3] rangeOfValue], [urlString rangeOfString:@"1007.12144.81309.9011_8949"]));
    XCTAssertEqualObjects([components.queryItems[4] name], @"utparam");
    XCTAssertEqualObjects([components.queryItems[4] value], @"{%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}");
    XCTAssertTrue(NSEqualRanges([components.queryItems[4] rangeOfName], [urlString rangeOfString:@"utparam"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[4] rangeOfValue], [urlString rangeOfString:@"{%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}"]));
    XCTAssertTrue(components.queryKeyValues.count == 5);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"https"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"detail.tmall.com"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/item.htm"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, [urlString rangeOfString:@"htm"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, NSMakeRange(0, 0)));
    
    // Abnormal Case 6: @see https://stackoverflow.com/questions/48576329/ios-urlstring-not-working-always
    urlString = @"http://akns-images.eonline.com/eol_images/Entire_Site/2018029/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg?fit=inside|900:auto";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"http");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"akns-images.eonline.com");
    XCTAssertNil(components.port);
    XCTAssertEqualObjects(components.path, @"/eol_images/Entire_Site/2018029/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg");
    XCTAssertEqualObjects(components.pathExtension, @"jpg");
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"fit=inside|900:auto");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 1);
    XCTAssertEqualObjects([components.queryItems[0] name], @"fit");
    XCTAssertEqualObjects([components.queryItems[0] value], @"inside|900:auto");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], [urlString rangeOfString:@"fit"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], [urlString rangeOfString:@"inside|900:auto"]));
    XCTAssertTrue(components.queryKeyValues.count == 1);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"http"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"akns-images.eonline.com"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/eol_images/Entire_Site/2018029/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, [urlString rangeOfString:@"jpg"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"fit=inside|900:auto"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, NSMakeRange(0, 0)));
    
    // Abnormal Case 7: http://wapp.wapa.taobao.com/alicare/wangxin.html 's query string should not contain `&key=value`
    urlString = @"wangx://menu/present/template?container=dialog&body={\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"wangx");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"menu");
    XCTAssertNil(components.port);
    XCTAssertEqualObjects(components.path, @"/present/template");
    XCTAssertNil(components.pathExtension);
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"container=dialog&body={\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 2);
    XCTAssertEqualObjects([components.queryItems[0] name], @"container");
    XCTAssertEqualObjects([components.queryItems[0] value], @"dialog");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], [urlString rangeOfString:@"container"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], [urlString rangeOfString:@"dialog"]));
    XCTAssertEqualObjects([components.queryItems[1] name], @"body");
    XCTAssertEqualObjects([components.queryItems[1] value], @"{\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertTrue(NSEqualRanges([components.queryItems[1] rangeOfName], [urlString rangeOfString:@"body"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[1] rangeOfValue], [urlString rangeOfString:@"{\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}"]));
    XCTAssertTrue(components.queryKeyValues.count == 2);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"wangx"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"menu"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/present/template"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"container=dialog&body={\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, NSMakeRange(0, 0)));
    
    // Abnormal Case 8
    urlString = @"wangx://menu/present/template?container=dialog&body={\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects(components.string, urlString);
    XCTAssertEqualObjects(components.scheme, @"wangx");
    XCTAssertNil(components.user);
    XCTAssertNil(components.password);
    XCTAssertEqualObjects(components.host, @"menu");
    XCTAssertNil(components.port);
    XCTAssertEqualObjects(components.path, @"/present/template");
    XCTAssertNil(components.pathExtension);
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"container=dialog&body={\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 2);
    XCTAssertEqualObjects([components.queryItems[0] name], @"container");
    XCTAssertEqualObjects([components.queryItems[0] value], @"dialog");
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfName], [urlString rangeOfString:@"container"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[0] rangeOfValue], [urlString rangeOfString:@"dialog"]));
    XCTAssertEqualObjects([components.queryItems[1] name], @"body");
    XCTAssertEqualObjects([components.queryItems[1] value], @"{\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertTrue(NSEqualRanges([components.queryItems[1] rangeOfName], [urlString rangeOfString:@"body"]));
    XCTAssertTrue(NSEqualRanges([components.queryItems[1] rangeOfValue], [urlString rangeOfString:@"{\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}"]));
    XCTAssertTrue(components.queryKeyValues.count == 2);
    
    XCTAssertTrue(NSEqualRanges(components.rangeOfScheme, [urlString rangeOfString:@"wangx"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfUser, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPassword, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfHost, [urlString rangeOfString:@"menu"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPort, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPath, [urlString rangeOfString:@"/present/template"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfPathExtension, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfParameterString, NSMakeRange(0, 0)));
    XCTAssertTrue(NSEqualRanges(components.rangeOfQuery, [urlString rangeOfString:@"container=dialog&body={\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}"]));
    XCTAssertTrue(NSEqualRanges(components.rangeOfFragment, NSMakeRange(0, 0)));
}

- (void)test_patternOfPathExtension {
    NSString *patternOfPathExtension = WCURLTool.patternOfPathExtension;
    NSString *path;
    NSTextCheckingResult *result;
    NSString *extension;
    
    // Case 1
    path = @"";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(@"", extension);
    
    // Case 2
    path = @"/";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(@"", extension);
    
    // Case 3
    path = @"/a";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(@"", extension);
    
    // Case 4
    path = @"/a.";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(@"", extension);
    
    // Case 5
    path = nil;
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertNil(extension);
    
    // Case 6
    path = @"/index.html";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"html");
    
    // Case 7
    path = @"/.html";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"html");
    
    // Case 8
    path = @".html";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"html");
    
    // Case 9
    path = @"/index.html?file=a.jpg";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"html");
    
    // Case 10
    path = @"/index.html;file=a.jpg";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"html");

    // Case 11
    path = @"/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"jpg");
    
    // Case 12
    path = @"/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg;file=a.png";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"jpg");
    
    // Case 13
    path = @"/rs_1024x759-180129200032-1024.lupita-nyongo-angela-bassett-black-panther-premiere.ct.012918.jpg?file=a.png";
    result = [WCURLTool firstMatchInString:path pattern:patternOfPathExtension];
    extension = [WCURLTool substringWithString:path range:[result rangeAtIndex:1]];
    XCTAssertEqualObjects(extension, @"jpg");
}

- (void)test_NSString_substringWithRange {
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

- (void)test_WCURLTool_substringWithRange {
    NSString *string;
    NSString *substring;
    
    // Case
    string = @"";
    substring = [WCURLTool substringWithString:string range:NSMakeRange(0, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = nil;
    substring = [WCURLTool substringWithString:string range:NSMakeRange(0, 0)];
    XCTAssertNil(substring);
    
    // Case
    string = @"";
    substring = ([WCURLTool substringWithString:string range:NSMakeRange(1, 0)]);
    XCTAssertNil(substring);
    
    // Case
    string = @"123";
    substring = [WCURLTool substringWithString:string range:NSMakeRange(2, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = @"123";
    substring = [string substringWithRange:NSMakeRange(3, 0)];
    XCTAssertEqualObjects(substring, @"");
    
    // Case
    string = @"123";
    substring = [WCURLTool substringWithString:string range:NSMakeRange(3, 1)];
    XCTAssertNil(substring);
    
    // Case
    string = @"123";
    substring = [WCURLTool substringWithString:string range:NSMakeRange(4, 0)];
    XCTAssertNil(substring);
}

#pragma mark - Others


- (void)test_NSArray {
    NSMutableArray *arr = [NSMutableArray array];
    //    arr[arr.count] = @"0";
    //    arr[arr.count] = @"1";
    //    arr[arr.count] = @"2";
    
    NSString *nilString = nil;
    arr[arr.count] = nilString;
    
    //arr[2] = @"2";
    
    NSLog(@"%@", arr);
}

- (void)test_access_ivar {
    Model *model;
    
    NSString *str = model->_string2;
    NSLog(@"%@", str);
}

- (void)test_dereference {
    Model *model = nil;
    
    void *ptr = &model;
    NSLog(@"%p", ptr);
}

- (void)test_NSEqualRanges {
    NSRange range = [Test new].range;
    XCTAssertTrue(NSEqualRanges(range, NSMakeRange(0, 0)));
}

@end
