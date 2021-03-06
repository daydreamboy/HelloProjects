//
//  WCDataTool.m
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataTool.h"
#import "WCFileTool.h"
#import <CommonCrypto/CommonCryptor.h>
#import <zlib.h>
#import <sys/stat.h>
#import <sys/mman.h>

//#define kMime           @"mime"
//#define kExt            @"ext"
//#define kType           @"type"
//#define kBytesCount     @"bytesCount"
//#define kMatches        @"matches"

#define PTR_SAFE_SET(ptr, value) \
do { \
    if (ptr) { \
        *ptr = value; \
    } \
} while (0)

#ifndef NSARRAY_SAFE_GET
#define NSARRAY_SAFE_GET(array, index)                      \
    ({                                                      \
        id __value = nil;                                   \
        if ([array isKindOfClass:[NSArray class]] && 0 <= index && index < [(NSArray *)array count]) { \
            __value = [(NSArray *)array objectAtIndex:index];          \
        }                                                   \
        __value;                                            \
    })

#endif /* NSARRAY_SAFE_GET */

@implementation WCMIMETypeInfo

#pragma mark - Public Methods

+ (nullable WCMIMETypeInfo *)infoWithMIMEType:(WCMIMEType)type {
    NSDictionary *dict = [[self allSupportMIMETypeInfos] objectForKey:@(type)];
    if (dict) {
        return [self infoWithDictionary:dict];
    }
    else {
        return nil;
    }
}

#pragma mark -

+ (instancetype)infoWithDictionary:(NSDictionary *)dict {
    WCMIMETypeInfo *info = [[WCMIMETypeInfo alloc] init];
    info.MIME = dict[@"mime"];
    info.extension = dict[@"ext"];
    info.type = [dict[@"type"] integerValue];
    info.bytesCount = [dict[@"bytesCount"] integerValue];
    info.matchBlock = dict[@"matches"];
    
    return info;
}

