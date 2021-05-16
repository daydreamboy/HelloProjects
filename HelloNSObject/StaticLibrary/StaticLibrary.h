//
//  StaticLibrary.h
//  StaticLibrary
//
//  Created by wesley_chen on 2020/4/16.
//  Copyright © 2020 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface StaticLibrary : NSObject {
@package
    NSString *_packageIvar;
@public
    NSString *_publicIvar;
}

- (void)setSomeData:(NSDictionary *)data;

@end
