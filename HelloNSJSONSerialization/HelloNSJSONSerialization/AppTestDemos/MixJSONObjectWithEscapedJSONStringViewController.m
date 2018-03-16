//
//  MixJSONObjectWithEscapedJSONStringViewController.m
//  HelloJSONIssues
//
//  Created by wesley_chen on 03/08/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "MixJSONObjectWithEscapedJSONStringViewController.h"

@interface MixJSONObjectWithEscapedJSONStringViewController ()

@end

@implementation MixJSONObjectWithEscapedJSONStringViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *str = @"{\"e\":\"{\\\"nickname\\\":\\\"{\\\\\\\"tribe\\\\\\\":{\\\\\\\"2000024364\\\\\\\":\\\\\\\"john、mike、\\\\\\\"},\\\\\\\"user\\\\\\\":{\\\\\\\"tester_john\\\\\\\":\\\\\\\"john\\\\\\\"}}\\\"}\",\"nickname\":\"{\\\"tribe\\\":{\\\"2000024364\\\":\\\"john、mike、\\\"},\\\"user\\\":{\\\"tester_john\\\":\\\"john\\\"}}\",\"securityData\":\"{\\\"msgid\\\":\\\"6269109084037975896\\\",\\\"sec_ret\\\":0,\\\"tips\\\":[{\\\"msg\\\":\\\"\\\\\\\\X\\\\\\\\T只需要99元就能买到，心动不如行动，\\\\\\\\A0\\\\\\\\Tyh.hzbys.com/qx/ZYH/YhGraduatessel.aspx，1232170\\\\\\\\ZeyJleHREYXRhIjoie1wibmlja25hbWVcIjpcIntcXFwidHJpYmVcXFwiOntcXFwiMjAwMDAyNDM2NFxcXCI6XFxcImJ1ZmFudGVzdOOAgXhpdXpoaTAwMeOAgVxcXCJ9LFxcXCJ1c2VyXFxcIjp7XFxcImNuaGh1cGFuYnVmYW50ZXN0XFxcIjpcXFwiYnVmYW50ZXN0XFxcIn19XCJ9In0=\\\",\\\"type\\\":2},{\\\"from_id\\\":\\\"developer_john\\\",\\\"to_id\\\":\\\"developer_john\\\",\\\"type\\\":1},{\\\"type\\\":38490456}]}\\n\"}";
    
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
    NSLog(@"%@", dict);
    
    NSString *str2 = dict[@"e"];
    NSDictionary *dict2 = [NSJSONSerialization JSONObjectWithData:[str2 dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
    NSLog(@"%@", dict2);
    
    [self traverseWithDict:dict atLevel:0];
}

- (void)traverseWithDict:(NSDictionary *)dict atLevel:(NSInteger)level {
    [dict enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull value, BOOL * _Nonnull stop) {
        
        NSMutableString *spaces = [[NSMutableString alloc] initWithString:@""];
        for (NSInteger i = 0; i < level; i++) {
            [spaces appendString:@"  "];
        }
        [spaces appendFormat:@"key: %@", key];
        if ([value isKindOfClass:[NSString class]]) {
            id JSONObject = [NSJSONSerialization JSONObjectWithData:[value dataUsingEncoding:NSUTF8StringEncoding] options:kNilOptions error:nil];
            if ([JSONObject isKindOfClass:[NSDictionary class]]) {
                NSLog(@"%@", spaces);
                [self traverseWithDict:JSONObject atLevel:level + 1];
            }
            else {
                [spaces appendFormat:@" --> value: %@", value];
                NSLog(@"%@", spaces);
            }
        }
        else if ([value isKindOfClass:[NSDictionary class]]) {
            NSLog(@"%@", spaces);
            [self traverseWithDict:value atLevel:level + 1];
        }
        else if ([value isKindOfClass:[NSArray class]]) {
            for (id element in value) {
                if ([element isKindOfClass:[NSDictionary class]]) {
                    NSLog(@"%@", spaces);
                    [self traverseWithDict:element atLevel:level + 1];
                }
                else {
                    [spaces appendFormat:@" --> value: %@", value];
                    NSLog(@"%@", spaces);
                }
            }
        }
        else {
            [spaces appendFormat:@" --> value: %@", value];
            NSLog(@"%@", spaces);
        }
    }];
}

@end
