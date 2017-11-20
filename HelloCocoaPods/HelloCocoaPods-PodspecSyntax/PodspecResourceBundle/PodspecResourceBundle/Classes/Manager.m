//
//  Manager.m
//  header_dir
//
//  Created by wesley_chen on 10/11/2017.
//

#import "Manager.h"

@implementation Manager
- (void)doSomething {
    NSLog(@"called %@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (UIImage *)image1 {
    NSBundle *bundle = [self resourceBundleWithName:@"PodspecResourceBundle" inBundle:nil];
    NSBundle *internalBundle = [self resourceBundleWithName:@"internal_bundle" inBundle:bundle];
    
    NSString *imagePath = [internalBundle pathForResource:@"AppIcon" ofType:@"png"];
    
    return [UIImage imageNamed:imagePath];
}

- (UIImage *)image2 {
    NSBundle *bundle = [self resourceBundleWithName:@"PodspecResourceBundle" inBundle:nil];
    
    NSString *imagePath = [bundle pathForResource:@"XcodeBeta" ofType:@"png"];
    
    return [UIImage imageNamed:imagePath];
}

- (NSBundle *)resourceBundleWithName:(NSString *)name inBundle:(NSBundle *)bundle {
    
    NSBundle *parentBundle = bundle ?: [NSBundle bundleForClass:self.class];
    NSString *resourceBundlePath = [parentBundle pathForResource:name ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    
    return resourceBundle;
}

@end
