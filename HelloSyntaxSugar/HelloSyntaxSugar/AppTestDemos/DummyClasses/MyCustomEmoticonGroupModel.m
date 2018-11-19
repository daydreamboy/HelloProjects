//
//  MyCustomEmoticonGroupModel.m
//  HelloSyntaxSugar
//
//  Created by wesley_chen on 2018/11/19.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "MyCustomEmoticonGroupModel.h"
#import "MyManager.h"

@interface MyCustomEmoticonGroupModel ()
@property (nonatomic, strong) MyManager *myManager;
@end

@implementation MyCustomEmoticonGroupModel

@synthesize resourceDicPath2 = _resourceDicPath2;

- (instancetype)initWithSomething {
    self = [super init];
    if (self) {
        _myManager = [[MyManager alloc] init];
    }
    return self;
}

- (void)setResourceDicPath:(NSString *)resourceDicPath {
    // WARNING: missing call [super setXXX:]
    self.myManager.directoryPath = resourceDicPath;
}

- (void)setResourceDicPath2:(NSString *)resourceDicPath2 {
    // Note: overwrite the ivar of super class
    _resourceDicPath2 = resourceDicPath2;
    self.myManager.directoryPath = resourceDicPath2;
}

@end
