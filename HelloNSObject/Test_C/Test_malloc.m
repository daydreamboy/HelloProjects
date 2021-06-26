//
//  Test_malloc.m
//  Test_C
//
//  Created by wesley_chen on 2021/6/24.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <malloc/malloc.h>
#import <mach/mach_init.h>

@interface Test_malloc : XCTestCase

@end

@implementation Test_malloc

- (void)test_malloc_get_all_zones {
    vm_address_t *zone_addresses;
    unsigned count = 0;
    
    malloc_get_all_zones(mach_task_self(), NULL, &zone_addresses, &count);
    
    // @see https://cpp.hotexamples.com/examples/-/-/malloc_get_all_zones/cpp-malloc_get_all_zones-function-examples.html
    for (unsigned i = 0; i < count; i++) {
        malloc_zone_t *malloc_zone = (malloc_zone_t *)zone_addresses[i];
        printf("zone %p \"%s\"\n", malloc_zone, malloc_get_zone_name(malloc_zone));
    }

    printf("\\zones\n");
}

- (void)test_malloc_default_zone {
    vm_address_t *zone_addresses;
    unsigned count = 0;
    
    malloc_get_all_zones(mach_task_self(), NULL, &zone_addresses, &count);
    
    for (unsigned i = 0; i < count; i++) {
        malloc_zone_t *malloc_zone = (malloc_zone_t *)zone_addresses[i];
        printf("zone %p \"%s\"\n", malloc_zone, malloc_get_zone_name(malloc_zone));
    }

    printf("\\zones\n");
    
    malloc_zone_t *default_zone = malloc_default_zone();
    printf("default_zone %p \"%s\"\n", default_zone, malloc_get_zone_name(default_zone));
}

@end
