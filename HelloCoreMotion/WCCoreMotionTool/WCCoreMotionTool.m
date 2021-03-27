//
//  WCCoreMotionTool.m
//  HelloCMMotionManager
//
//  Created by wesley_chen on 2021/3/27.
//

#import "WCCoreMotionTool.h"
#import <objc/runtime.h>

#define SYNTHESIZE_ASSOCIATED_OBJECT(getterName, setterName, type)                                              \
- (void)setterName:(type)object {                                                                               \
    if (object) {                                                                                               \
        objc_setAssociatedObject(self, @selector(getterName), object, OBJC_ASSOCIATION_RETAIN_NONATOMIC);       \
    }                                                                                                           \
}                                                                                                               \
- (type)getterName {                                                                                            \
    return objc_getAssociatedObject(self, @selector(getterName));                                               \
}


@interface CMMotionManager (WCCoreMotionTool)
@property (nonatomic, strong) NSMutableDictionary<NSString *, id> *updateHandlers;
@property (nonatomic, strong) dispatch_queue_t syncQueue;
@end

@implementation CMMotionManager (WCCoreMotionTool)
SYNTHESIZE_ASSOCIATED_OBJECT(updateHandlers, setUpdateHandlers, NSMutableDictionary *);
SYNTHESIZE_ASSOCIATED_OBJECT(syncQueue, setSyncQueue, dispatch_queue_t);
@end

@implementation WCCoreMotionTool

+ (BOOL)startDeviceMotionListenerWithBizID:(NSString *)bizID updateHandler:(void (^)(CMDeviceMotion *motion, NSError *error))updateHandler {
    
    if ([self sharedMotionManager].deviceMotionAvailable == NO) {
        return NO;
    }

    dispatch_async([self sharedMotionManager].syncQueue, ^{
        [[self sharedMotionManager].updateHandlers setObject:[updateHandler copy] forKey:bizID];
        
        if ([self sharedMotionManager].deviceMotionActive == NO) {
            [self sharedMotionManager].deviceMotionUpdateInterval = 1.0 / 60;
            [self sharedMotionManager].showsDeviceMovementDisplay = YES;
            [[self sharedMotionManager] startDeviceMotionUpdatesToQueue:[self sharedOperationQueue] withHandler:^(CMDeviceMotion * _Nullable motion, NSError * _Nullable error) {
                [[self sharedMotionManager].updateHandlers enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
                    if (obj) {
                        void (^handler)(CMDeviceMotion *motion, NSError *error) = obj;
                        handler(motion, error);
                    }
                }];
            }];
        }
    });
    
    return YES;
}

+ (void)stopDeviceMotionListenerWithBizID:(NSString *)bizID completion:(void (^)(BOOL success))completion {
    if (![bizID isKindOfClass:[NSString class]] || bizID.length == 0) {
        !completion ?: completion(NO);
    }
    
    dispatch_async([self sharedMotionManager].syncQueue, ^{
        void (^handler)(CMDeviceMotion *motion, NSError *error) = [[self sharedMotionManager].updateHandlers objectForKey:bizID];
        [[self sharedMotionManager].updateHandlers removeObjectForKey:bizID];
        
        if ([self sharedMotionManager].updateHandlers.count == 0) {
            [[self sharedMotionManager] stopDeviceMotionUpdates];
        }
        
        !completion ?: completion(handler ? YES : NO);
    });
}

+ (CMMotionManager *)sharedMotionManager {
    static CMMotionManager *sMotionManager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sMotionManager = [[CMMotionManager alloc] init];
        sMotionManager.updateHandlers = [NSMutableDictionary dictionary];
        sMotionManager.syncQueue = dispatch_queue_create("com.wc.WCCoreMotionTool", DISPATCH_QUEUE_SERIAL);
    });

    return sMotionManager;
}

+ (NSOperationQueue *)sharedOperationQueue {
    static NSOperationQueue *sQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sQueue = [[NSOperationQueue alloc] init];
        sQueue.name = @"WCCoreMotionQueue";
    });
    
    return sQueue;
}

@end
