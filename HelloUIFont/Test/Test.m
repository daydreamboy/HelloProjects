//
//  Test.m
//  Test
//
//  Created by wesley_chen on 2020/8/23.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <UIKit/UIKit.h>

@interface Test : XCTestCase

@end

@implementation Test

- (void)setUp {
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
}

- (void)testExample {
    NSString *string;
    
    string = @"\u1F604";
    NSLog(@"%@", string);
}

- (void)test_fontCopy {
    UIFont *font = [UIFont boldSystemFontOfSize:14];
    NSLog(@"%@", font);
    
    UIFont *fontCopy = [UIFont fontWithDescriptor:font.fontDescriptor size:font.pointSize];
    NSLog(@"%@", fontCopy);
}

@end
