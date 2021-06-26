//
//  WCHeapTool.m
//  HelloNSObject
//
//  Created by wesley_chen on 2021/6/21.
//  Copyright © 2021 wesley_chen. All rights reserved.
//

#import "WCHeapTool.h"
#import "WCPointerTool.h"
#import <objc/runtime.h>
#import <malloc/malloc.h>

// Mimics the objective-c object stucture for checking if a range of memory is an object.
typedef struct {
    Class isa;
} WCFakedObject;

@implementation WCHeapTool

static CFMutableSetRef sRegisteredClasses;

+ (BOOL)allLiveObjectsWithContainerCountForClass:(out NSMutableDictionary<Class, NSArray *> **)containerCountForClass containerSizesForClass:(out NSMutableDictionary **)containerSizesForClass {
    if (containerCountForClass == NULL || containerSizesForClass == NULL) {
        return NO;
    }
    
    // Set up a CFMutableDictionary with class pointer keys and NSUInteger values.
    // We abuse CFMutableDictionary a little to have primitive keys through judicious casting, but it gets the job done.
    // The dictionary is intialized with a 0 count for each class so that it doesn't have to expand during enumeration.
    // While it might be a little cleaner to populate an NSMutableDictionary with class name string keys to NSNumber counts,
    // we choose the CF/primitives approach because it lets us enumerate the objects in the heap without allocating any memory during enumeration.
    // The alternative of creating one NSString/NSNumber per object on the heap ends up polluting the count of live objects quite a bit.
    unsigned int classCount = 0;
    __unused Class *classes = objc_copyClassList(&classCount);
    CFMutableDictionaryRef instancesForClasses = CFDictionaryCreateMutable(NULL, classCount, NULL, NULL);
//    for (unsigned int i = 0; i < classCount; i++) {
//        CFDictionarySetValue(mutableCountsForClasses, (__bridge const void *)classes[i], (const void *)0);
//    }
    
    // Enumerate all objects on the heap to build the counts of instances for each class.
    [self enumerateLiveObjectsUsingBlock:^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
        CFMutableArrayRef instancesRef = (CFMutableArrayRef)CFDictionaryGetValue(instancesForClasses, (__bridge const void *)actualClass);
        if (instancesRef == NULL) {
            instancesRef = CFArrayCreateMutable(kCFAllocatorDefault, 0, NULL);
        }
        
        // Note: objects of certain classes crash when retain is called.
        // It is up to the user to avoid tapping into instance lists for these classes.
        // Ex. OS_dispatch_queue_specific_queue
        // In the future, we could provide some kind of warning for classes that are known to be problematic.
        if (malloc_size((__bridge const void *)(object)) > 0) {
            CFArrayAppendValue(instancesRef, (__bridge const void *)object);
        }
        
        CFDictionarySetValue(instancesForClasses, (__bridge const void *)actualClass, (const void *)instancesRef);
    }];
    
    if (containerCountForClass != NULL) {
        *containerCountForClass = (__bridge_transfer id)CFDictionaryCreateCopy(kCFAllocatorDefault, instancesForClasses);
    }
    
    CFRelease(instancesForClasses);
    free(classes);
    
    return YES;
}

+ (BOOL)enumerateLiveObjectsUsingBlock:(WCHeapObjectEnumerationBlock)block {
    if (!block) {
        return NO;
    }
    
    // Refresh the class list on every call in case classes are added to the runtime.
    [self updateRegisteredClasses];
    
    // Inspired by:
    // http://llvm.org/svn/llvm-project/lldb/tags/RELEASE_34/final/examples/darwin/heap_find/heap/heap_find.cpp
    // https://gist.github.com/samdmarshall/17f4e66b5e2e579fd396
    
    vm_address_t *zones = NULL;
    unsigned int zoneCount = 0;
    kern_return_t result = malloc_get_all_zones(TASK_NULL, reader, &zones, &zoneCount);
    
    if (result == KERN_SUCCESS) {
        for (unsigned int i = 0; i < zoneCount; i++) {
            malloc_zone_t *zone = (malloc_zone_t *)zones[i];
            malloc_introspection_t *introspection = zone->introspect;

            if (!introspection) {
                continue;
            }

            void (*lock_zone)(malloc_zone_t *zone)   = introspection->force_lock;
            void (*unlock_zone)(malloc_zone_t *zone) = introspection->force_unlock;

            // Callback has to unlock the zone so we freely allocate memory inside the given block
            WCHeapObjectEnumerationBlock callback = ^(__unsafe_unretained id object, __unsafe_unretained Class actualClass) {
                unlock_zone(zone);
                block(object, actualClass);
                lock_zone(zone);
            };

            BOOL lockZoneValid = WCPointerIsReadable(lock_zone);
            BOOL unlockZoneValid =  WCPointerIsReadable(unlock_zone);

            // There is little documentation on when and why
            // any of these function pointers might be NULL
            // or garbage, so we resort to checking for NULL
            // and whether the pointer is readable
            if (introspection->enumerator && lockZoneValid && unlockZoneValid) {
                lock_zone(zone);
                introspection->enumerator(TASK_NULL, (void *)&callback, MALLOC_PTR_IN_USE_RANGE_TYPE, (vm_address_t)zone, reader, &range_callback);
                unlock_zone(zone);
            }
        }
    }
    
    return YES;
}

#pragma mark -

static void range_callback(task_t task, void *context, unsigned type, vm_range_t *ranges, unsigned rangeCount)
{
    if (!context) {
        return;
    }
    
    for (unsigned int i = 0; i < rangeCount; i++) {
        vm_range_t range = ranges[i];
        WCFakedObject *tryObject = (WCFakedObject *)range.address;
        Class tryClass = NULL;
#ifdef __arm64__
        // See http://www.sealiesoftware.com/blog/archive/2013/09/24/objc_explain_Non-pointer_isa.html
        extern uint64_t objc_debug_isa_class_mask WEAK_IMPORT_ATTRIBUTE;
        tryClass = (__bridge Class)((void *)((uint64_t)tryObject->isa & objc_debug_isa_class_mask));
#else
        tryClass = tryObject->isa;
#endif
        // If the class pointer matches one in our set of class pointers from the runtime, then we should have an object.
        if (CFSetContainsValue(sRegisteredClasses, (__bridge const void *)(tryClass))) {
            (*(WCHeapObjectEnumerationBlock __unsafe_unretained *)context)((__bridge id)tryObject, tryClass);
        }
    }
}

static kern_return_t reader(__unused task_t remote_task, vm_address_t remote_address, __unused vm_size_t size, void **local_memory)
{
    *local_memory = (void *)remote_address;
    return KERN_SUCCESS;
}

+ (CFMutableSetRef)updateRegisteredClasses {
    if (!sRegisteredClasses) {
        sRegisteredClasses = CFSetCreateMutable(NULL, 0, NULL);
    }
    else {
        CFSetRemoveAllValues(sRegisteredClasses);
    }
    unsigned int count = 0;
    Class *classes = objc_copyClassList(&count);
    for (unsigned int i = 0; i < count; i++) {
        CFSetAddValue(sRegisteredClasses, (__bridge const void *)(classes[i]));
    }
    free(classes);
    
    return sRegisteredClasses;
}

@end
