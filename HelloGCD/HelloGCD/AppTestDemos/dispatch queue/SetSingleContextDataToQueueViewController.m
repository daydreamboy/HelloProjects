//
//  SetSingleContextDataToQueueViewController.m
//  HelloGCD
//
//  Created by wesley chen on 16/11/20.
//  Copyright © 2016年 wesley chen. All rights reserved.
//

#import "SetSingleContextDataToQueueViewController.h"

typedef struct {
    int i;
} MyDataContext;

@interface ObjCContextData : NSObject
@property (nonatomic, strong) NSString *name;
@end

@implementation ObjCContextData
- (void)dealloc {
    NSLog(@"dealloc: %@", self);
}
@end

@interface SetSingleContextDataToQueueViewController ()
@property (nonatomic, strong) dispatch_queue_t queue;
@property (nonatomic, strong) dispatch_queue_t anotherQueue;
@end

@implementation SetSingleContextDataToQueueViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    // Case 1: use struct as context data
    self.queue = createMyQueue();
    /*
    dispatch_async(self.queue, ^{
        MyDataContext *data = dispatch_get_context(self.queue);
        NSLog(@"i (in block): %d", data->i);
    });
    
    MyDataContext *data = dispatch_get_context(self.queue);
    NSLog(@"i: %d", data->i);
    */
    
    // Case 2: use NSObject as context data
    NSString *queueLabel = @"com.wc.anotherQueue";
    ObjCContextData *objData = [ObjCContextData new];
    objData.name = [NSString stringWithFormat:@"Context Data of %@", queueLabel];
    
    _anotherQueue = dispatch_queue_create([queueLabel UTF8String], NULL);
    dispatch_set_context(_anotherQueue, (__bridge_retained void *)(objData)); // here must retain objData because it's a local object
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    // use __bridge_transfer, give ownership to objData
    // or __bridge, no changes on ownership, but need a `finalizer` function to dealloc the objData
    ObjCContextData *objData = (__bridge_transfer ObjCContextData *)(dispatch_get_context(_anotherQueue));
    NSLog(@"%@", objData.name);
}

- (void)dealloc {
    NSLog(@"dealloc: %@", self);
}

dispatch_queue_t createMyQueue()
{
    MyDataContext *data = (MyDataContext *)malloc(sizeof(MyDataContext));
    data->i = 10;
    
    dispatch_queue_t serialQueue = dispatch_queue_create("com.example.CriticalTaskQueue", NULL);
    if (serialQueue) {

        // If data is NULL, the myFinalizerFunction won't be called
        dispatch_set_context(serialQueue, data);
        
        dispatch_set_finalizer_f(serialQueue, &myFinalizerFunction);
    }
    
    return serialQueue;
}

void myFinalizerFunction(void *context)
{
    MyDataContext *data = (MyDataContext*)context;
    
    // clean up the contents of the structure
    // ...
    
    NSLog(@"will release context data");
    
    // now release the structure itself
    free(data);
}

@end
