//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "CreatePDFGraphicsContext1ViewController.h"
#import <CoreGraphics/CoreGraphics.h>
#import <CoreFoundation/CoreFoundation.h>

@interface CreatePDFGraphicsContext1ViewController ()

@end

@implementation CreatePDFGraphicsContext1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *PDFFilePath = [directory stringByAppendingPathComponent:@"test1.pdf"];
    NSLog(@"directory: %@", directory);
    
    CGSize pageSizeOfPDF = CGSizeMake(400, 400);
    // Note: specify CGSizeZero to use default page size
    //pageSizeOfPDF = CGSizeZero;
    
    [self drawGraphicsInPDFContextWithFilePath:PDFFilePath pageSize:pageSizeOfPDF];
}

CGContextRef MyPDFContextCreate1(const CGRect *inMediaBox, CFStringRef path)
{
    CGContextRef myOutContext = NULL;
    CFURLRef url;
    
    url = CFURLCreateWithFileSystemPath(NULL, path, kCFURLPOSIXPathStyle, false);
    if (url != NULL) {
        // Note: inMediaBox can be NULL, so PDF page size will be 612 x 792 points
        myOutContext = CGPDFContextCreateWithURL(url, inMediaBox, NULL);
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
    
    CGContextRef context = MyPDFContextCreate1(pageRectPtr, (__bridge CFStringRef)(filePath));
    
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
