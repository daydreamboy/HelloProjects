//
//  UIImagePNGRepresentationFixedViewController.m
//  HelloIssueMemoryFootprint
//
//  Created by wesley_chen on 21/03/2018.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "UIImagePNGRepresentationFixedViewController.h"

#import <MobileCoreServices/MobileCoreServices.h>

@interface UIImagePNGRepresentationFixedViewController ()
@property (nonatomic, strong) NSData *data;
@end

@implementation UIImagePNGRepresentationFixedViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    @autoreleasepool {
        UIImage *image = [UIImage imageNamed:@"XcodeBeta"];
//        NSData *data = UIImagePNGRepresentation(image);
        
        NSData *data = nil;
        
        UIColor *fillColor = nil;
        
        CFMutableDataRef dataRef = CFDataCreateMutable(kCFAllocatorDefault, 0);
        CGImageDestinationRef dest = CGImageDestinationCreateWithData(dataRef, kUTTypePNG, 1, NULL);
        if (!dest) {
            CFRelease(dataRef);
            return;
        }
        
        /// Set the options, 1 -> lossless
        CFMutableDictionaryRef options = CFDictionaryCreateMutable(kCFAllocatorDefault, 2, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
        if (!options) {
            CFRelease(dest);
            return;
        }
        CFDictionaryAddValue(options, kCGImageDestinationLossyCompressionQuality, (__bridge CFNumberRef)[NSNumber numberWithFloat:1.0f]); // No compression
        if (fillColor)
            CFDictionaryAddValue(options, kCGImageDestinationBackgroundColor, fillColor.CGColor);
        
        /// Add the image
        CGImageDestinationAddImage(dest, image.CGImage, (CFDictionaryRef)options);
        
        const bool success = CGImageDestinationFinalize(dest);
        NSLog(@"success: %@", success ? @"YES" : @"NO");
        
//        data = (__bridge_transfer NSData *)dataRef;
        
        /// Cleanup
        CFRelease(dataRef);
        CFRelease(options);
        CFRelease(dest);
        
        NSLog(@"data size: %ld bytes at address %p", (long)data.length, data);
//        self.data = data;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
