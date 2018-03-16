//
//  NSJSONReadingAllowFragmentsIssueViewController.m
//  HelloJSONIssues
//
//  Created by wesley_chen on 03/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "NSJSONReadingAllowFragmentsIssueViewController.h"

@interface NSJSONReadingAllowFragmentsIssueViewController ()

@end

@implementation NSJSONReadingAllowFragmentsIssueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Note: uncorrect JSON dictionary, because it has extra quotes at beginning and ending
    NSString *escapedJSONString = @"\"{ \\\"header\\\": { \\\"title\\\": \\\"小秘书消息\\\", \\\"summary\\\": \\\"小秘书消息\\\", \\\"degrade\\\": { \\\"alternative\\\": \\\"123\\\" } }, \\\"template\\\": { \\\"id\\\": 20014, \\\"data\\\": { \\\"layout\\\": \\\"side\\\", \\\"body\\\": { \\\"f\\\": [ 0, 0, 12, \\\"FIT\\\" ], \\\"sv\\\": [ { \\\"f\\\": [ 0.581, 0, 11.4, 1.661 ], \\\"text\\\": \\\"${title}\\\", \\\"mts\\\": \\\"m\\\", \\\"tfs\\\": 0.581, \\\"cs\\\": \\\"lbl\\\", \\\"tc\\\": \\\"#333333\\\" }, { \\\"cs\\\": \\\"line\\\", \\\"lc\\\": \\\"#dcdee3\\\", \\\"ls\\\": \\\"stock\\\", \\\"v\\\": [ [ 0, 0 ], [ 12, 0 ] ] }, { \\\"f\\\": [ 0.581, 0.29, 11, \\\"FIT\\\" ], \\\"text\\\": \\\"123\\\", \\\"tfs\\\": 0.498, \\\"mts\\\": \\\"s\\\", \\\"cs\\\": \\\"lbl\\\", \\\"tc\\\": \\\"#666666\\\" }, { \\\"cs\\\": \\\"line\\\", \\\"lc\\\": \\\"#dcdee3\\\", \\\"ls\\\": \\\"stock\\\", \\\"v\\\": [ [ 0, 0.29 ], [ 12, 0.29 ] ] }, { \\\"f\\\": [ 0, 0, 11.419, 1.305 ], \\\"sv\\\": [ { \\\"cs\\\": \\\"lbl\\\", \\\"tc\\\": \\\"#5f646e\\\", \\\"tfs\\\": 0.498, \\\"mts\\\": \\\"s\\\", \\\"f\\\": [ 0, 0, \\\"FIT\\\", 1.305 ], \\\"text\\\": \\\"查看全文\\\" } ], \\\"cs\\\": \\\"box\\\", \\\"bc\\\": \\\"#FFFFFF\\\", \\\"ds\\\": \\\"flex\\\", \\\"ai\\\": \\\"fe\\\" } ], \\\"bc\\\": \\\"#ffffff\\\", \\\"ds\\\": \\\"flex\\\", \\\"ac\\\": [ \\\"action\\\" ], \\\"cs\\\": \\\"box\\\" } } } }\"";
    
    NSData *data = [escapedJSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    // Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
    NSDictionary *dict1 = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    if ([dict1 isKindOfClass:[NSDictionary class]]) {
        NSLog(@"dict1 is a dict");
    }
    else if ([dict1 isKindOfClass:[NSString class]]) {
        NSLog(@"dict1 is a string");
        //id value = dict1[@"key"]; // Error: will crash, because dict1 is not a dictionary
    }
    
    // Note: set options to nil, fragments can't be converted to JSON object, so dict2 is nil
    NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"dict2 %@ nil", dict2 ? @"is not" : @"is");
    __unused id value = dict2[@"key"]; // Note: it's safe, because dict2 is nil
}

@end