+ (NSDictionary<NSNumber *, NSDictionary *> *)allSupportMIMETypeInfos {
    
    static NSDictionary<NSNumber *, NSDictionary *> *sMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMap = @{
                 @(WCMIMETypeAmr): @{
                         @"mime": @"audio/amr",
                         @"ext": @"amr",
                         @"type": @(WCMIMETypeAmr),
                         @"bytesCount": @6,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                             // [0, 5]
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeAr): @{
                         @"mime": @"application/x-unix-archive",
                         @"ext": @"ar",
                         @"type": @(WCMIMETypeAr),
                         @"bytesCount": @7,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E };
                             // [0, 6]
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeAvi): @{
                         @"mime": @"video/x-msvideo",
                         @"ext": @"avi",
                         @"type": @(WCMIMETypeAvi),
                         @"bytesCount": @11,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x52, 0x49, 0x46, 0x46 };
                             const unsigned char bytes2[] = { 0x41, 0x56, 0x49 };
                             
                             // [0, 4] and [8, 10]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             BOOL b2 = memcmp(byteOrder + 8, bytes2, sizeof(bytes2)) == 0;
                             
                             return (b1 && b2);
                         },
                         },
                 @(WCMIMETypeBmp): @{
                         @"mime": @"image/bmp",
                         @"ext": @"bmp",
                         @"type": @(WCMIMETypeBmp),
                         @"bytesCount": @2,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x42, 0x4D };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeBz2): @{
                         @"mime": @"application/x-bzip2",
                         @"ext": @"bz2",
                         @"type": @(WCMIMETypeBz2),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x42, 0x5A, 0x68 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeCab): @{
                         @"mime": @"application/vnd.ms-cab-compressed",
                         @"ext": @"cab",
                         @"type": @(WCMIMETypeCab),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x4D, 0x53, 0x43, 0x46 };
                             const unsigned char bytes2[] = { 0x49, 0x53, 0x63, 0x28 };
                             
                             // [0, 4]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             BOOL b2 = memcmp(byteOrder, bytes2, sizeof(bytes2)) == 0;
                             
                             return (b1 || b2);
                         },
                         },
                 @(WCMIMETypeCr2): @{
                         @"mime": @"image/x-canon-cr2",
                         @"ext": @"cr2",
                         @"type": @(WCMIMETypeCr2),
                         @"bytesCount": @10,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x49, 0x49, 0x2A, 0x00 };
                             const unsigned char bytes2[] = { 0x4D, 0x4D, 0x00, 0x2A };
                             const unsigned char bytes3[] = { 0x43, 0x52 };
                             
                             // [0, 4]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             BOOL b2 = memcmp(byteOrder, bytes2, sizeof(bytes2)) == 0;
                             // [8, 9]
                             BOOL b3 = memcmp(byteOrder + 8, bytes3, sizeof(bytes3)) == 0;
                             
                             return (b1 || b2) && b3;
                         },
                         },
                 @(WCMIMETypeCrx): @{
                         @"mime": @"application/x-google-chrome-extension",
                         @"ext": @"crx",
                         @"type": @(WCMIMETypeCrx),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x43, 0x72, 0x32, 0x34 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeDeb): @{
                         @"mime": @"application/x-deb",
                         @"ext": @"deb",
                         @"type": @(WCMIMETypeDeb),
                         @"bytesCount": @21,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 20]
                             const unsigned char bytes[] = { 0x21, 0x3C, 0x61, 0x72, 0x63, 0x68, 0x3E, 0x0A, 0x64, 0x65, 0x62, 0x69,
                                 0x61, 0x6E, 0x2D, 0x62, 0x69, 0x6E, 0x61, 0x72, 0x79 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeDmg): @{
                         @"mime": @"application/x-apple-diskimage",
                         @"ext": @"dmg",
                         @"type": @(WCMIMETypeDmg),
                         @"bytesCount": @2,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 1]
                             const unsigned char bytes[] = { 0x78, 0x01 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeEot): @{
                         @"mime": @"application/octet-stream",
                         @"ext": @"eot",
                         @"type": @(WCMIMETypeEot),
                         @"bytesCount": @11,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x4C, 0x50 };
                             const unsigned char bytes2[] = { 0x00, 0x00, 0x01 };
                             const unsigned char bytes3[] = { 0x01, 0x00, 0x02 };
                             const unsigned char bytes4[] = { 0x02, 0x00, 0x02 };
                             
                             // [34, 35]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [8, 10]
                             BOOL b2 = memcmp(byteOrder + 8, bytes2, sizeof(bytes2)) == 0;
                             BOOL b3 = memcmp(byteOrder + 8, bytes3, sizeof(bytes3)) == 0;
                             BOOL b4 = memcmp(byteOrder + 8, bytes4, sizeof(bytes4)) == 0;
                             
                             return b1 && (b2 || b3 || b4);
                         },
                         },
                 @(WCMIMETypeEpub): @{
                         @"mime": @"application/epub+zip",
                         @"ext": @"epub",
                         @"type": @(WCMIMETypeEpub),
                         @"bytesCount": @58,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x50, 0x4B, 0x03, 0x04 };
                             const unsigned char bytes2[] = { 0x6D, 0x69, 0x6D, 0x65, 0x74, 0x79, 0x70, 0x65, 0x61, 0x70, 0x70, 0x6C,
                                 0x69, 0x63, 0x61, 0x74, 0x69, 0x6F, 0x6E, 0x2F, 0x65, 0x70, 0x75, 0x62,
                                 0x2B, 0x7A, 0x69, 0x70 };
                             
                             // [0, 3]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [30, 57]
                             BOOL b2 = memcmp(byteOrder + 30, bytes2, sizeof(bytes2)) == 0;
                             
                             return b1 && b2;
                         },
                         },
                 @(WCMIMETypeExe): @{
                         @"mime": @"application/x-msdownload",
                         @"ext": @"exe",
                         @"type": @(WCMIMETypeExe),
                         @"bytesCount": @2,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 1]
                             const unsigned char bytes[] = { 0x4D, 0x5A };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeFlac): @{
                         @"mime": @"audio/x-flac",
                         @"ext": @"flac",
                         @"type": @(WCMIMETypeFlac),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x66, 0x4C, 0x61, 0x43 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeFlif): @{
                         @"mime": @"image/flif",
                         @"ext": @"flif",
                         @"type": @(WCMIMETypeFlif),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 4]
                             const unsigned char bytes[] = { 0x46, 0x4C, 0x49, 0x46 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeFlv): @{
                         @"mime": @"video/x-flv",
                         @"ext": @"flv",
                         @"type": @(WCMIMETypeFlv),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x46, 0x4C, 0x56, 0x01 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeGif): @{
                         @"mime": @"image/gif",
                         @"ext": @"gif",
                         @"type": @(WCMIMETypeGif),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 2]
                             const unsigned char bytes[] = { 0x47, 0x49, 0x46 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeGz): @{
                         @"mime": @"application/gzip",
                         @"ext": @"gz",
                         @"type": @(WCMIMETypeGz),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 2]
                             const unsigned char bytes[] = { 0x1F, 0x8B, 0x08 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeHeic): @{
                         // @see http://nokiatech.github.io/heif/technical.html
                         @"mime": @"image/heic",
                         @"ext": @"heic",
                         @"type": @(WCMIMETypeHeic),
                         @"bytesCount": @12,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // @see https://github.com/rs/SDWebImage/blob/master/SDWebImage/NSData%2BImageContentType.m
                             // [4, 8]
                             const unsigned char bytes1[] = { 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x63 }; // @"ftypheic"
                             const unsigned char bytes2[] = { 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x69, 0x78 }; // @"ftypheix"
                             const unsigned char bytes3[] = { 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x76, 0x63 }; // @"ftyphevc"
                             const unsigned char bytes4[] = { 0x66, 0x74, 0x79, 0x70, 0x68, 0x65, 0x76, 0x78 }; // @"ftyphevx"
                             
                             if (memcmp(byteOrder + 4, bytes1, sizeof(bytes1)) == 0 ||
                                 memcmp(byteOrder + 4, bytes2, sizeof(bytes2)) == 0 ||
                                 memcmp(byteOrder + 4, bytes3, sizeof(bytes3)) == 0 ||
                                 memcmp(byteOrder + 4, bytes4, sizeof(bytes4)) == 0) {
                                 return YES;
                             }
                             
                             return NO;
                         },
                         },
                 @(WCMIMETypeHeif): @{
                         @"mime": @"image/heif",
                         @"ext": @"heic",
                         @"type": @(WCMIMETypeHeif),
                         @"bytesCount": @12,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [4, 8]
                             const unsigned char bytes1[] = { 0x66, 0x74, 0x79, 0x70, 0x6D, 0x69, 0x66, 0x31 }; // @"ftypmif1"
                             const unsigned char bytes2[] = { 0x66, 0x74, 0x79, 0x70, 0x6D, 0x73, 0x66, 0x31 }; // @"ftypmsf1"
                             
                             if (memcmp(byteOrder + 4, bytes1, sizeof(bytes1)) == 0 ||
                                 memcmp(byteOrder + 4, bytes2, sizeof(bytes2)) == 0) {
                                 return YES;
                             }
                             
                             return NO;
                         },
                         },
                 @(WCMIMETypeIco): @{
                         @"mime": @"image/x-icon",
                         @"ext": @"ico",
                         @"type": @(WCMIMETypeIco),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x00, 0x00, 0x01, 0x00 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeJpg): @{
                         @"mime": @"image/jpeg",
                         @"ext": @"jpg",
                         @"type": @(WCMIMETypeJpg),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 2]
                             const unsigned char bytes[] = { 0xFF, 0xD8, 0xFF };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeJxr): @{
                         @"mime": @"image/vnd.ms-photo",
                         @"ext": @"jxr",
                         @"type": @(WCMIMETypeJxr),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 2]
                             const unsigned char bytes[] = { 0x49, 0x49, 0xBC };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeLz): @{
                         @"mime": @"application/x-lzip",
                         @"ext": @"lz",
                         @"type": @(WCMIMETypeLz),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x4C, 0x5A, 0x49, 0x50 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeM4a): @{
                         @"mime": @"audio/m4a",
                         @"ext": @"m4a",
                         @"type": @(WCMIMETypeM4a),
                         @"bytesCount": @11,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x4D, 0x34, 0x41, 0x20 };
                             const unsigned char bytes2[] = { 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x41 };
                             
                             // [0, 3]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [4, 10]
                             BOOL b2 = memcmp(byteOrder + 4, bytes2, sizeof(bytes2)) == 0;
                             
                             return b1 || b2;
                         },
                         },
                 @(WCMIMETypeM4v): @{
                         @"mime": @"video/x-m4v",
                         @"ext": @"m4v",
                         @"type": @(WCMIMETypeM4v),
                         @"bytesCount": @11,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 10]
                             const unsigned char bytes[] = { 0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x4D, 0x34, 0x56 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeMid): @{
                         @"mime": @"audio/midi",
                         @"ext": @"mid",
                         @"type": @(WCMIMETypeMid),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x4D, 0x54, 0x68, 0x64 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeMkv): @{
                         @"mime": @"video/x-matroska",
                         @"ext": @"mkv",
                         @"type": @(WCMIMETypeMkv),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x1A, 0x45, 0xDF, 0xA3 };
                             BOOL b1 = memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                             if (!b1) {
                                 return NO;
                             }
                             
                             NSInteger idPos = -1;
                             for (NSInteger i = 4; i < 4100; i++) {
                                 if (byteOrder[i] == 0x42 && byteOrder[i + 1] == 0x82) {
                                     idPos = i;
                                     break;
                                 }
                             }
                             
                             if (idPos == -1) {
                                 return NO;
                             }
                             
                             // Note: make 3 bytes shift
                             idPos += 3;
                             BOOL (^findDocType)(char *) = ^BOOL(char *type) {
                                 for (NSInteger i = 0; i < strlen(type); i++) {
                                     char ch = type[i];
                                     if (byteOrder[idPos + i] != ch) {
                                         return NO;
                                     }
                                 }
                                 
                                 return YES;
                             };
                             
                             return findDocType("matroska");
                         },
                         },
                 @(WCMIMETypeMov): @{
                         @"mime": @"video/quicktime",
                         @"ext": @"mov",
                         @"type": @(WCMIMETypeMov),
                         @"bytesCount": @8,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 7]
                             const unsigned char bytes[] = { 0x00, 0x00, 0x00, 0x14, 0x66, 0x74, 0x79, 0x70 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeMp3): @{
                         @"mime": @"audio/mpeg",
                         @"ext": @"mp3",
                         @"type": @(WCMIMETypeMp3),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x49, 0x44, 0x33 };
                             const unsigned char bytes2[] = { 0xFF, 0xFB };
                             
                             // [0, 2]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [0, 1]
                             BOOL b2 = memcmp(byteOrder, bytes2, sizeof(bytes2)) == 0;
                             
                             return b1 || b2;
                         },
                         },
                 @(WCMIMETypeMp4): @{
                         @"mime": @"video/mp4",
                         @"ext": @"mp4",
                         @"type": @(WCMIMETypeMp4),
                         @"bytesCount": @28,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x00, 0x00, 0x00 };
                             const unsigned char bytes2[] = { 0x18 };
                             const unsigned char bytes3[] = { 0x20 };
                             const unsigned char bytes4[] = { 0x66, 0x74, 0x79, 0x70 };
                             const unsigned char bytes5[] = { 0x33, 0x67, 0x70, 0x35 };
                             const unsigned char bytes6[] = { 0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32 };
                             const unsigned char bytes7[] = { 0x6D, 0x70, 0x34, 0x31, 0x6D, 0x70, 0x34, 0x32, 0x69, 0x73, 0x6F, 0x6D };
                             const unsigned char bytes8[] = { 0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x69, 0x73, 0x6F, 0x6D };
                             const unsigned char bytes9[] = { 0x00, 0x00, 0x00, 0x1C, 0x66, 0x74, 0x79, 0x70, 0x6D, 0x70, 0x34, 0x32, 0x00, 0x00, 0x00, 0x00 };
                             
                             // [0, 2]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [3]
                             BOOL b2 = memcmp(byteOrder + 3, bytes2, sizeof(bytes2)) == 0;
                             // [3]
                             BOOL b3 = memcmp(byteOrder + 3, bytes3, sizeof(bytes3)) == 0;
                             // [4, 7]
                             BOOL b4 = memcmp(byteOrder + 4, bytes4, sizeof(bytes4)) == 0;
                             // [0, 3]
                             BOOL b5 = memcmp(byteOrder, bytes5, sizeof(bytes5)) == 0;
                             // [0, 11]
                             BOOL b6 = memcmp(byteOrder, bytes6, sizeof(bytes6)) == 0;
                             // [16, 27]
                             BOOL b7 = memcmp(byteOrder + 16, bytes7, sizeof(bytes7)) == 0;
                             // [0, 11]
                             BOOL b8 = memcmp(byteOrder, bytes8, sizeof(bytes8)) == 0;
                             // [0, 15]
                             // REMARK: 原出处，仅判断了[0, 11]
                             BOOL b9 = memcmp(byteOrder, bytes9, sizeof(bytes9)) == 0;
                             
                             return (b1 && (b2 || b3) && b4) ||
                             (b5) ||
                             (b6 && b7) ||
                             (b8) ||
                             (b9);
                         },
                         },
                 @(WCMIMETypeMpg): @{
                         @"mime": @"video/mpeg",
                         @"ext": @"mpg",
                         @"type": @(WCMIMETypeMpg),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x00, 0x00, 0x01 };
                             // [0, 2]
                             BOOL b1 = memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                             if (!b1) {
                                 return NO;
                             }
                             
                             // CHECK: need to test
                             NSString *character = [NSString stringWithFormat:@"%2X", bytes[3]];
                             if (![character isEqualToString:@"B"]) {
                                 return YES;
                             }
                             
                             return NO;
                         },
                         },
                 @(WCMIMETypeMsi): @{
                         @"mime": @"application/x-msi",
                         @"ext": @"msi",
                         @"type": @(WCMIMETypeMsi),
                         @"bytesCount": @8,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 7]
                             const unsigned char bytes[] = { 0xD0, 0xCF, 0x11, 0xE0, 0xA1, 0xB1, 0x1A, 0xE1 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeMxf): @{
                         @"mime": @"application/mxf",
                         @"ext": @"mxf",
                         @"type": @(WCMIMETypeMxf),
                         @"bytesCount": @14,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 13]
                             const unsigned char bytes[] = { 0x06, 0x0E, 0x2B, 0x34, 0x02, 0x05, 0x01, 0x01, 0x0D, 0x01, 0x02, 0x01, 0x01, 0x02 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeNes): @{
                         @"mime": @"application/x-nintendo-nes-rom",
                         @"ext": @"nes",
                         @"type": @(WCMIMETypeNes),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x4E, 0x45, 0x53, 0x1A };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeOgg): @{
                         @"mime": @"audio/ogg",
                         @"ext": @"ogg",
                         @"type": @(WCMIMETypeOgg),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x4F, 0x67, 0x67, 0x53 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeOpus): @{
                         @"mime": @"audio/opus",
                         @"ext": @"opus",
                         @"type": @(WCMIMETypeOpus),
                         @"bytesCount": @36,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3], `OggS`
                             const unsigned char bytes1[] = { 0x4F, 0x67, 0x67, 0x53 };
                             // [28, 35], `OpusHead`
                             const unsigned char bytes2[] = { 0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64 };
                             
                             // Note: Needs to be before `ogg` check
                             if (memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0 && memcmp(byteOrder + 28, bytes2, sizeof(bytes2)) == 0) {
                                 return YES;
                             }
                             
                             return NO;
                         },
                         },
                 @(WCMIMETypeOtf): @{
                         @"mime": @"application/font-sfnt",
                         @"ext": @"otf",
                         @"type": @(WCMIMETypeOtf),
                         @"bytesCount": @5,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 4]
                             const unsigned char bytes[] = { 0x4F, 0x54, 0x54, 0x4F, 0x00 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypePdf): @{
                         @"mime": @"application/pdf",
                         @"ext": @"pdf",
                         @"type": @(WCMIMETypePdf),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x25, 0x50, 0x44, 0x46 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypePng): @{
                         @"mime": @"image/png",
                         @"ext": @"png",
                         @"type": @(WCMIMETypePng),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x89, 0x50, 0x4E, 0x47 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypePs): @{
                         @"mime": @"application/postscript",
                         @"ext": @"ps",
                         @"type": @(WCMIMETypePs),
                         @"bytesCount": @2,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 1]
                             const unsigned char bytes[] = { 0x25, 0x21 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypePsd): @{
                         @"mime": @"image/vnd.adobe.photoshop",
                         @"ext": @"psd",
                         @"type": @(WCMIMETypePsd),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x38, 0x42, 0x50, 0x53 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeRar): @{
                         @"mime": @"application/x-rar-compressed",
                         @"ext": @"rar",
                         @"type": @(WCMIMETypeRar),
                         @"bytesCount": @7,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x52, 0x61, 0x72, 0x21, 0x1A, 0x07 };
                             const unsigned char bytes2[] = { 0x0 };
                             const unsigned char bytes3[] = { 0x1 };
                             
                             // [0, 5]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [6]
                             BOOL b2 = memcmp(byteOrder + 6, bytes2, sizeof(bytes2)) == 0;
                             // [6]
                             BOOL b3 = memcmp(byteOrder + 6, bytes3, sizeof(bytes3)) == 0;
                             
                             return (b1 && (b2 || b3));
                         },
                         },
                 @(WCMIMETypeRpm): @{
                         @"mime": @"application/x-rpm",
                         @"ext": @"rpm",
                         @"type": @(WCMIMETypeRpm),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0xED, 0xAB, 0xEE, 0xDB };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeRtf): @{
                         @"mime": @"application/rtf",
                         @"ext": @"rtf",
                         @"type": @(WCMIMETypeRtf),
                         @"bytesCount": @5,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 4]
                             const unsigned char bytes[] = { 0x7B, 0x5C, 0x72, 0x74, 0x66 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMEType7z): @{
                         @"mime": @"application/x-7z-compressed",
                         @"ext": @"7z",
                         @"type": @(WCMIMEType7z),
                         @"bytesCount": @6,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 5]
                             const unsigned char bytes[] = { 0x37, 0x7A, 0xBC, 0xAF, 0x27, 0x1C };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeSqlite): @{
                         @"mime": @"application/x-sqlite3",
                         @"ext": @"sqlite",
                         @"type": @(WCMIMETypeSqlite),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 3]
                             const unsigned char bytes[] = { 0x53, 0x51, 0x4C, 0x69 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeSwf): @{
                         @"mime": @"application/x-shockwave-flash",
                         @"ext": @"swf",
                         @"type": @(WCMIMETypeSwf),
                         @"bytesCount": @3,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x43 };
                             const unsigned char bytes2[] = { 0x46 };
                             const unsigned char bytes3[] = { 0x57, 0x53 };
                             
                             // [0]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [0]
                             BOOL b2 = memcmp(byteOrder, bytes2, sizeof(bytes2)) == 0;
                             // [1, 2]
                             BOOL b3 = memcmp(byteOrder + 1, bytes3, sizeof(bytes3)) == 0;
                             
                             return ((b1 || b2) && b3);
                         },
                         },
                 @(WCMIMETypeTar): @{
                         @"mime": @"application/x-tar",
                         @"ext": @"tar",
                         @"type": @(WCMIMETypeTar),
                         @"bytesCount": @262,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [257, 261]
                             const unsigned char bytes[] = { 0x75, 0x73, 0x74, 0x61, 0x72 };
                             return memcmp(byteOrder + 257, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeTif): @{
                         @"mime": @"image/tiff",
                         @"ext": @"tif",
                         @"type": @(WCMIMETypeTif),
                         @"bytesCount": @4,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x49, 0x49, 0x2A, 0x00 };
                             const unsigned char bytes2[] = { 0x4D, 0x4D, 0x20, 0x2A };
                             
                             // [0, 3]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [0, 3]
                             BOOL b2 = memcmp(byteOrder, bytes2, sizeof(bytes2)) == 0;
                             
                             return b1 || b2;
                         },
                         },
                 @(WCMIMETypeTtf): @{
                         @"mime": @"application/font-sfnt",
                         @"ext": @"ttf",
                         @"type": @(WCMIMETypeTtf),
                         @"bytesCount": @5,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 4]
                             const unsigned char bytes[] = { 0x00, 0x01, 0x00, 0x00, 0x00 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeWav): @{
                         @"mime": @"audio/x-wav",
                         @"ext": @"wav",
                         @"type": @(WCMIMETypeWav),
                         @"bytesCount": @12,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x52, 0x49, 0x46, 0x46 };
                             const unsigned char bytes2[] = { 0x57, 0x41, 0x56, 0x45 };
                             
                             // [0, 3]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [8, 11]
                             BOOL b2 = memcmp(byteOrder + 8, bytes2, sizeof(bytes2)) == 0;
                             
                             return b1 && b2;
                         },
                         },
                 @(WCMIMETypeWebm): @{
                         @"mime": @"video/webm",
                         @"ext": @"webm",
                         @"type": @(WCMIMETypeWebm),
                         @"bytesCount": @6,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes[] = { 0x1A, 0x45, 0xDF, 0xA3 };
                             BOOL b1 = memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                             if (!b1) {
                                 return NO;
                             }
                             
                             NSInteger idPos = -1;
                             for (NSInteger i = 4; i < 4100; i++) {
                                 if (byteOrder[i] == 0x42 && byteOrder[i + 1] == 0x82) {
                                     idPos = i;
                                     break;
                                 }
                             }
                             
                             if (idPos == -1) {
                                 return NO;
                             }
                             
                             // Note: make 3 bytes shift
                             idPos += 3;
                             BOOL (^findDocType)(char *) = ^BOOL(char *type) {
                                 for (NSInteger i = 0; i < strlen(type); i++) {
                                     char ch = type[i];
                                     if (byteOrder[idPos + i] != ch) {
                                         return NO;
                                     }
                                 }
                                 
                                 return YES;
                             };
                             
                             return findDocType("webm");
                         },
                         },
                 @(WCMIMETypeWebp): @{
                         @"mime": @"image/webp",
                         @"ext": @"webp",
                         @"type": @(WCMIMETypeWebp),
                         @"bytesCount": @12,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [8, 11]
                             const unsigned char bytes[] = { 0x57, 0x45, 0x42, 0x50 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeWmv): @{
                         @"mime": @"video/x-ms-wmv",
                         @"ext": @"wmv",
                         @"type": @(WCMIMETypeWmv),
                         @"bytesCount": @10,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 9]
                             const unsigned char bytes[] = { 0x30, 0x26, 0xB2, 0x75, 0x8E, 0x66, 0xCF, 0x11, 0xA6, 0xD9 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeWoff): @{
                         @"mime": @"application/font-woff",
                         @"ext": @"woff",
                         @"type": @(WCMIMETypeWoff),
                         @"bytesCount": @8,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x77, 0x4F, 0x46, 0x46 };
                             const unsigned char bytes2[] = { 0x00, 0x01, 0x00, 0x00 };
                             const unsigned char bytes3[] = { 0x4F, 0x54, 0x54, 0x4F };
                             
                             // [0, 3]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [4, 7]
                             BOOL b2 = memcmp(byteOrder + 4, bytes2, sizeof(bytes2)) == 0;
                             // [4, 7]
                             BOOL b3 = memcmp(byteOrder + 4, bytes3, sizeof(bytes3)) == 0;
                             
                             return b1 && (b2 || b3);
                         },
                         },
                 @(WCMIMETypeWoff2): @{
                         @"mime": @"application/font-woff",
                         @"ext": @"woff2",
                         @"type": @(WCMIMETypeWoff2),
                         @"bytesCount": @8,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x77, 0x4F, 0x46, 0x32 };
                             const unsigned char bytes2[] = { 0x00, 0x01, 0x00, 0x00 };
                             const unsigned char bytes3[] = { 0x4F, 0x54, 0x54, 0x4F };
                             
                             // [0, 3]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [4, 7]
                             BOOL b2 = memcmp(byteOrder + 4, bytes2, sizeof(bytes2)) == 0;
                             // [4, 7]
                             BOOL b3 = memcmp(byteOrder + 4, bytes3, sizeof(bytes3)) == 0;
                             
                             return b1 && (b2 || b3);
                         },
                         },
                 @(WCMIMETypeXpi): @{
                         @"mime": @"application/x-xpinstall",
                         @"ext": @"xpi",
                         @"type": @(WCMIMETypeXpi),
                         @"bytesCount": @50,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // Needs to be before `zip` check
                             // assumes signed .xpi from addons.mozilla.org
                             BOOL isZip = NO;
                             {
                                 const unsigned char bytes1[] = { 0x50, 0x4B };
                                 const unsigned char bytes2[] = { 0x3 };
                                 const unsigned char bytes3[] = { 0x5 };
                                 const unsigned char bytes4[] = { 0x7 };
                                 const unsigned char bytes5[] = { 0x4 };
                                 const unsigned char bytes6[] = { 0x6 };
                                 const unsigned char bytes7[] = { 0x8 };
                                 
                                 // [0, 1]
                                 BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                                 // [2]
                                 BOOL b2 = memcmp(byteOrder + 2, bytes2, sizeof(bytes2)) == 0;
                                 // [2]
                                 BOOL b3 = memcmp(byteOrder + 2, bytes3, sizeof(bytes3)) == 0;
                                 // [2]
                                 BOOL b4 = memcmp(byteOrder + 2, bytes4, sizeof(bytes4)) == 0;
                                 // [3]
                                 BOOL b5 = memcmp(byteOrder + 3, bytes5, sizeof(bytes5)) == 0;
                                 // [3]
                                 BOOL b6 = memcmp(byteOrder + 3, bytes6, sizeof(bytes6)) == 0;
                                 // [3]
                                 BOOL b7 = memcmp(byteOrder + 3, bytes7, sizeof(bytes7)) == 0;
                                 
                                 isZip = b1 && (b2 || b3 || b4) && (b5 || b6 || b7);
                             }
                             
                             if (isZip) {
                                 const unsigned char bytes1[] = { 0x50, 0x4B, 0x03, 0x04 };
                                 const unsigned char bytes2[] = { 0x4D, 0x45, 0x54, 0x41, 0x2D, 0x49, 0x4E, 0x46, 0x2F, 0x6D, 0x6F, 0x7A,
                                     0x69, 0x6C, 0x6C, 0x61, 0x2E, 0x72, 0x73, 0x61 };
                                 
                                 // [0, 3]
                                 BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                                 // [30, 49]
                                 BOOL b2 = memcmp(byteOrder + 30, bytes2, sizeof(bytes2)) == 0;
                                 
                                 return b1 && b2;
                             }
                             
                             return NO;
                         },
                         },
                 @(WCMIMETypeXz): @{
                         @"mime": @"application/x-xz",
                         @"ext": @"xz",
                         @"type": @(WCMIMETypeXz),
                         @"bytesCount": @6,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             // [0, 5]
                             const unsigned char bytes[] = { 0xFD, 0x37, 0x7A, 0x58, 0x5A, 0x00 };
                             return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
                         },
                         },
                 @(WCMIMETypeZ): @{
                         @"mime": @"application/x-compress",
                         @"ext": @"z",
                         @"type": @(WCMIMETypeZ),
                         @"bytesCount": @2,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x1F, 0xA0 };
                             const unsigned char bytes2[] = { 0x1F, 0x9D };
                             
                             // [0, 1]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [0, 1]
                             BOOL b2 = memcmp(byteOrder, bytes2, sizeof(bytes2)) == 0;
                             
                             return b1 || b2;
                         },
                         },
                 @(WCMIMETypeZip): @{
                         @"mime": @"application/zip",
                         @"ext": @"zip",
                         @"type": @(WCMIMETypeZip),
                         @"bytesCount": @50,
                         @"matches": ^BOOL(unsigned char *byteOrder) {
                             const unsigned char bytes1[] = { 0x50, 0x4B };
                             const unsigned char bytes2[] = { 0x3 };
                             const unsigned char bytes3[] = { 0x5 };
                             const unsigned char bytes4[] = { 0x7 };
                             const unsigned char bytes5[] = { 0x4 };
                             const unsigned char bytes6[] = { 0x6 };
                             const unsigned char bytes7[] = { 0x8 };
                             
                             // [0, 1]
                             BOOL b1 = memcmp(byteOrder, bytes1, sizeof(bytes1)) == 0;
                             // [2]
                             BOOL b2 = memcmp(byteOrder + 2, bytes2, sizeof(bytes2)) == 0;
                             // [2]
                             BOOL b3 = memcmp(byteOrder + 2, bytes3, sizeof(bytes3)) == 0;
                             // [2]
                             BOOL b4 = memcmp(byteOrder + 2, bytes4, sizeof(bytes4)) == 0;
                             // [3]
                             BOOL b5 = memcmp(byteOrder + 3, bytes5, sizeof(bytes5)) == 0;
                             // [3]
                             BOOL b6 = memcmp(byteOrder + 3, bytes6, sizeof(bytes6)) == 0;
                             // [3]
                             BOOL b7 = memcmp(byteOrder + 3, bytes7, sizeof(bytes7)) == 0;
                             
                             return b1 && (b2 || b3 || b4) && (b5 || b6 || b7);
                         },
                         },
                 };
    });
    
    return sMap;
}

