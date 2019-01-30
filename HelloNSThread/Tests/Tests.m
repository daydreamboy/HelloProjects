//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2018/11/28.
//  Copyright © 2018 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <mach/mach_init.h>
#import <mach/thread_info.h>
#import <mach/thread_act.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    dispatch_queue_t queue = [self queueForCurThread];
    NSLog(@"%@", queue);
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    NSLog(@"%@", mainQueue);
}

- (dispatch_queue_t)queueForCurThread {
    thread_t thread = mach_thread_self();
    thread_identifier_info_data_t tiid;
    mach_msg_type_number_t cnt = THREAD_IDENTIFIER_INFO_COUNT;
    kern_return_t kr = thread_info(thread, THREAD_IDENTIFIER_INFO, (thread_info_t)&tiid, &cnt);
    if (kr == KERN_SUCCESS) {
        if (tiid.dispatch_qaddr == thread) {
            return NULL;
        }
        void *queue = (void *)tiid.dispatch_qaddr;
        if (queue != NULL) {
            return *(__unsafe_unretained dispatch_queue_t *)queue;
        }
        return NULL;
    }
    return NULL;
}
@end
