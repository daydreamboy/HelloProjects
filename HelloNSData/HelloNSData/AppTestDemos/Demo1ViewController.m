//
//  ViewController.m
//  AppTest
//
//  Created by wesley chen on 16/4/13.
//
//

#import "Demo1ViewController.h"
#import "WCDataTool.h"
#import <MobileCoreServices/MobileCoreServices.h>

@interface Demo1ViewController ()
@property (nonatomic, strong) BOOL (^fun)(int);
@end

@implementation Demo1ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"1" ofType:@"amr"];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSString *MIMEType = [WCDataTool MIMETypeWithData:data];
    NSLog(@"%@", MIMEType);
    
    [self checkARMTypeWithData:data];

    filePath = [[NSBundle mainBundle] pathForResource:@"piano2" ofType:@"wav"];
    data = [NSData dataWithContentsOfFile:filePath];

    [self checkWAVWithData:data];
}

- (BOOL)checkARMTypeWithData:(NSData *)data {
    const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
    
    if (data.length < sizeof(bytes)) {
        return NO;
    }
    
    NSData *subdata = [data subdataWithRange:NSMakeRange(0, sizeof(bytes))];
    
    if (memcmp([subdata bytes], bytes, sizeof(bytes)) == 0) {
        // success
        NSLog(@"YES");
    }
    else {
        NSLog(@"NO");
    }
    
    NSData *amrHeader = [NSData dataWithBytes:bytes length:sizeof(bytes)];
    if ([subdata isEqualToData:amrHeader]) {
        NSLog(@"YES");
        return YES;
    }
    else {
        NSLog(@"NO");
        return NO;
    }
}

- (BOOL)checkWAVWithData:(NSData *)data {
    const unsigned char byteOrder1[] = { 0x52, 0x49, 0x46, 0x46 };
    const unsigned char byteOrder2[] = { 0x57, 0x41, 0x56, 0x45 };
    
    if (data.length < 12) {
        return NO;
    }
    
    NSData *subdata1 = [data subdataWithRange:NSMakeRange(0, sizeof(byteOrder1))];
    NSData *subdata2 = [data subdataWithRange:NSMakeRange(8, sizeof(byteOrder2))];
    
    NSData *wavFlag1 = [NSData dataWithBytes:byteOrder1 length:sizeof(byteOrder1)];
    NSData *wavFlag2 = [NSData dataWithBytes:byteOrder2 length:sizeof(byteOrder2)];
    
    
    if ([subdata1 isEqualToData:wavFlag1] && [subdata2 isEqualToData:wavFlag2]) {
        NSLog(@"YES");
        return YES;
    }
    else {
        NSLog(@"NO");
        return NO;
    }
}

@end