@end

@implementation WCDataTool

#pragma mark - Data Validation

+ (nullable WCMIMETypeInfo *)MIMETypeInfoWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    NSDictionary *map = [WCMIMETypeInfo allSupportMIMETypeInfos];
    __block WCMIMETypeInfo *MIMETypeInfo = nil;
    [map enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSDictionary * _Nonnull info, BOOL * _Nonnull stop) {
        NSInteger byteCount = [info[@"bytesCount"] integerValue];
        BOOL(^block)(unsigned char *) = info[@"matches"];
        
        if (data.length >= byteCount) {
            unsigned char *byteOrder = (unsigned char *)[data bytes];
            if (block && block(byteOrder)) {
                *stop = YES;
                MIMETypeInfo = [WCMIMETypeInfo infoWithDictionary:info];
            }
        }
    }];
    
    return MIMETypeInfo;
}

+ (nullable WCMIMETypeInfo *)checkMIMETypeWithData:(NSData *)data type:(WCMIMEType)type {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    NSDictionary *map = [WCMIMETypeInfo allSupportMIMETypeInfos];
    NSDictionary *info = map[@(type)];
    if (info) {
        NSInteger byteCount = [info[@"bytesCount"] integerValue];
        BOOL(^block)(unsigned char *) = info[@"matches"];
        
        if (data.length >= byteCount) {
            unsigned char *byteOrder = (unsigned char *)[data bytes];
            if (block && block(byteOrder)) {
                return [WCMIMETypeInfo infoWithDictionary:info];
            }
        }
    }
    
    return nil;
}

