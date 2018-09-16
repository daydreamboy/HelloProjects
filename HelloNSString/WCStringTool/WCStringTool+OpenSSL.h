//
//  WCStringTool+OpenSSL.h
//  HelloNSString
//
//  Created by wesley_chen on 2018/9/15.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WCStringTool.h"

NS_ASSUME_NONNULL_BEGIN

@interface WCStringTool (OpenSSL)

/**
 Encrypt plain string with public key

 @param string the plain string
 @param publicKey the public key being formated every lines of 64 chars with '\n'
 @return the base64-encoded string with one line. If nil, the encryption failed.
 @warning <br/> 1. Don't encrypt a large data
          <br/> 2. the publicKey key must be formated every lines of 64 chars with '\n'
 @see http://doginthehat.com.au/2014/04/basic-openssl-rsa-encryptdecrypt-example-in-cocoa/
 @see http://stackoverflow.com/questions/19344122/how-to-encrypt-decrypt-long-input-messages-with-rsa-openssl-c
 */
+ (nullable NSString *)encryptedStringWithString:(NSString *)string publicKey:(NSString *)publicKey NS_AVAILABLE_IOS(7_0);


/**
 Decrypt encryped string formated by base64-encoding with private key

 @param string the encryped string
 @param privateKey the private key being formated every lines of 64 chars with '\n'
 @return the base64-encoded string. If nil, the decryption failed.
 @warning <br/> 1. Don't encrypt a large data
          <br/> 2. the private key must be formated every lines of 64 chars with '\n'
 @see http://doginthehat.com.au/2014/04/basic-openssl-rsa-encryptdecrypt-example-in-cocoa/
 @see http://stackoverflow.com/questions/19344122/how-to-encrypt-decrypt-long-input-messages-with-rsa-openssl-c
 */
+ (nullable NSString *)decryptedStringWithString:(NSString *)string privateKey:(NSString *)privateKey NS_AVAILABLE_IOS(7_0);

@end

NS_ASSUME_NONNULL_END
