//
//  CreateDataBufferDispatchSourceViewController.m
//  HelloGCD
//
//  Created by wesley_chen on 2017/10/3.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "CreateDataBufferDispatchSourceViewController.h"

@interface CreateDataBufferDispatchSourceViewController ()
@property (nonatomic, strong) dispatch_data_t data_t;
@end

@implementation CreateDataBufferDispatchSourceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // @see https://www.mikeash.com/pyblog/friday-qa-2011-10-14-whats-new-in-gcd.html
    // @see http://www.programering.com/a/MTOwcDNwATk.html
    
    //[self test_create_dispatch_data_with_DISPATCH_DATA_DESTRUCTOR_DEFAULT];
    //[self test_create_dispatch_data_with_DISPATCH_DATA_DESTRUCTOR_FREE];
    //[self test_create_dispatch_data_with_custom_desctructor];
    //[self test_convert_NSData_to_dispatch_data_t];
    [self test_concate_dispatch_data_t];
}

#pragma mark - Test Methods

- (void)test_create_dispatch_data_with_DISPATCH_DATA_DESTRUCTOR_DEFAULT {
    const size_t bufferSize = 10;
    char *buffer = malloc(bufferSize);
    for (int i = 0; i < 10; i++) {
        buffer[i] = '0' + i;
    }
    //buffer = "0123456789"; // Error: overwrite buffer pointer by stacked string, can't be by free()
    
    // Note: copy data to dispatch_data_t by using DISPATCH_DATA_DESTRUCTOR_DEFAULT or NULL
    dispatch_data_t copied_data = dispatch_data_create(buffer, bufferSize, NULL, DISPATCH_DATA_DESTRUCTOR_DEFAULT);
    
    /*
     Printing description of buffer:
     (char *) buffer = 0x0000608000007610 "0123456789"
     
     Printing description of copied_data:
     <OS_dispatch_data: data[0x6080002662c0] = { leaf, size = 10, buf = 0x6080000077c0 }>
     */
    // Note: copied_data hold a copy of buffer, because 0x6080000077c0 is different from 0x0000608000007610
    
    free(buffer); // free it ok, because buffer has a copy of buffer
    
    NSLog(@"copied_data: %@", copied_data);
}

- (void)test_create_dispatch_data_with_DISPATCH_DATA_DESTRUCTOR_FREE {
    const size_t bufferSize = 10;
    char *buffer = malloc(bufferSize);
    for (int i = 0; i < 10; i++) {
        buffer[i] = '0' + i;
    }

    // Note: no copying data to dispatch_data_t by using DISPATCH_DATA_DESTRUCTOR_FREE
    dispatch_data_t referred_data = dispatch_data_create(buffer, bufferSize, NULL, DISPATCH_DATA_DESTRUCTOR_FREE);
    //free(buffer); // no need to free it, just free it when data1 is dealloc
    
    /*
     Printing description of buffer:
     (char *) buffer = 0x0000608000016ef0 "0123456789"
     
     Printing description of referred_data:
     <OS_dispatch_data: data[0x608000267300] = { leaf, size = 10, buf = 0x608000016ef0 }>
     */
    // Note: referred_data just hold buffer using same address 0x608000016ef0
    
    NSLog(@"referred_data: %@", referred_data);
}

- (void)test_create_dispatch_data_with_custom_desctructor {
    const size_t bufferSize = 10;
    char *buffer = malloc(bufferSize);
    for (int i = 0; i < 10; i++) {
        buffer[i] = '0' + i;
    }
    
    // the queue executes destructor block
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_data_t referred_data = dispatch_data_create(buffer, bufferSize, queue, ^{
        // block for destruction
        // referred_data is dealloc, and it's time to release buffer
        NSLog(@"deallocating referred_data and release its holding buffer");
        free(buffer);
    });
    
    /*
     Printing description of buffer:
     (char *) buffer = 0x000061000001a110 "0123456789"
     
     Printing description of referred_data:
     <OS_dispatch_data: data[0x6100000716c0] = { leaf, size = 10, buf = 0x61000001a110 }>
     */
    // Note: use custom destructor block also refer to the buffer
    
    NSLog(@"referred_data: %@", referred_data);
}

- (void)test_convert_NSData_to_dispatch_data_t {
    dispatch_data_t data1 = [self convertNSDataToDispatch_data_t:[@"0123456789" dataUsingEncoding:NSUTF8StringEncoding]];
    NSLog(@"data1: %@", data1);
}

- (dispatch_data_t)convertNSDataToDispatch_data_t:(NSData *)data {
    NSData *copiedData = [data copy]; // copy due to data changing outside
    
    // Note: specify queue NULL is also DISPATCH_QUEUE_PRIORITY_DEFAULT
    dispatch_data_t data_t = dispatch_data_create(copiedData.bytes, copiedData.length, NULL, ^{
        NSLog(@"copiedData will release by ARC");
    });
    
    return data_t;
}

- (void)test_concate_dispatch_data_t {
    // @see https://www.objc.io/issues/2-concurrency/low-level-concurrency-apis/#gcd-and-buffers
    dispatch_data_t a = [self convertNSDataToDispatch_data_t:[@"123" dataUsingEncoding:NSUTF8StringEncoding]];
    dispatch_data_t b = [self convertNSDataToDispatch_data_t:[@"4567" dataUsingEncoding:NSUTF8StringEncoding]];
    dispatch_data_t c = [self convertNSDataToDispatch_data_t:[@"89" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // combantaion1 just hold a and b, not copy them
    dispatch_data_t combantaion1 = dispatch_data_create_concat(a, b);
    dispatch_data_t combantaion2 = dispatch_data_create_concat(combantaion1, c);
    
    // combantaion2 stands for a -> b -> c
    dispatch_data_apply(combantaion2, ^bool(dispatch_data_t  _Nonnull region, size_t offset, const void * _Nonnull buffer, size_t size) {
        // traverse every buffer, a -> b -> c
        fprintf(stderr, "region with offset %zu, size %zu\n", offset, size);
        return true;
    });
    
    NSString *concatedString = [self convertDispatchDataToNSString:combantaion2];
    NSLog(@"concatedString: %@", concatedString);
}

- (NSString *)convertDispatchDataToNSString:(dispatch_data_t)data {
    NSMutableString *s = [NSMutableString stringWithCapacity:dispatch_data_get_size(data)];
    dispatch_data_apply(data, ^bool(dispatch_data_t region, size_t offset, const void *buffer, size_t size) {
        // @see https://stackoverflow.com/questions/1000556/what-does-the-s-format-specifier-mean
        // @see http://www.cplusplus.com/reference/cstdio/printf/
        // Note: * for dynamic variable `size`, . and s for maximum length which not needs to be null('\0') terminated
        [s appendFormat:@"%.*s", (int)size, buffer];
        return true;
    });
    return s;
}

@end