#pragma mark - Data Generation

+ (NSData *)randomDataWithLength:(NSUInteger)length {
    NSMutableData *randomData = [NSMutableData dataWithCapacity:length];
    
    for (unsigned int i = 0; i < length / 4; ++i) {
        u_int32_t randomBits = arc4random();
        [randomData appendBytes:(void *)&randomBits length:4];
    }
    
    return randomData;
}

+ (nullable NSData *)resizedJPEGImageDataWithImage:(UIImage *)image maximumBytes:(long long)maximumBytes compressRatio:(CGFloat *)compressRatio {
    if (![image isKindOfClass:[UIImage class]] || maximumBytes <= 0) {
        return nil;
    }
    
    NSData *resizedImageData = nil;
    CGFloat compressQuality = 1.0;
    for (; compressQuality > 0;) {
        @autoreleasepool {
            resizedImageData = UIImageJPEGRepresentation(image, compressQuality);
            
            if (resizedImageData.length <= maximumBytes) {
                break;
            }
            
            compressQuality -= 0.1;
        }
    }
    
    if (compressRatio) {
        *compressRatio = compressQuality;
    }
    
    return resizedImageData;
}

#pragma mark - Data Enctyption

+ (nullable NSData *)AES256EncryptWithData:(NSData *)data key:(NSString *)key {
    if (![data isKindOfClass:[NSData class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (nullable NSData *)AES256DecryptWithData:(NSData *)data key:(NSString *)key {
    if (![data isKindOfClass:[NSData class]] || ![key isKindOfClass:[NSString class]]) {
        return nil;
    }
    
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [data length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [data bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

+ (nullable NSString *)base64EncodedStringWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    if ([self respondsToSelector:@selector(base64EncodedStringWithOptions:)]) {
        return [data base64EncodedStringWithOptions:NSDataBase64Encoding64CharacterLineLength];
    }
    else {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wdeprecated-declarations"
        return [data base64Encoding];
#pragma GCC diagnostic pop
    }
}

#pragma mark - Data GZip (from nicklockwood)

+ (nullable NSData *)gzippedDataWithData:(NSData *)data compressionLevel:(float)level {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    if (data.length == 0 || [self isGzippedDataWithData:data]) {
        return data;
    }
    
    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.opaque = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)(void *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    static const NSUInteger ChunkSize = 16384;

    NSMutableData *output = nil;
    int compression = (level < 0.0f) ? Z_DEFAULT_COMPRESSION: (int)(roundf(level * 9));
    if (deflateInit2(&stream, compression, Z_DEFLATED, 31, 8, Z_DEFAULT_STRATEGY) == Z_OK) {
        output = [NSMutableData dataWithLength:ChunkSize];
        while (stream.avail_out == 0) {
            if (stream.total_out >= output.length) {
                output.length += ChunkSize;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            deflate(&stream, Z_FINISH);
        }
        deflateEnd(&stream);
        output.length = stream.total_out;
    }

    return output;
}

+ (nullable NSData *)gzippedDataWithData:(NSData *)data {
    return [self gzippedDataWithData:data compressionLevel:-1.0f];
}

+ (nullable NSData *)gunzippedDataWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    if (data.length == 0 || ![self isGzippedDataWithData:data]) {
        return data;
    }

    z_stream stream;
    stream.zalloc = Z_NULL;
    stream.zfree = Z_NULL;
    stream.avail_in = (uint)data.length;
    stream.next_in = (Bytef *)data.bytes;
    stream.total_out = 0;
    stream.avail_out = 0;

    NSMutableData *output = nil;
    if (inflateInit2(&stream, 47) == Z_OK) {
        int status = Z_OK;
        output = [NSMutableData dataWithCapacity:data.length * 2];
        while (status == Z_OK) {
            if (stream.total_out >= output.length) {
                output.length += data.length / 2;
            }
            stream.next_out = (uint8_t *)output.mutableBytes + stream.total_out;
            stream.avail_out = (uInt)(output.length - stream.total_out);
            status = inflate (&stream, Z_SYNC_FLUSH);
        }
        
        if (inflateEnd(&stream) == Z_OK) {
            if (status == Z_STREAM_END) {
                output.length = stream.total_out;
            }
        }
    }

    return output;
}

+ (BOOL)isGzippedDataWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return NO;
    }
    
    const UInt8 *bytes = (const UInt8 *)data.bytes;
    return (data.length >= 2 && bytes[0] == 0x1f && bytes[1] == 0x8b);
}

#pragma mark - Data Query

+ (nullable NSArray<NSData *> *)subdataArrayWithData:(NSData *)data ranges:(NSArray<NSValue *> *)ranges {
    if (![data isKindOfClass:[NSData class]] || ![ranges isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:ranges.count];
    
    for (NSValue *value in ranges) {
        NSRange range = [value rangeValue];
        if (0 <= range.location && range.location <= data.length && range.length <= data.length) {
            NSData *subdata = [data subdataWithRange:range];
            if (subdata) {
                [arrM addObject:subdata];
            }
        }
        else {
            return nil;
        }
    }
    
    return arrM;
}

+ (nullable NSArray<NSData *> *)subdataArrayWithData:(NSData *)data referringRanges:(NSArray<WCReferringRange *> *)ranges {
    if (![data isKindOfClass:[NSData class]] || ![ranges isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableArray *arrM = [NSMutableArray arrayWithCapacity:ranges.count];
    
    for (WCReferringRange *range in ranges) {
        NSUInteger location = range.location;
        NSUInteger length = range.length;
        
        if (range.locationRefer) {
            
            if (range.locationRefer.referMode == WCReferringRangeReferModeRelative) {
                if (range.locationRefer.relative == WCRangeLocationRelativeAtStart) {
                    location = range.locationRefer.referringRange.location + range.locationRefer.offset;
                }
                else if (range.locationRefer.relative == WCRangeLocationRelativeAtEnd) {
                    location = range.locationRefer.referringRange.location + range.locationRefer.referringRange.length + range.locationRefer.offset;
                }
                else {
                    NSLog(@"[locationRefer] unexpected relative: %d", (int)range.locationRefer.relative);
                    return nil;
                }
            }
            else if (range.locationRefer.referMode == WCReferringRangeReferModeValue) {
                NSData *referredData = range.lengthRefer.referringRange.userInfoObject;
                if (referredData) {
                    NSUInteger expectedSize = range.lengthRefer.expectedSize;
                    if (expectedSize == 1) {
                        location = [self charValueWithData:referredData];
                    }
                    else if (expectedSize == 2) {
                        location = [self shortValueWithData:referredData];
                    }
                    else if (expectedSize == 4) {
                        location = [self intValueWithData:referredData];
                    }
                    else if (expectedSize == 8) {
                        location = [self longValueWithData:referredData];
                    }
                    else {
                        return nil;
                    }
                }
                else {
                    return nil;
                }
            }
            else {
                NSLog(@"[locationRefer] unexpected referMode: %d", (int)range.locationRefer.referMode);
                return nil;
            }
        }
        
        if (range.lengthRefer) {
            NSData *referredData = range.lengthRefer.referringRange.userInfoObject;
            if (referredData) {
                NSUInteger expectedSize = range.lengthRefer.expectedSize;
                if (expectedSize == 1) {
                    length = [self charValueWithData:referredData];
                }
                else if (expectedSize == 2) {
                    length = [self shortValueWithData:referredData];
                }
                else if (expectedSize == 4) {
                    length = [self intValueWithData:referredData];
                }
                else if (expectedSize == 8) {
                    length = [self longValueWithData:referredData];
                }
                else {
                    return nil;
                }
            }
            else {
                return nil;
            }
        }
        
        if (0 <= location && location <= data.length && length <= data.length) {
            NSData *subdata = [data subdataWithRange:NSMakeRange(location, length)];
            if (subdata) {
                range.userInfoObject = subdata;
                [range updateLocationNumber:@(location) lengthNumber:@(length)];
                [arrM addObject:subdata];
            }
        }
        else {
            return nil;
        }
    }
    
    return arrM;
}

#pragma mark > Image Data Info

+ (CGSize)imageSizeWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return CGSizeZero;
    }
    
    if (data.length == 0) {
        return CGSizeZero;
    }
    
    CGSize imageSize = CGSizeZero;
    CGImageSourceRef sourceRef = CGImageSourceCreateWithData((CFDataRef)data, NULL);
    if (sourceRef == NULL) {
        return CGSizeZero;
    }
    
    NSDictionary *metadata = (NSDictionary *)CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(sourceRef, 0, NULL));
    CFRelease(sourceRef);
    
    CGFloat width = [metadata[(NSString *)kCGImagePropertyPixelWidth] doubleValue];
    CGFloat height = [metadata[(NSString *)kCGImagePropertyPixelHeight] doubleValue];
    
    if (width >= 0 && height >= 0) {
        imageSize = CGSizeMake(width, height);
    }
    
    return imageSize;
}

#pragma mark - Data Translation

+ (nullable NSString *)ASCIIStringWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    NSMutableString *stringM = [NSMutableString string];
    const char *bytes = [data bytes];
    for (int i = 0; i < [data length]; i++) {
        [stringM appendFormat:@"%c", bytes[i]];
    }
    
    return stringM;
}

+ (char)charValueWithData:(NSData *)data {
    return [self charValueWithData:data isValid:NULL];
}

+ (short)shortValueWithData:(NSData *)data {
    return [self shortValueWithData:data useLittleEndian:NO isValid:NULL];
}

+ (int)intValueWithData:(NSData *)data {
    return [self intValueWithData:data useLittleEndian:NO isValid:NULL];
}

+ (long)longValueWithData:(NSData *)data {
    return [self longValueWithData:data useLittleEndian:NO isValid:NULL];
}

+ (long long)longLongValueWithData:(NSData *)data {
    return [self longLongValueWithData:data useLittleEndian:NO isValid:NULL];
}

+ (char)charValueWithData:(NSData *)data isValid:(out BOOL * _Nullable)isValid {
    if (![data isKindOfClass:[NSData class]] || !data.length) {
        PTR_SAFE_SET(isValid, NO);
        return 0;
    }
    
    char value = *(char*)([data bytes]);
    PTR_SAFE_SET(isValid, YES);
    return value;
}

+ (short)shortValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid {
    if (![data isKindOfClass:[NSData class]] || !data.length) {
        PTR_SAFE_SET(isValid, NO);
        return 0;
    }
    
    short value = useLittleEndian ? CFSwapInt16LittleToHost(*(short*)([data bytes])) : CFSwapInt16BigToHost(*(short*)([data bytes]));
    PTR_SAFE_SET(isValid, YES);
    return value;
}

+ (int)intValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid {
    if (![data isKindOfClass:[NSData class]] || !data.length) {
        PTR_SAFE_SET(isValid, NO);
        return 0;
    }
    // @see https://stackoverflow.com/a/7333044
    int value = useLittleEndian ? CFSwapInt32LittleToHost(*(int*)([data bytes])) : CFSwapInt32BigToHost(*(int*)([data bytes]));
    PTR_SAFE_SET(isValid, YES);
    return value;
}

+ (long)longValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid {
    if (![data isKindOfClass:[NSData class]] || !data.length) {
        PTR_SAFE_SET(isValid, NO);
        return 0;
    }
    
    long value = useLittleEndian ? CFSwapInt64LittleToHost(*(long*)([data bytes])) : CFSwapInt64BigToHost(*(long*)([data bytes]));
    PTR_SAFE_SET(isValid, YES);
    return value;
}

+ (long long)longLongValueWithData:(NSData *)data useLittleEndian:(BOOL)useLittleEndian isValid:(out BOOL * _Nullable)isValid {
    if (![data isKindOfClass:[NSData class]] || !data.length) {
        PTR_SAFE_SET(isValid, NO);
        return 0;
    }
    
    long long value = useLittleEndian ? CFSwapInt64LittleToHost(*(long long*)([data bytes])) : CFSwapInt64BigToHost(*(long long*)([data bytes]));
    PTR_SAFE_SET(isValid, YES);
    return value;
}

#pragma mark - Data mmap file

+ (nullable NSData *)dataUsingMmapWithFilePath:(NSString *)filePath error:(NSError * _Nullable * _Nullable)error {
    const char *filePathCString = [filePath UTF8String];
    
    int errorCode = 0;
    int fd;
    struct stat fileStatInfo;
 
    // open the file
    fd = open(filePathCString, O_RDONLY, 0);
    if (fd < 0) {
        if (error) {
            errorCode = errno;
            
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errorCode)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:errorCode userInfo:userInfoM];
        }
        
        return nil;
    }
    
    // Note: get the file size
    if (fstat(fd, &fileStatInfo) != 0) {
        if (error) {
            errorCode = errno;
            
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errorCode)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:errorCode userInfo:userInfoM];
        }
        
        close(fd);
        
        return nil;
    }

    void *bufferPtr = NULL;
    // Note: map the file into a read-only memory region.
    bufferPtr = mmap(NULL, fileStatInfo.st_size, PROT_READ, 0, fd, 0);
    if (bufferPtr == MAP_FAILED) {
        if (error) {
            errorCode = errno;
            
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errorCode)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:errorCode userInfo:userInfoM];
        }
        
        close(fd);
        
        return nil;
    }
    
    // On success, return the size of the mapped file.
    size_t dataLength = fileStatInfo.st_size;
    
    NSData *data = [NSData dataWithBytes:bufferPtr length:(NSUInteger)dataLength];
    
    munmap(bufferPtr, dataLength);
    
    // Note: close the file
    close(fd);
    
    return data;
}

