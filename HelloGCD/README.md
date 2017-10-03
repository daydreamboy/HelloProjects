## HelloGCD

### dispatch queue

1\. Get global concurrent queues

* High priority (user-initiated-qos)
* Default priority (default-qos)
* Low priority (utility-qos)
* Background (background-qos)

2\. Create serial/concurrent dispatch queues

* serial queue, `dispatch_queue_create("com.example.MyQueue", NULL)` or  `dispatch_queue_create("com.example.MyQueue", DISPATCH_QUEUE_SERIAL)` 
* concurrent queue, `dispatch_queue_create("com.example.MyQueue2", DISPATCH_QUEUE_CONCURRENT)`


3\. Get current queue

* `dispatch_queue_t currentQueue = dispatch_get_current_queue();` (Deprecated iOS 6.0)

4\. Attach context data to a queue (SetCustomContextDataWithQueueViewController)

* `void dispatch_set_context(dispatch_object_t object, void *context);`
* `void * dispatch_get_context(dispatch_object_t object);`

Note: manage context data's life by caller

5\. Add task to a queue (AddTaskToQueueViewController)

* 同步/异步：`dispatch_sync` or `dispatch_async`
* 回调是block/function：`dispatch_async` or `dispatch_async_f`
* Dead Lock示例

6\. Barrier block

* 使用`dispatch_barrier_async`提交barrier block到concurrent queue（created by dispatch_queue_create）。
* barrier block执行前会等之前的任务执行完，barrier block执行过程中会阻塞后面的任务，当barrier block执行结束后才执行后面的任务
* `dispatch_barrier_async`提交barrier block到serial queue或者global concurrent queue，则退化到`dispatch_async` (from `dispatch_barrier_async` apple doc)

7\. Add completion block to a queue

```
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        float avg = average(data, len);
        NSLog(@"Done average1");
        dispatch_async(queue, ^{
            block(avg);
        });
    });
```

8\. Concurrent loop using `dispatch_apply`

* `dispatch_apply`是同步调用，需要注意死锁情况
* `dispatch_apply`执行的任务是并行loop，需要注意资源隔离和方法重入

```
    dispatch_queue_t concurrentQueue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_async(concurrentQueue, ^{
        NSLog(@"start concurrent iterating");
        size_t count = 10;
        dispatch_apply(count, concurrentQueue, ^(size_t i) {
            NSLog(@"This is %zu iteration", i);
        });
        NSLog(@"end concurrent iterating");
    });
```

9\. Suspend and resume queue

10\. Dispatch semaphore

* use for finite resource pool
* use for completion block

11\. Dispatch group

* `dispatch_group_async` with `dispatch_group_wait`
* `dispatch_group_async` with `dispatch_group_notify`
* use `dispatch_group_enter` and `dispatch_group_leave` instead of `dispatch_group_async `

12\. Create inactive queue

* use `DISPATCH_QUEUE_SERIAL_INACTIVE` or `DISPATCH_QUEUE_CONCURRENT_INACTIVE`

### dispatch source

see HelloGCD project
