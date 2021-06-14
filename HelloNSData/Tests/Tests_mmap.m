//
//  Tests_mmap.m
//  Tests
//
//  Created by wesley_chen on 2021/6/13.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#include <stdio.h>
#include <sys/types.h>
#include <sys/stat.h>
#include <fcntl.h>
#include <sys/mman.h>
#include <assert.h>

#define FILE_SIZE       1024 * 1024   // 1MB
#define MAPPING_SIZE    1024 * 512    // 0.5MB
#define ACCESS_ADDR     1024 * 800    // 0.8MB offset

@interface Tests_mmap : XCTestCase

@end

@implementation Tests_mmap

- (void)test_mmap_read_file {
    NSString *fileName = @"mmap1.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    int fd = open(filePath.UTF8String, O_RDONLY, 0755);
    if (fd > 0) {
        struct stat fileStatInfo;
        if (fstat(fd, &fileStatInfo) == 0) {
            char *addr = mmap(NULL, fileStatInfo.st_size, PROT_READ, MAP_SHARED, fd, 0);
            if (addr != MAP_FAILED) {
                NSString *content = [NSString stringWithCString:addr encoding:NSUTF8StringEncoding];
                XCTAssertEqualObjects(content, @"Hello, world!");
                
                for (NSInteger i = 0; i < fileStatInfo.st_size; ++i) {
                    char character = addr[i];
                    if (character == '\0') {
                        break;
                    }
                    NSLog(@"%c", character);
                }
                
                munmap(addr, fileStatInfo.st_size);
            }
        }
        close(fd);
    }
}

- (void)test_mmap_read_file_use_offset {
    NSString *fileName = @"mmap2.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    int fd = open(filePath.UTF8String, O_RDONLY, 0755);
    if (fd > 0) {
        struct stat fileStatInfo;
        if (fstat(fd, &fileStatInfo) == 0) {
            
            // Note: 'offset' should be a multiple of the page size as returned by getpagesize(2)
            // @see https://stackoverflow.com/questions/20093473/why-file-starting-offset-in-mmap-must-be-multiple-of-the-page-size
            int offset = getpagesize();
            
            char *addr = mmap(NULL, fileStatInfo.st_size, PROT_READ, MAP_SHARED, fd, offset);
            if (addr != MAP_FAILED) {
                NSString *content = [NSString stringWithCString:addr encoding:NSUTF8StringEncoding];
                NSLog(@"%@", content);
            }
        }
        close(fd);
    }
}

- (void)test_mmap_write_file {
    NSString *fileName = @"mmap3.txt";
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    
    NSLog(@"filePath: %@", filePath);
    
    int fd = open(filePath.UTF8String, O_CREAT | O_RDWR | O_TRUNC, 0755);
    if (fd > 0) {
        NSString *text = @"hello, world!";
        NSData *data = [text dataUsingEncoding:NSUTF8StringEncoding];
        
        void *buffer = NULL;
        int64_t dataSize = data.length;
        if (ftruncate(fd, dataSize) == 0) {
            buffer = mmap(0, (size_t)dataSize, PROT_WRITE, MAP_SHARED, fd, 0);
            if (buffer != MAP_FAILED) {
                memcpy(buffer, data.bytes, data.length);
                
                // Note: use msync is optional, because munmap also can synchronize to disk
                msync(buffer, data.length, MS_SYNC);
                munmap(buffer, data.length);
            }
        }
        
        close(fd);
    }
}

#pragma mark - Issues

- (void)test_mmap_issue_uncorrect_offset {
    NSString *fileName = @"mmap1.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    int fd = open(filePath.UTF8String, O_RDONLY, 0755);
    if (fd > 0) {
        struct stat fileStatInfo;
        if (fstat(fd, &fileStatInfo) == 0) {
            
            // Note: 'offset' should be a multiple of the page size as returned by getpagesize(2)
            // @see https://stackoverflow.com/questions/20093473/why-file-starting-offset-in-mmap-must-be-multiple-of-the-page-size
            int offset = fileStatInfo.st_size > 7 ? 7 : 0;
            
            char *addr = mmap(NULL, fileStatInfo.st_size, PROT_READ, MAP_SHARED, fd, offset);
            XCTAssertTrue(addr == MAP_FAILED);
            
            if (addr != MAP_FAILED) {
                for (NSInteger i = 0; i < fileStatInfo.st_size; ++i) {
                    char character = addr[i];
                    if (character == '\0') {
                        break;
                    }
                    NSLog(@"%c", character);
                }
            }
        }
        close(fd);
    }
}

- (void)test_mmap_issue_access_out_of_mapping_range {
    NSString *fileName = @"file_testmmap";
    NSString *filePath = [NSHomeDirectory() stringByAppendingPathComponent:fileName];
    // open
    int fd = open(filePath.UTF8String, O_CREAT | O_RDWR | O_TRUNC, 0755);
    assert(fd);
    // alloc 1MB
    int ret = ftruncate(fd, FILE_SIZE);
    assert(!ret);
    // mmap
    char *addr = mmap(NULL, MAPPING_SIZE, PROT_READ | PROT_WRITE, MAP_SHARED, fd, 0);
    if (addr != MAP_FAILED) {
        assert(addr);
     
        __unused char a = *(addr + ACCESS_ADDR); // we expect program abort here!
        printf("The first read succeed!\n");
        *(addr + ACCESS_ADDR) = 'j';
        printf("The first write succeed!\n");
    }
}

- (void)test_mmap_issue_len_is_zero {
    NSString *fileName = @"mmap1.txt";
    NSString *filePath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:fileName];
    int fd = open(filePath.UTF8String, O_RDONLY, 0755);
    if (fd > 0) {
        struct stat fileStatInfo;
        if (fstat(fd, &fileStatInfo) == 0) {
            // Warning: len parameter should not be zero
            char *addr = mmap(NULL, 0, PROT_READ, MAP_SHARED, fd, 0);
            if (addr != MAP_FAILED) {
                NSString *content = [NSString stringWithCString:addr encoding:NSUTF8StringEncoding];
                NSLog(@"%@", content);
            }
        }
        close(fd);
    }
}

@end