+ (BOOL)createFileUsingMmapWithPath:(NSString *)path data:(NSData *)data overwrite:(BOOL)overwrite error:(NSError * _Nullable * _Nullable)error {
    if (![path isKindOfClass:[NSString class]]) {
        return NO;
    }
    
    if (![data isKindOfClass:[NSData class]] || !data.length) {
        return NO;
    }
    
    BOOL success = [WCFileTool createNewFileAtPath:path overwrite:overwrite error:error];
    if (!success) {
        return NO;
    }
    
    int fd = -1;
    int errorCode = 0;
    const char *filePath = [path UTF8String];
    void *buffer = NULL;
    
    fd = open(filePath, O_RDWR | O_CREAT | O_TRUNC, S_IRUSR | S_IWUSR);
    if (fd < 0) {
        if (error) {
            errorCode = errno;
            
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errorCode)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:errorCode userInfo:userInfoM];
        }
        
        return NO;
    }
    
    int64_t dataSize = data.length;
    
    // @see http://blog.jcix.top/2018-10-26/mmap_tests/#28221mmap8221_SIGBUS
    if (ftruncate(fd, dataSize) != 0) {
        if (error) {
            errorCode = errno;
            
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errorCode)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:errorCode userInfo:userInfoM];
        }
        
        close(fd);
        
        return NO;
    }
    
    buffer = mmap(0, (size_t)dataSize, PROT_WRITE, MAP_SHARED, fd, 0);
    
    if (buffer == NULL) {
        if (error) {
            errorCode = errno;
            
            NSMutableDictionary *userInfoM = [NSMutableDictionary dictionary];
            userInfoM[NSLocalizedFailureReasonErrorKey] = [NSString stringWithFormat:@"%s", strerror(errorCode)];
            *error = [NSError errorWithDomain:NSStringFromClass([self class]) code:errorCode userInfo:userInfoM];
        }
        
        close(fd);
        
        return NO;
    }
    
    // Note: copy the data to buffer
    memcpy(buffer, data.bytes, data.length);
    
    // Note: use msync and MS_SYNC synchronize immediately, but more slow
    //msync(buffer, data.length, MS_SYNC);
    munmap(buffer, data.length);
    
    close(fd);

    return YES;
}

