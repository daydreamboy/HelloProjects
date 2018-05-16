//
//  ViewController.m
//  HelloStaticLibraryDependOnDynamicLibrary
//
//  Created by wesley_chen on 2018/5/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "ViewController.h"
#import "StaticLibrary.h"

@interface ViewController ()
@property (nonatomic, strong) StaticLibrary *staticLibrary;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.staticLibrary = [StaticLibrary new];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    NSError *error;
    [self.class loadFrameworkWithName:@"LazyLoadDynamicLibrary" error:&error];
    if (error) {
        NSLog(@"load failed: %@", error);
    }
}
     
+ (BOOL)loadFrameworkWithName:(NSString *)name error:(NSError **)error {
    NSError *errorL = nil;
    BOOL loaded = NO;
    
    NSString *frameworkFolder = [[NSBundle mainBundle] privateFrameworksPath];
    NSString *frameworkPath = [frameworkFolder stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.framework", name]];
    if (![[NSFileManager defaultManager] fileExistsAtPath:frameworkPath]) {
        loaded = NO;
        
        if (error) {
            NSString *errorDescription = [NSString stringWithFormat:@"%@ not exists", frameworkPath];
            *error = [NSError errorWithDomain:@"WCBundleToolError" code:-1 userInfo:@{ NSLocalizedDescriptionKey: errorDescription }];
        }
        
        return loaded;
    }
    
    NSBundle *frameworkBundle = [NSBundle bundleWithPath:frameworkPath];
    loaded = [frameworkBundle loadAndReturnError:&errorL];
    if (error) {
        *error = errorL;
    }
    
    return loaded;
}

@end
