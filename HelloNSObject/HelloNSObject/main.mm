//
//  main.m
//  HelloNSObject
//
//  Created by wesley_chen on 2019/3/11.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

#define QUOTE "\""

#define STR_OF_JSON_BEGIN(str) NSString *str = @R QUOTE JSON(
#define STR_OF_JSON_END )JSON QUOTE;

int main(int argc, char * argv[]) {
    @autoreleasepool {
#define QUOTE "\""
        
        char foo[] = "He said " QUOTE "Hello there" QUOTE ".";
        
//    STR_OF_JSON_BEGIN(s)
//{
//    0 : false
//}
//    STR_OF_JSON_END

        return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
    }
}