#pragma mark - Data Assistant

+ (BOOL)saveToTmpWithData:(NSData *)data {
#if TARGET_OS_SIMULATOR
    if (![data isKindOfClass:[NSData class]]) {
        return NO;
    }
    
    NSString *savedDirectory = @"/tmp";
    NSString *prefix = @"tmp";
    
    BOOL isDirectory = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:savedDirectory isDirectory:&isDirectory];
    if (isExists && isDirectory) {
        static NSDateFormatter *sDateFormatter;
        if (!sDateFormatter) {
            sDateFormatter = [[NSDateFormatter alloc] init];
            sDateFormatter.timeZone = [NSTimeZone systemTimeZone];
        }
        
        sDateFormatter.dateFormat = @"yyyy-MM-dd.HH-mm-ssZZ";
        
        NSString *filePath = [savedDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@_%u.data", prefix, [sDateFormatter stringFromDate:[NSDate date]], arc4random()]];
        BOOL success = [data writeToFile:filePath atomically:YES];
        if (success) {
            NSLog(@"%@ saved to %@", data, filePath);
            
            return YES;
        }
        else {
            NSLog(@"%@ failed saved to %@", data, filePath);
        }
    }
    else {
        NSLog(@"%@ not exists", savedDirectory);
    }
    
    return NO;
#else
    NSLog(@"saveToTmpWithData only available on Simulator now");
    
    return NO;
#endif
}

@end
