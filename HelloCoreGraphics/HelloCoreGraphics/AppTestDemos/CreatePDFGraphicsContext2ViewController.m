//
//  CreatePDFGraphicsContext2ViewController.m
//  HelloCoreGraphics
//
//  Created by wesley_chen on 2017/11/25.
//  Copyright © 2017年 wesley_chen. All rights reserved.
//

#import "CreatePDFGraphicsContext2ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>

@interface CreatePDFGraphicsContext2ViewController ()

@end

@implementation CreatePDFGraphicsContext2ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *PDFFilePath = [directory stringByAppendingPathComponent:@"test2.pdf"];
    NSLog(@"directory: %@", directory);
    
    CGSize pageSizeOfPDF = CGSizeMake(400, 400);
    // Note: specify CGSizeZero to use default page size
    //pageSizeOfPDF = CGSizeZero;
    
    [self drawGraphicsInPDFContextWithFilePath:PDFFilePath pageSize:pageSizeOfPDF];
}

CGContextRef MyPDFContextCreate2(const CGRect * inMediaBox, CFStringRef path)
{
    CGContextRef myOutContext = NULL;
    CFURLRef url;
    CGDataConsumerRef dataConsumer;
    
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, false);
    if (url != NULL) {
        dataConsumer = CGDataConsumerCreateWithURL(url);
        if (dataConsumer != NULL) {
            myOutContext = CGPDFContextCreate(dataConsumer, inMediaBox, NULL);
            CGDataConsumerRelease(dataConsumer);
        }
        CFRelease(url);
    }
    return myOutContext;
}

- (void)drawGraphicsInPDFContextWithFilePath:(NSString *)filePath pageSize:(CGSize)pageSize {
    
    // Note: page size
    CGRect *pageRectPtr = NULL;
    CGRect pageRect = CGRectZero;
    
    // Note: page attributes
    CFDictionaryRef pageDict = NULL;
    CFStringRef keysOfPageDict[1];
    CFTypeRef valuesOfPageDict[1];
    
    if (!CGSizeEqualToSize(pageSize, CGSizeZero)) {
        pageRect = CGRectMake(0, 0, pageSize.width, pageSize.height);
        pageRectPtr = &pageRect;
        
        keysOfPageDict[0] = kCGPDFContextMediaBox;
        valuesOfPageDict[0] = (CFTypeRef)CFDataCreate(NULL, (const UInt8 *)pageRectPtr, sizeof(CGRect));
        
        pageDict = CFDictionaryCreate(NULL, (const void **)keysOfPageDict, (const void **)valuesOfPageDict, 1, &kCFTypeDictionaryKeyCallBacks, &kCFTypeDictionaryValueCallBacks);
    }
    
    CGContextRef context = MyPDFContextCreate2(pageRectPtr, (__bridge CFStringRef)(filePath));
    
    // Note: start to draw the first page of PDF
    CGPDFContextBeginPage(context, pageDict);
    
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, 200, 100));
    CGContextSetRGBFillColor(context, 0, 0, 1, 0.5);
    CGContextFillRect(context, CGRectMake(0, 0, 100, 200));
    
    CGPDFContextEndPage(context);
    
    // Note: start to draw the second page of PDF
    CGPDFContextBeginPage(context, pageDict);
    
    CGContextSetRGBFillColor(context, 1, 0, 0, 1);
    CGContextFillRect(context, CGRectMake(0, 0, 200, 100));
    CGContextSetRGBFillColor(context, 0, 0, 1, 0.5);
    CGContextFillRect(context, CGRectMake(0, 0, 100, 200));
    
    CGPDFContextEndPage(context);
    
    // Note: must do clean up
    if (pageDict != NULL) {
        CFRelease(pageDict);
    }
    
    if (valuesOfPageDict[0] != NULL) {
        CFRelease(valuesOfPageDict[0]);
    }
    
    CGContextRelease(context);
}

@end
