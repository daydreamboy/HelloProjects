//
//  WCCharacterSetTool.m
//  HelloNSDataDetector
//
//  Created by wesley_chen on 2019/2/21.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCCharacterSetTool.h"

@implementation WCCharacterSetTool
+ (NSCharacterSet *)URLAllowedCharacterSet {
    static NSMutableCharacterSet *set;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        set = [NSMutableCharacterSet new];
        [set formUnionWithCharacterSet:[NSCharacterSet URLFragmentAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLHostAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPasswordAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLPathAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLQueryAllowedCharacterSet]];
        [set formUnionWithCharacterSet:[NSCharacterSet URLUserAllowedCharacterSet]];
        // Note: add unsafe characters ("<>#%{}|\^~[]`), @see https://perishablepress.com/stop-using-unsafe-characters-in-urls/
        [set formUnionWithCharacterSet:[NSCharacterSet characterSetWithCharactersInString:@"\"<>#%{}|\\^~[]`"]];
    });
    return set;
}
@end
