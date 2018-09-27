//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2018/7/29.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCURLTool.h"

@interface Model : NSObject {
    @public
    NSString *_string2;
}
//@property (nonatomic, copy) NSString *string;
@end

@implementation Model
@end

@interface Test : XCTestCase

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
    XCTAssertEqualObjects(components.parameterString, @"p");
    XCTAssertEqualObjects(components.query, @"q");
    XCTAssertNil(components.fragment);
    XCTAssertNil(components.queryItems);
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"key1=value1&key2=value2");
    XCTAssertEqualObjects(components.fragment, @"jumpLocation");
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    XCTAssertEqualObjects([components.queryItems[1] name], @"key2");
    XCTAssertEqualObjects([components.queryItems[1] value], @"value2");
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"q=http://a:80/b/c/d");
    XCTAssertEqualObjects(components.fragment, @"jumpLocation");
    XCTAssertEqualObjects([components.queryItems[0] name], @"q");
    XCTAssertEqualObjects([components.queryItems[0] value], @"http://a:80/b/c/d");
    
    // Case 4
    urlString = @"http://a:80/b/c/d;p?key1=value1#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertNil(components.query);
    XCTAssertEqualObjects(components.fragment, @"Related");
    XCTAssertNil(components.queryItems);
    
    // Abnormal Case 1
    urlString = @"http://a:80/b/c/d;p?key1=#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertNil([components.queryItems[0] value]);
    
    // Abnormal Case 2
    urlString = @"http://a:80/b/c/d;p?=value1#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    
    // Abnormal Case 3
    urlString = @"http://a:80/b/c/d;p?=#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertNil([components.queryItems[0] value]);
    
    // Abnormal Case 4
    urlString = @"http://a:80/b/c/d;p?==#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertTrue([components.queryItems count] == 1);
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"");
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"id=568371443233&spm=a223v.7835278.t0.1.3cbe2312nwviTo&pvid=be2a1b12-f24f-4050-9227-e7c3448fd8b8&scm=1007.12144.81309.9011_8949&utparam={%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 5);
    XCTAssertEqualObjects([components.queryItems[0] name], @"id");
    XCTAssertEqualObjects([components.queryItems[0] value], @"568371443233");
    XCTAssertEqualObjects([components.queryItems[1] name], @"spm");
    XCTAssertEqualObjects([components.queryItems[1] value], @"a223v.7835278.t0.1.3cbe2312nwviTo");
    XCTAssertEqualObjects([components.queryItems[2] name], @"pvid");
    XCTAssertEqualObjects([components.queryItems[2] value], @"be2a1b12-f24f-4050-9227-e7c3448fd8b8");
    XCTAssertEqualObjects([components.queryItems[3] name], @"scm");
    XCTAssertEqualObjects([components.queryItems[3] value], @"1007.12144.81309.9011_8949");
    XCTAssertEqualObjects([components.queryItems[4] name], @"utparam");
    XCTAssertEqualObjects([components.queryItems[4] value], @"{%22x_hestia_source%22:%228949%22,%22x_mt%22:10,%22x_object_id%22:568371443233,%22x_object_type%22:%22item%22,%22x_pos%22:1,%22x_pvid%22:%22be2a1b12-f24f-4050-9227-e7c3448fd8b8%22,%22x_src%22:%228949%22}");
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"fit=inside|900:auto");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 1);
    XCTAssertEqualObjects([components.queryItems[0] name], @"fit");
    XCTAssertEqualObjects([components.queryItems[0] value], @"inside|900:auto");
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"container=dialog&body={\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 2);
    XCTAssertEqualObjects([components.queryItems[0] name], @"container");
    XCTAssertEqualObjects([components.queryItems[0] value], @"dialog");
    XCTAssertEqualObjects([components.queryItems[1] name], @"body");
    XCTAssertEqualObjects([components.queryItems[1] value], @"{\"template\":{\"data\":{\"text\":\"http://wapp.wapa.taobao.com/alicare/wangxin.html\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    
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
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"container=dialog&body={\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 2);
    XCTAssertEqualObjects([components.queryItems[0] name], @"container");
    XCTAssertEqualObjects([components.queryItems[0] value], @"dialog");
    XCTAssertEqualObjects([components.queryItems[1] name], @"body");
    XCTAssertEqualObjects([components.queryItems[1] value], @"{\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
}

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

@end
