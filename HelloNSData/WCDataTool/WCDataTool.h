//
//  WCDataTool.h
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "WCReferringRange.h"

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
    WCMIMETypeDeb, // Needs to be before `ar` check, because `deb` is kind of `ar`
    WCMIMETypeDmg,
    WCMIMETypeEot,
    WCMIMETypeEpub,
    WCMIMETypeExe,
    WCMIMETypeFlac,
    WCMIMETypeFlif,
    WCMIMETypeFlv,
    WCMIMETypeGif,
    WCMIMETypeGz,
    WCMIMETypeHeic,
    WCMIMETypeHeif,
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
    WCMIMETypeOpus, // Needs to be before `ogg` check, because `opus` is kind of `ogg`
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
    WCMIMETypeXpi, // Needs to be before `zip` check, because `xpi` is kind of `zip`. And assumes signed .xpi from addons.mozilla.org
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

#pragma mark - Data MIME Info

/**
 Get MIME type from data

 @param data the NSData
 @return the WCMIMETypeInfo object. Return nil if the data's MIME type not recognized.
 */
+ (nullable WCMIMETypeInfo *)MIMETypeInfoWithData:(NSData *)data;

/**
 Check MIME type from data with the specific type

 @param data the NSData
 @param type the WCMIMEType
 @return the WCMIMETypeInfo object. Return nil if the data not match the type
 */
+ (nullable WCMIMETypeInfo *)checkMIMETypeWithData:(NSData *)data type:(WCMIMEType)type;

#pragma mark - Data Generation

/**
 Generate random NSData with specified size

 @param length the number of bytes
 @return the random NSData
 @see http://stackoverflow.com/questions/4917968/best-way-to-generate-nsdata-object-with-random-bytes-of-a-specific-length
 */
+ (NSData *)randomDataWithLength:(NSUInteger)length;

/**
 Resize image data under the maximum bytes

 @param image the UIImage which will get data by UIImageJPEGRepresentation
 @param maximumBytes the maximum bytes expect greater than 0
 @param compressRatio the maximum compress ratio which make returned data' size <= maximumBytes. Pass NULL if not get this info.
 
 @return the resized JPEG image data. Return nil if parameters are not correct.
 @discussion This method not must make sure the returned data's size <= maximumBytes.
 
 @see https://stackoverflow.com/a/47490970
 */
+ (nullable NSData *)resizedJPEGImageDataWithImage:(UIImage *)image maximumBytes:(long long)maximumBytes compressRatio:(CGFloat *)compressRatio;

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

/**
 Encode data with base64

 @param data the data
 @return the base64 encoded string
 */
+ (nullable NSString *)base64EncodedStringWithData:(NSData *)data;

#pragma mark - Data GZip (from nicklockwood)

+ (nullable NSData *)gzippedDataWithData:(NSData *)data compressionLevel:(float)level;
+ (nullable NSData *)gzippedDataWithData:(NSData *)data;
+ (nullable NSData *)gunzippedDataWithData:(NSData *)data;
+ (BOOL)isGzippedDataWithData:(NSData *)data;

#pragma mark - Data Query

+ (nullable NSArray<NSData *> *)subdataArrayWithData:(NSData *)data ranges:(NSArray<NSValue *> *)ranges;

+ (nullable NSArray<NSData *> *)subdataArrayWithData:(NSData *)data referringRanges:(NSArray<WCReferringRange *> *)ranges;

#pragma mark > Image Data Info

/**
 Get image size from NSData
 
 @param data the image data.
 
 @return the image size in pixel. If the data is not a image, return CGSizeZero
 
 @see https://stackoverflow.com/questions/12478502/how-to-get-image-metadata-in-ios
 */
+ (CGSize)imageSizeWithData:(NSData *)data;

#pragma mark - Data Translation

+ (nullable NSString *)ASCIIStringWithData:(NSData *)data;

+ (char)charValueWithData:(NSData *)data;
+ (short)shortValueWithData:(NSData *)data;
+ (int)intValueWithData:(NSData *)data;
+ (long)longValueWithData:(NSData *)data;
+ (long long)longLongValueWithData:(NSData *)data;

#pragma mark > Specify Endian

+ (char)charValueWithData:(NSData *)data isValid:(out BOOL * _Nullable)isValid;
+ (short)shortValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid;
+ (int)intValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid;
+ (long)longValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid;
+ (long long)longLongValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid;

#pragma mark - Data mmap file

/**
 Read data using mmap
 
 @param filePath the file path
 @param error the error. Pass nil if not consider the error
 
 @return the NSData of the file
 
 @header #import <sys/mman.h>
 */
+ (nullable NSData *)dataUsingMmapWithFilePath:(NSString *)filePath error:(NSError * _Nullable * _Nullable)error;

/**
 Write data using mmap
 
 @param path the file path
 @param data the NSData will be copied
 @param overwrite the flag if overwrite the existing file
 @param error the error
 
 @return YES if operate successfully, NO if not
 
 @header #import <sys/mman.h>
 
 @discussion 1) This method write data asynchronously. 2) This method maybe not effective than -[NSData writeToFile:atomically:]
 */
+ (BOOL)createFileUsingMmapWithPath:(NSString *)path data:(NSData *)data overwrite:(BOOL)overwrite error:(NSError * _Nullable * _Nullable)error;

#pragma mark - Data Assistant

/**
 Save the data to /tmp

 @param data the data to save
 @return YES if save successfully, NO if save failed.
 @warning This method only available on Simulator
 */
+ (BOOL)saveToTmpWithData:(NSData *)data;

@end

NS_ASSUME_NONNULL_END
