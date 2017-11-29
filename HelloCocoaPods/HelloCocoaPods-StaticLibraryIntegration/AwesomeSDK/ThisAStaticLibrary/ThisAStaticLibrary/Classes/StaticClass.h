//
//  StaticClass.h
//  Pods-ThisAStaticLibrary_Tests
//
//  Created by wesley_chen on 29/11/2017.
//

#import <Foundation/Foundation.h>

@interface StaticClass : NSObject
- (instancetype)initWithName:(NSString *)name;
- (void)printName;
@end
