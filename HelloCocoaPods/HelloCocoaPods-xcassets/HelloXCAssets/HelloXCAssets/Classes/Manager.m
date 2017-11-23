//
//  Manager.m
//  header_dir
//
//  Created by wesley_chen on 10/11/2017.
//

#import "Manager.h"

@implementation Manager

+ (UIImage *)xcassetsImageNamed:(NSString *)name inBundleName:(NSString *)bundleName {
    if (bundleName.length) {
        // resource bundle
        NSBundle *parentBundle = [NSBundle bundleForClass:self.class];
        NSString *resourceBundlePath = [parentBundle pathForResource:bundleName ofType:@"bundle"];
        NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
        
        UIImage *image = [UIImage imageNamed:name inBundle:resourceBundle compatibleWithTraitCollection:nil];
        return image;
    }
    else {
        // main bundle
        UIImage *image = [UIImage imageNamed:name];
        return image;
    }
}

- (void)doSomething {
    NSLog(@"called %@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}

- (UIImage *)image1 {
    NSBundle *bundle = [self.class resourceBundleWithName:@"PodspecResourceBundle" inBundle:nil];
    NSBundle *internalBundle = [self.class resourceBundleWithName:@"internal_bundle" inBundle:bundle];
    
    NSString *imagePath = [internalBundle pathForResource:@"AppIcon" ofType:@"png"];
    
    return [UIImage imageNamed:imagePath];
}

+ (UIImage *)image2 {
    NSBundle *bundle = [NSBundle bundleForClass:self];
    
    NSString *imagePath = [bundle pathForResource:@"Shop" ofType:@"png"];
    UIImage *image1 = [UIImage imageNamed:@"Shop" inBundle:bundle compatibleWithTraitCollection:nil];
    UIImage *image2 = [UIImage imageNamed:imagePath];
    
    return [UIImage imageNamed:imagePath];
}

+ (UIImage *)image3 {
    NSBundle *bundle = [self resourceBundleWithName:@"HelloXCAssets" inBundle:nil];
    
//    NSString *imagePath = [bundle pathForResource:@"myredpocket" ofType:@"png"];
//
//    return [UIImage imageNamed:imagePath];
    // @see https://stackoverflow.com/questions/33063233/cant-load-images-from-xcasset-in-cocoapods
    return [UIImage imageNamed:@"myredpocket" inBundle:bundle compatibleWithTraitCollection:nil];
}

+ (NSBundle *)resourceBundleWithName:(NSString *)name inBundle:(NSBundle *)bundle {
    
    NSBundle *parentBundle = bundle ?: [NSBundle bundleForClass:self.class];
    NSString *resourceBundlePath = [parentBundle pathForResource:name ofType:@"bundle"];
    NSBundle *resourceBundle = [NSBundle bundleWithPath:resourceBundlePath];
    
    return resourceBundle;
}

@end
