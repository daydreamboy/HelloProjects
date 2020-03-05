//
//  Tests_NSURLComponents.m
//  Test
//
//  Created by wesley_chen on 2019/3/22.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests_NSURLComponents : XCTestCase

@end

@implementation Tests_NSURLComponents

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)test_URL {
    NSURL *URL;
    NSURLComponents *URLComponents;
    NSMutableArray<NSURLQueryItem *> *items;
    NSURLQueryItem *newItem;
    
    // Case 1
    URL = [NSURL URLWithString:@"https://www.google.com/"];
    items = [NSMutableArray array];
    
    URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    [items addObjectsFromArray:URLComponents.queryItems];
    
    XCTAssertEqualObjects(URLComponents.URL.absoluteString, @"https://www.google.com/");
    
    // Case 2: key is empty will be ignored
    URL = [NSURL URLWithString:@"https://www.google.com/"];
    items = [NSMutableArray array];
    
    URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    [items addObjectsFromArray:URLComponents.queryItems];

    newItem = [NSURLQueryItem queryItemWithName:@"" value:@"value"];
    [items addObject:newItem];
    URLComponents.queryItems = items;
    XCTAssertEqualObjects(URLComponents.URL.absoluteString, @"https://www.google.com/?=value");
    
    // Case 3: value is empty will be ignored
    URL = [NSURL URLWithString:@"https://www.google.com/"];
    items = [NSMutableArray array];
    
    URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    [items addObjectsFromArray:URLComponents.queryItems];

    newItem = [NSURLQueryItem queryItemWithName:@"key" value:@""];
    [items addObject:newItem];
    URLComponents.queryItems = items;
    XCTAssertEqualObjects(URLComponents.URL.absoluteString, @"https://www.google.com/?key=");
    
    // Case 4: The same keys
    URL = [NSURL URLWithString:@"https://www.google.com/"];
    items = [NSMutableArray array];
    
    URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    [items addObjectsFromArray:URLComponents.queryItems];
    
    newItem = [NSURLQueryItem queryItemWithName:@"key" value:@"value1"];
    [items addObject:newItem];
    
    newItem = [NSURLQueryItem queryItemWithName:@"key" value:@"value2"];
    [items addObject:newItem];
    
    URLComponents.queryItems = items;
    XCTAssertEqualObjects(URLComponents.URL.absoluteString, @"https://www.google.com/?key=value1&key=value2");
}

- (void)test_components {
    NSString *url;
    NSURL *URL;
    NSURLComponents *URLComponents;
    NSMutableArray<NSURLQueryItem *> *items;
    NSURLQueryItem *newItem;
    
    // Case 1
    url = @"https://www.google.com/search?newwindow=1&sxsrf=ALeKk02f5THLMykHpX_xYTfZXya4AGnpOw%3A1583401893198&ei=pctgXt_TC-iJr7wP08CaiA8&q=host+vs+domain&oq=host+vs+domain&gs_l=psy-ab.3..0i71l8.16422.16422..16779...0.3..0.0.0.......0....1..gws-wiz.fLnkxFSfQ9A&ved=0ahUKEwifuoXbh4PoAhXoxIsBHVOgBvEQ4dUDCAs&uact=5";
    URL = [NSURL URLWithString:url];
    items = [NSMutableArray array];
    
    URLComponents = [NSURLComponents componentsWithURL:URL resolvingAgainstBaseURL:NO];
    
    // Note: http://username:password@www.example.com/index.html
    NSLog(@"%@", URLComponents.scheme);
    NSLog(@"%@", URLComponents.user);
    NSLog(@"%@", URLComponents.password);
    NSLog(@"%@", URLComponents.host);
    NSLog(@"%@", URLComponents.port);
    NSLog(@"%@", URLComponents.path);
    NSLog(@"%@", URLComponents.query);
    NSLog(@"%@", URLComponents.fragment);
}

@end
