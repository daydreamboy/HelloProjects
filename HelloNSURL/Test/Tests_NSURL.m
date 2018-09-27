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
}

@end
