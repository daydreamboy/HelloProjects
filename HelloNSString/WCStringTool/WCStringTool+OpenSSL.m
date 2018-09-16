//
//  WCStringTool+OpenSSL.m
//  HelloNSString
//
//  Created by wesley_chen on 2018/9/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCStringTool+OpenSSL.h"

#if __has_include(<openssl/rsa.h>) && __has_include(<openssl/pem.h>) && __has_include(<openssl/err.h>)
#import <openssl/rsa.h>
#import <openssl/pem.h>
#import <openssl/err.h>

@implementation WCStringTool (OpenSSL)

+ (nullable NSString *)encryptedStringWithString:(NSString *)string publicKey:(NSString *)publicKey {
    if (![string isKindOfClass:[NSString class]] || ![publicKey isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    const char *pubKey = [publicKey UTF8String];
    
    BIO *bio = BIO_new_mem_buf((void *)pubKey, (int)strlen(pubKey));
    RSA *rsa_publickey = PEM_read_bio_RSA_PUBKEY(bio, NULL, 0, NULL);
    BIO_free(bio);
    
    NSData *plainData = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // Allocate a buffer
    int maxSize = RSA_size(rsa_publickey);
    unsigned char *output = (unsigned char *)malloc(maxSize * sizeof(char));
    
    // Fill buffer with encrypted data
    int numberOfBytes = RSA_public_encrypt((int)[plainData length], [plainData bytes], output, rsa_publickey, RSA_PKCS1_PADDING);
    
    if (numberOfBytes == -1 ) {
        printf("%s\n", ERR_error_string(ERR_get_error(), NULL));
        return nil;
    }
    
    NSData *encryptedData = [NSData dataWithBytes:output length:numberOfBytes];
    
    free(output);
    
    NSString *encrptedString = [[NSString alloc] initWithData:[encryptedData base64EncodedDataWithOptions:0] encoding:NSUTF8StringEncoding];
    return encrptedString;
}

+ (nullable NSString *)decryptedStringWithString:(NSString *)string privateKey:(NSString *)privateKey {
    if (![string isKindOfClass:[NSString class]] || ![privateKey isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    const char *priKey = [privateKey UTF8String];
    
    BIO *bio = BIO_new_mem_buf((void *)priKey, (int)strlen(priKey));
    RSA *rsa_privatekey = PEM_read_bio_RSAPrivateKey(bio, NULL, 0, NULL);
    BIO_free(bio);
    
    NSData *encrptedData = [[NSData alloc] initWithBase64EncodedString:string options:NSDataBase64DecodingIgnoreUnknownCharacters];
    
    int maxSize = RSA_size(rsa_privatekey);
    unsigned char *output = (unsigned char *)malloc(maxSize * sizeof(char));
    
    // Fill buffer with decrypted data
    int numberOfBytes = RSA_private_decrypt((int)[encrptedData length], [encrptedData bytes], output, rsa_privatekey, RSA_PKCS1_PADDING);
    if (numberOfBytes == -1 ) {
        printf("%s\n", ERR_error_string(ERR_get_error(), NULL));
        return nil;
    }
    
    NSData *plainData = [NSData dataWithBytes:output length:numberOfBytes];
    
    free(output);
    
    NSString *plainString = [[NSString alloc] initWithData:plainData encoding:NSUTF8StringEncoding];
    return plainString;
}

@end

#else

@implementation WCStringTool (OpenSSL)
+ (nullable NSString *)encryptedStringWithString:(NSString *)string publicKey:(NSString *)publicKey {
    return nil;
}
+ (nullable NSString *)decryptedStringWithString:(NSString *)string privateKey:(NSString *)privateKey {
    return nil;
}
@end

#endif
