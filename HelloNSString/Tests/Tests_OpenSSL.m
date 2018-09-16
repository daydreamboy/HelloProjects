//
//  Tests_OpenSSL.m
//  Tests
//
//  Created by wesley_chen on 2018/9/16.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "WCStringTool+OpenSSL.h"

static NSString *sPublicKey = @"-----BEGIN PUBLIC KEY-----\n"
    "MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQC45jJQRNy7P7uygaDEa5XBqAWg\n"
    "aYp0yRi9joFnBZ7gqq8i/daV4Ix3gR3N9GLmdw/cHLaeLuOESAYZtqKfynKuMAjo\n"
    "hbv6NZ9TsLgbFfHmlxUNEeCQLQHHKPe8HH6iSdQku+yaLT0K10d3yuEUQxY++bN9\n"
    "Zm16EWO/l24PhVYwEwIDAQAB\n"
    "-----END PUBLIC KEY-----\n";

static NSString *sPrivateKey = @"-----BEGIN RSA PRIVATE KEY-----\n"
    "MIICWwIBAAKBgQC45jJQRNy7P7uygaDEa5XBqAWgaYp0yRi9joFnBZ7gqq8i/daV\n"
    "4Ix3gR3N9GLmdw/cHLaeLuOESAYZtqKfynKuMAjohbv6NZ9TsLgbFfHmlxUNEeCQ\n"
    "LQHHKPe8HH6iSdQku+yaLT0K10d3yuEUQxY++bN9Zm16EWO/l24PhVYwEwIDAQAB\n"
    "AoGAZhU53BVY5MzYPULSVv+rC+NPT/RVLAtG7Ij8KrvwrsutrB0HV3JFO0l/AhGW\n"
    "dPVxPS5hKM5scMEvFQ0/lgc47sByRDWPXzyLrCDmJDC+++tTZCKCzMCoHU7FH5NO\n"
    "BguG6mIAiMCp0MqzMvzrsMEZ7FFHx2YoFfDj9jVoAjp+W+ECQQDV1DQ3PuhL84wk\n"
    "2RrU/8f0ztYuQRdVe5Ncaqg3Tav/X+n19N57QCiWPXpLAbL9mfdBUI/XN9iH+VSE\n"
    "d6HlIECRAkEA3V1ji4dfcVvalq/k36lKXPiVKLnyA8JMg2mJbLCxvGDYJXf3ATuG\n"
    "H/vn5CMBqpzhJLL8SlKL4xKYAXbYPqW4YwJAav27AsmfQiGixe0718gELSIxWQOI\n"
    "wWUL3vofIUzj+uvrDP5xNApuRH6Oaml3Ph2D8lJ1JqLy3VaMS5vwjc0NgQJAa9Yw\n"
    "xin+TsTGaZ3qSyK3PS9DyoE66qXejC3/allxXCl5YldcltcecbpPrw12pFykOTKQ\n"
    "QMyRpN7L+fqhQXONrQJAM5r9oEpSeGyxt82j1NJlTRiI75A6xgjO+J04rxIdUQFN\n"
    "fgH3K8uVMv7MKauZ6c2K4qDzq+hPUpjWZMwHdyOXnA==\n"
    "-----END RSA PRIVATE KEY-----\n";

@interface Tests_OpenSSL : XCTestCase

@end

@implementation Tests_OpenSSL

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}


- (void)test_encryptedStringWithPublicKey {
    NSString *plainString = @"hello";
    
    sPublicKey = @"-----BEGIN PUBLIC KEY-----"
"LS0tLS1CRUdJTiBQVUJMSUMgS0VZLS0tLS0KTUlHZk1BMEdDU3FHU0liM0RRRUJBUVVBQTRHTkFEQ0JpUUtCZ1FERmJ1OS9NaUdIMkJlT09tQTJTSkpVdlJ1NgpYZ2FVaHVLSGprbmpSSVhnN2lOV3VOMkNuRE9hbFpPSkRFZC9lUHord2NDVE45a0FPSG9Pd0NkVENzQlE0MEh4CjVMZDBxdjhZYmhRQWZ3OTlCK1R3bzJ5Ny9ybCs2VHg3b1Y1ZjNpTWRoQ09zaFRIak0xWFB1SnpZemVyaVMzSHAKSlFWZEEzTEYrQ09OU3REV2x3SURBUUFCCi0tLS0tRU5EIFBVQkxJQyBLRVktLS0tLQo=" "-----END RSA PRIVATE KEY-----";
    
    NSString *encrptedString = [WCStringTool encryptedStringWithString:plainString publicKey:sPublicKey];
    NSLog(@"encrpted: %@", encrptedString);
    
    XCTAssertNotNil(encrptedString);
    XCTAssertFalse([encrptedString isEqualToString:@""]);
}

- (void)test_decryptedStringWithPrivateKey {
    
    // case 1
    NSString *plainString = @"hello";
    
    NSString *encrptedString = [WCStringTool encryptedStringWithString:plainString publicKey:sPublicKey];
    NSLog(@"encrpted: %@", encrptedString);
    
    XCTAssertNotNil(encrptedString);
    XCTAssertFalse([encrptedString isEqualToString:@""]);
    
    NSString *decryptedString = [WCStringTool decryptedStringWithString:encrptedString privateKey:sPrivateKey];
    
    XCTAssertEqualObjects(decryptedString, plainString);
    
    // case 2
    NSData *data = [self createRandomNSDataWithNumberOfBytes:80]; // !!!: Don't encrypt large data
    NSString *base64String = [[NSString alloc] initWithData:[data base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    
    encrptedString = [WCStringTool encryptedStringWithString:base64String publicKey:sPublicKey];
    plainString = [WCStringTool decryptedStringWithString:encrptedString privateKey:sPrivateKey];
    
    XCTAssertEqualObjects(base64String, plainString);
}

#pragma mark - Utility

// @sa http://stackoverflow.com/questions/4917968/best-way-to-generate-nsdata-object-with-random-bytes-of-a-specific-length
- (NSData *)createRandomNSDataWithNumberOfBytes:(NSUInteger)numberOfBytes {
    NSMutableData *theData = [NSMutableData dataWithCapacity:numberOfBytes];

    for (unsigned int i = 0; i < numberOfBytes / 4; ++i) {
        u_int32_t randomBits = arc4random();
        [theData appendBytes:(void *)&randomBits length:4];
    }

    return theData;
}

@end
