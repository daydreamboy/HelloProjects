//
//  WCDataTool.m
//  HelloNSData
//
//  Created by wesley_chen on 2018/8/25.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import "WCDataTool.h"

//#define kMime           @"mime"
//#define kExt            @"ext"
//#define kType           @"type"
//#define kBytesCount     @"bytesCount"
//#define kMatches        @"matches"

@implementation WCMIMETypeInfo

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
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeAr),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeAvi): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeAvi),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeBmp): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeBmp),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeBz2): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeBz2),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeCab): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeCab),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeCr2): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeCr2),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeCrx): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeCrx),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeDeb): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeDeb),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeDmg): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeDmg),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeEot): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeEot),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeEpub): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeEpub),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeExe): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeExe),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeFlac): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeFlac),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeFlif): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeFlif),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeFlv): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeFlv),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeGif): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeGif),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeGz): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeGz),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeIco): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeIco),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeJpg): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeJpg),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeJxr): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeJxr),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeLz): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeLz),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeM4a): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeM4a),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeM4v): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeM4v),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMid): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMid),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMkv): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMkv),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMov): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMov),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMp3): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMp3),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMp4): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMp4),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMpg): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMpg),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMsi): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMsi),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeMxf): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeMxf),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeNes): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeNes),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeOgg): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeOgg),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
    @(WCMIMETypeOpus): @{
            @"mime": @"audio/amr",
            @"ext": @"amr",
            @"type": @(WCMIMETypeOpus),
            @"bytesCount": @6,
            @"matches": ^BOOL(unsigned char *byteOrder) {
                const unsigned char bytes[] = { 0x23, 0x21, 0x41, 0x4D, 0x52, 0x0A };
                return memcmp(byteOrder, bytes, sizeof(bytes)) == 0;
            },
    },
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
    };
    
    return nil;
}

@end

@interface WCDataTool ()
@property (nonatomic, strong) NSArray<WCMIMETypeInfo *> *allSupportMIMETypeInfos;
@end

@implementation WCDataTool

+ (instancetype)sharedInstance {
    static WCDataTool *sInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sInstance = [[WCDataTool alloc] init];
    });
    return sInstance;
}

- (void)setupMIMETable {
    
}

#pragma mark - Getters

- (NSArray<WCMIMETypeInfo *> *)allSupportMIMETypeInfos {
    return nil;
}

+ (NSString *)MIMETypeWithData:(NSData *)data {
    uint8_t c;
    [data getBytes:&c length:1];
    
    switch (c) {
        case 0xFF:
            return @"image/jpeg";
        case 0x89:
            return @"image/png";
        case 0x47:
            return @"image/gif";
        case 0x49:
        case 0x4D:
            return @"image/tiff";
        case 0x25:
            return @"application/pdf";
        case 0xD0:
            return @"application/vnd";
        case 0x46:
            return @"text/plain";
        default:
            return nil;
    }
    return nil;
}

@end
