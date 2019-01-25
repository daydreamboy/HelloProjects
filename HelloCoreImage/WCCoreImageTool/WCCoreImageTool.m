//
//  WCCoreImageTool.m
//  HelloCoreImage
//
//  Created by wesley_chen on 2019/1/25.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import "WCCoreImageTool.h"
#import <CoreImage/CoreImage.h>

@interface WCCoreImageTool ()
@property (nonatomic, strong) CIDetector *QRCodeDetector;
@end

@implementation WCCoreImageTool

#pragma mark - Public Methods

- (nullable NSString *)stringWithQRCodeImage:(UIImage *)QRCodeImage {
    if (![QRCodeImage isKindOfClass:[UIImage class]]) {
        return nil;
    }
    
    @autoreleasepool {
        CIImage *ciImage;
        if (QRCodeImage.CIImage) {
            ciImage = QRCodeImage.CIImage;
        }
        else if (QRCodeImage.CGImage) {
            ciImage = [[CIImage alloc] initWithCGImage:QRCodeImage.CGImage];
        }
        else {
            return nil;
        }
        
        NSDictionary *options;
        if (ciImage.properties[(NSString *)kCGImagePropertyOrientation] == nil) {
            options = @{ CIDetectorImageOrientation : @(kCGImagePropertyOrientationUp) };
        }
        else {
            options = @{ CIDetectorImageOrientation : ciImage.properties[(NSString *)kCGImagePropertyOrientation] };
        }
        
        NSString *string = nil;
        NSArray<CIFeature *> *features = [self.QRCodeDetector featuresInImage:ciImage options:options];
        for (CIFeature *feature in features) {
            if ([feature isKindOfClass:[CIQRCodeFeature class]]) {
                string = [(CIQRCodeFeature *)feature messageString];
                break;
            }
        }
        
        return string;
    }
}

+ (nullable NSString *)stringWithQRCodeImage:(UIImage *)QRCodeImage {
    WCCoreImageTool *tool = [WCCoreImageTool new];
    return [tool stringWithQRCodeImage:QRCodeImage];
}

#pragma mark - Getters

- (CIDetector *)QRCodeDetector {
    if (!_QRCodeDetector) {
        CIContext *context = [CIContext context];
        NSDictionary *options = @{ CIDetectorAccuracy : CIDetectorAccuracyHigh }; // Slow but thorough
        
        _QRCodeDetector = [CIDetector detectorOfType:CIDetectorTypeQRCode context:context options:options];
    }
    
    return _QRCodeDetector;
}

@end
