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

#pragma mark > QR Code from String

+ (nullable UIImage *)QRImageWithString:(NSString *)string size:(CGSize)size tintColor:(nullable UIColor *)tintColor {
    if (![string isKindOfClass:[NSString class]] || size.width <= 0 || size.height <= 0) {
        return nil;
    }
    
    if (string.length == 0) {
        return nil;
    }
    
    if (tintColor && ![tintColor isKindOfClass:[UIColor class]]) {
        return nil;
    }
    
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    if (!filter) {
        return nil;
    }
    
    [filter setValue:data forKey:@"inputMessage"];
    // Note: see https://github.com/ScottLogic/iOS7-day-by-day/blob/master/15-core-image-filters/15-core-image-filters.md
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    CIImage *ciImage = filter.outputImage;
    if (!ciImage) {
        return nil;
    }
    
    double scaleX = size.width / ciImage.extent.size.width;
    double scaleY = size.height / ciImage.extent.size.height;

    ciImage = [ciImage imageByApplyingTransform:CGAffineTransformMakeScale(scaleX, scaleY)];
    
    if (tintColor) {
        // Note: @see https://www.avanderlee.com/swift/qr-code-generation-swift/
        do {
            CIFilter *compositeFilter = [CIFilter filterWithName:@"CIMultiplyCompositing"];
            if (!compositeFilter) {
                break;
            }
            
            CIFilter *colorFilter = [CIFilter filterWithName:@"CIConstantColorGenerator"];
            if (!colorFilter) {
                break;
            }
            
            ciImage = [self invertColorsWithImage:ciImage];
            ciImage = [self blackColorToTransparentWithImage:ciImage];
            
            CIColor *ciColor = [[CIColor alloc] initWithColor:tintColor];
            [colorFilter setValue:ciColor forKey:kCIInputColorKey];
            
            CIImage *colorImage = colorFilter.outputImage;
            
            [compositeFilter setValue:colorImage forKey:kCIInputImageKey];
            [compositeFilter setValue:ciImage forKey:kCIInputBackgroundImageKey];
            ciImage = compositeFilter.outputImage;
        }
        while (NO);
    }
    
    UIImage *image = [UIImage imageWithCIImage:ciImage scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp];
    return image;
}

#pragma mark - CIImage Processing

+ (nullable CIImage *)invertColorsWithImage:(CIImage *)image {
    if (![image isKindOfClass:[CIImage class]]) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIColorInvert"];
    if (!filter) {
        return nil;
    }
    
    [filter setValue:image forKey:@"inputImage"];
    
    return filter.outputImage;
}

+ (nullable CIImage *)blackColorToTransparentWithImage:(CIImage *)image {
    if (![image isKindOfClass:[CIImage class]]) {
        return nil;
    }
    
    CIFilter *filter = [CIFilter filterWithName:@"CIMaskToAlpha"];
    if (!filter) {
        return nil;
    }
    
    [filter setValue:image forKey:@"inputImage"];
    
    return filter.outputImage;
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
