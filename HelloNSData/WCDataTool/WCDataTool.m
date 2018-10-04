//
//  WCDataTool.m
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataTool.h"
#import <CommonCrypto/CommonCryptor.h>

//#define kMime           @"mime"
//#define kExt            @"ext"
//#define kType           @"type"
//#define kBytesCount     @"bytesCount"
//#define kMatches        @"matches"

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
    
    return @{
    @(WCMIMETypeAmr): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeAmr),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeAr): @{
            @"mime": @"application/x-unix-archive",
            @"ext": @"ar",
            @"type": @(WCMIMETypeAr),
            @"bytesCount": @7,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                
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
                
                // TODO
                return NO;
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
                // [28, 35]
                // TODO: Needs to be before `ogg` check
                const unsigned char bytes[] = { 0x4F, 0x70, 0x75, 0x73, 0x48, 0x65, 0x61, 0x64 };
                return memcmp(byteOrder + 28, bytes, sizeof(bytes)) == 0;
            },
    },
    /*
    @(WCMIMETypeOtf): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeOtf),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypePdf): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypePdf),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypePng): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypePng),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypePs): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypePs),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypePsd): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypePsd),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeRar): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeRar),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeRpm): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeRpm),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeRtf): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeRtf),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMEType7z): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMEType7z),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeSqlite): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeSqlite),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeSwf): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeSwf),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeTar): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeTar),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeTif): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeTif),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeTtf): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeTtf),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeWav): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeWav),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeWebm): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeWebm),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeWebp): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeWebp),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeWmv): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeWmv),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeWoff): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeWoff),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeWoff2): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeWoff2),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeXpi): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeXpi),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeXz): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeXz),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeZ): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeZ),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeZip): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeZip),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
     */
    };
}

@end

@interface WCDataTool ()
@property (nonatomic, strong) NSArray<WCMIMETypeInfo *> *allSupportMIMETypeInfos;
@end

@implementation WCDataTool

#pragma mark - Data Validation

+ (nullable WCMIMETypeInfo *)MIMETypeInfoWithData:(NSData *)data {
    if (![data isKindOfClass:[NSData class]]) {
        return nil;
    }
    
    static NSDictionary *sMap;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMap = [WCMIMETypeInfo allSupportMIMETypeInfos];
    });
    
    __block WCMIMETypeInfo *MIMETypeInfo = nil;
    [sMap enumerateKeysAndObjectsUsingBlock:^(NSNumber * _Nonnull key, NSDictionary * _Nonnull info, BOOL * _Nonnull stop) {
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

#pragma mark - Data Generation

+ (NSData *)randomDataWithLength:(NSUInteger)length {
    NSMutableData *randomData = [NSMutableData dataWithCapacity:length];
    
    for (unsigned int i = 0; i < length / 4; ++i) {
        u_int32_t randomBits = arc4random();
        [randomData appendBytes:(void *)&randomBits length:4];
    }
    
    return randomData;
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

@end
