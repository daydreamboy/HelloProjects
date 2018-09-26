//
//  WCDataTool.h
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

// @see https://github.com/sendyhalim/Swime
typedef NS_ENUM(NSUInteger, WCMIMEType) {
    WCMIMETypeUnknown,
    WCMIMETypeAmr,
    WCMIMETypeAr,
    WCMIMETypeAvi,
    WCMIMETypeBmp,
    WCMIMETypeBz2,
    WCMIMETypeCab,
    WCMIMETypeCr2,
    WCMIMETypeCrx,
    WCMIMETypeDeb,
    WCMIMETypeDmg,
    WCMIMETypeEot,
    WCMIMETypeEpub,
    WCMIMETypeExe,
    WCMIMETypeFlac,
    WCMIMETypeFlif,
    WCMIMETypeFlv,
    WCMIMETypeGif,
    WCMIMETypeGz,
    WCMIMETypeIco,
    WCMIMETypeJpg,
    WCMIMETypeJxr,
    WCMIMETypeLz,
    WCMIMETypeM4a,
    WCMIMETypeM4v,
    WCMIMETypeMid,
    WCMIMETypeMkv,
    WCMIMETypeMov,
    WCMIMETypeMp3,
    WCMIMETypeMp4,
    WCMIMETypeMpg,
    WCMIMETypeMsi,
    WCMIMETypeMxf,
    WCMIMETypeNes,
    WCMIMETypeOgg,
    WCMIMETypeOpus,
    WCMIMETypeOtf,
    WCMIMETypePdf,
    WCMIMETypePng,
    WCMIMETypePs,
    WCMIMETypePsd,
    WCMIMETypeRar,
    WCMIMETypeRpm,
    WCMIMETypeRtf,
    WCMIMEType7z,
    WCMIMETypeSqlite,
    WCMIMETypeSwf,
    WCMIMETypeTar,
    WCMIMETypeTif,
    WCMIMETypeTtf,
    WCMIMETypeWav,
    WCMIMETypeWebm,
    WCMIMETypeWebp,
    WCMIMETypeWmv,
    WCMIMETypeWoff,
    WCMIMETypeWoff2,
    WCMIMETypeXpi,
    WCMIMETypeXz,
    WCMIMETypeZ,
    WCMIMETypeZip,
};

@interface WCMIMETypeInfo : NSObject
/// the MIME, e.g. audio/amr
@property (nonatomic, copy) NSString *MIME;
/// file extesion, e.g. amr
@property (nonatomic, copy) NSString *extension;
/// The WCMIMEType
@property (nonatomic, assign) WCMIMEType type;
/// the total bytes count of MIME flag
@property (nonatomic, assign) NSUInteger bytesCount;
/// the match block
@property (nonatomic, copy) BOOL (^matchBlock)(unsigned char *byteOrder);

/**
 Get MIME type

 @param type the WCMIMEType
 @return the WCMIMETypeInfo object. Return nil if the type not supported.
 */
+ (nullable WCMIMETypeInfo *)infoWithMIMEType:(WCMIMEType)type;

@end

@interface WCDataTool : NSObject

#pragma mark - Data Validation

/**
 Get MIME type from data

 @param data the NSData
 @return the WCMIMETypeInfo object. Return nil if the data's MIME type not recognized.
 */
+ (nullable WCMIMETypeInfo *)MIMETypeInfoWithData:(NSData *)data;

#pragma mark - Data Generation

/**
 Generate random NSData with specified size

 @param length the number of bytes
 @return the random NSData
 @see http://stackoverflow.com/questions/4917968/best-way-to-generate-nsdata-object-with-random-bytes-of-a-specific-length
 */
+ (NSData *)randomDataWithLength:(NSUInteger)length;

#pragma mark - Data Enctyption

/**
 Encrypt data with AES256

 @param data the data
 @param key the key
 @return the encrypted data
 */
+ (nullable NSData *)AES256EncryptWithData:(NSData *)data key:(NSString *)key;

/**
 Decrypt data with AES256

 @param data the encrypted data
 @param key the key
 @return the decrypted data
 */
+ (nullable NSData *)AES256DecryptWithData:(NSData *)data key:(NSString *)key;

+ (nullable NSString *)base64EncodedStringWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END