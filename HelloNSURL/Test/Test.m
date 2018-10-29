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
    
    // Case 4
    urlString = @"http://a:80/b/c/d;p?key1=value1#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    XCTAssertNil(components.pathExtension);
    
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
    
    // Abnormal Case 1
    urlString = @"http://a:80/b/c/d;p?key1=#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"key1");
    XCTAssertEqualObjects([components.queryItems[0] value], @"");
    XCTAssertNil(components.pathExtension);
    
    // Abnormal Case 2
    urlString = @"http://a:80/b/c/d;p?=value1#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"value1");
    XCTAssertNil(components.pathExtension);
    
    // Abnormal Case 3
    urlString = @"http://a:80/b/c/d;p?=#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"");
    XCTAssertNil(components.pathExtension);
    
    // Abnormal Case 4
    urlString = @"http://a:80/b/c/d;p?==#jumpLocation";
    components = [WCURLTool URLComponentsWithUrlString:urlString];
    
    XCTAssertTrue([components.queryItems count] == 1);
    XCTAssertEqualObjects([components.queryItems[0] name], @"");
    XCTAssertEqualObjects([components.queryItems[0] value], @"");
    XCTAssertNil(components.pathExtension);
    
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
    XCTAssertEqualObjects(components.pathExtension, @"jpg");
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
    XCTAssertNil(components.pathExtension);
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
    XCTAssertNil(components.pathExtension);
    XCTAssertNil(components.parameterString);
    XCTAssertEqualObjects(components.query, @"container=dialog&body={\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
    XCTAssertNil(components.fragment);
    XCTAssertTrue([components.queryItems count] == 2);
    XCTAssertEqualObjects([components.queryItems[0] name], @"container");
    XCTAssertEqualObjects([components.queryItems[0] value], @"dialog");
    XCTAssertEqualObjects([components.queryItems[1] name], @"body");
    XCTAssertEqualObjects([components.queryItems[1] value], @"{\"template\":{\"data\":{\"text\":\"http%3a%2f%2fwapp.wapa.taobao.com%2falicare%2fwangxin.html%3fhost%3dh5.wapa.taobao.com%26sid%3d1234567890\"},\"id\":20001},\"header\":{\"title\":\"test\"}}");
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
