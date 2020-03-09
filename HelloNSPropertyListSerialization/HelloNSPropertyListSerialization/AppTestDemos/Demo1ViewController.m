//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"

@interface Demo1ViewController ()

@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"EmoticonInfo" ofType:@"plist"];
    
    NSError *error1;
    NSData *data = [NSData dataWithContentsOfFile:plistPath options:NSDataReadingMappedIfSafe error:&error1];
    
    NSPropertyListFormat format = 0;
    NSError *error2;
    id plistObject = [NSPropertyListSerialization propertyListWithData:data options:NSPropertyListMutableContainersAndLeaves format:&format error:&error2];
    
    if ([plistObject isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dict = (NSDictionary *)plistObject;
        NSMutableDictionary *dictM = [NSMutableDictionary dictionaryWithCapacity:dict.count];
        
        for (NSString *key in dict) {
            dictM[[NSString stringWithFormat:@"%@_new", key]] = dict[key];
        }
        
        NSError *error3;
        NSData *data = [NSPropertyListSerialization dataWithPropertyList:dictM format:format options:kNilOptions error:&error3];
        
        NSString *newPlistPath = [NSHomeDirectory() stringByAppendingPathComponent:@"EmoticonInfo_new.plist"];
        [data writeToFile:newPlistPath atomically:YES];
        
        NSLog(@"%@", NSHomeDirectory());
        NSLog(@"%@", newPlistPath);
    }
}

@end
