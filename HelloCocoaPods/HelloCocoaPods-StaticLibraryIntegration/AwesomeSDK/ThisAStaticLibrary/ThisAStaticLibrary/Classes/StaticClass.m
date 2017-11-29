//
//  StaticClass.m
//  Pods-ThisAStaticLibrary_Tests
//
//  Created by wesley_chen on 29/11/2017.
//

#import "StaticClass.h"

@interface StaticClass ()
@property (nonatomic, copy) NSString *name;
@end

@implementation StaticClass

- (instancetype)initWithName:(NSString *)name {
    self = [super init];
    if (self) {
        _name = name;
    }
    return self;
}

- (void)printName {
    NSLog(@"name: %@", self.name);
}

@end
