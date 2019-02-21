//
//  WCBlockTool.m
//  HelloBlocks
//
//  Created by wesley_chen on 21/11/2017.
//  Copyright © 2017 wesley_chen. All rights reserved.
//

#import "WCBlockTool.h"


// ###############################################
// Reference: https://clang.llvm.org/docs/Block-ABI-Apple.html
/*
 
struct Block_literal_1 {
    void *isa; // initialized to &_NSConcreteStackBlock or &_NSConcreteGlobalBlock
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor_1 {
    unsigned long int reserved;         // NULL
        unsigned long int size;         // sizeof(struct Block_literal_1)
        // optional helper functions
        void (*copy_helper)(void *dst, void *src);     // IFF (1<<25)
        void (*dispose_helper)(void *src);             // IFF (1<<25)
        // required ABI.2010.3.16
        const char *signature;                         // IFF (1<<30)
    } *descriptor;
    // imported variables
};
 
enum {
    BLOCK_HAS_COPY_DISPOSE =  (1 << 25),
    BLOCK_HAS_CTOR =          (1 << 26), // helpers have C++ code
    BLOCK_IS_GLOBAL =         (1 << 28),
    BLOCK_HAS_STRET =         (1 << 29), // IFF BLOCK_HAS_SIGNATURE
    BLOCK_HAS_SIGNATURE =     (1 << 30),
};
 
 */
// ###############################################

#define FLAGS_COPY_DISPOSE  (1 << 25)
#define FLAGS_SIGNATURE     (1 << 30)

struct Block_descriptor_s {
    unsigned long int reserved;
    unsigned long int size;
    // Note: the rest parts depends on `flags`
    void *rest[1];
};

struct Block_literal_s {
    void *isa;
    int flags;
    int reserved;
    void (*invoke)(void *, ...);
    struct Block_descriptor_s *descriptor;
};

@implementation WCBlockTool


+ (BOOL)isBlock:(id _Nullable)object {
    static Class blockClass;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        blockClass = [^{} class];
        while ([blockClass superclass] != [NSObject class]) {
            blockClass = [blockClass superclass];
        }
    });
    
    return [object isKindOfClass:blockClass];
}

@end

@interface WCBlockDescriptor ()
@end

@implementation WCBlockDescriptor
- (instancetype)initWithBlock:(id)block {
    self = [super init];
    if (self && block) {
        
        struct Block_literal_s *block_s = (__bridge void *)block;
        struct Block_descriptor_s *descriptor_s = block_s->descriptor;
        
        // @see https://stackoverflow.com/questions/9048305/checking-objective-c-block-type
        assert(block_s->flags & FLAGS_SIGNATURE);
        
        int index = 0;
        if (block_s->flags & FLAGS_COPY_DISPOSE) {
            index += 2;
        }
        
        const char *signature = descriptor_s->rest[index];
        
        // @see https://github.com/ebf/CTObjectiveCRuntimeAdditions/blob/master/CTObjectiveCRuntimeAdditions/CTObjectiveCRuntimeAdditions/CTBlockDescription.m
        _blockSignature = [NSMethodSignature signatureWithObjCTypes:signature];
        _block = block;
        _blockSignatureTypes = [self signatureTypes];
    }

    return self;
}

- (BOOL)isEqual:(WCBlockDescriptor *)object; {
    if ([object isKindOfClass:[self class]]) {
        return [self compareWithMethodSignature:object.blockSignature];
    }
    else {
        return NO;
    }
}

- (BOOL)isEqualToSigature:(NSMethodSignature *_Nullable)methodSignature {
    return [self compareWithMethodSignature:methodSignature];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"%@: %@", [super description], _blockSignature.description];
}

#pragma mark - Private Methods

- (BOOL)compareWithMethodSignature:(NSMethodSignature *)methodSignature {
    if (methodSignature.numberOfArguments != _blockSignature.numberOfArguments) {
        return NO;
    }
    
    if (strcmp(methodSignature.methodReturnType, _blockSignature.methodReturnType) != 0) {
        return NO;
    }
    
    for (int i = 0; i < methodSignature.numberOfArguments; i++) {
        if (strcmp([methodSignature getArgumentTypeAtIndex:i], [_blockSignature getArgumentTypeAtIndex:i]) != 0) {
            return NO;
        }
    }
    
    return YES;
}

- (NSArray<NSString *> *)signatureTypes {
    NSMutableArray *typesM = [NSMutableArray arrayWithCapacity:_blockSignature.numberOfArguments + 1];
    
    [typesM addObject:[NSString stringWithUTF8String:(_blockSignature.methodReturnType ?: "")]];
    
    for (int i = 0; i < _blockSignature.numberOfArguments; i++) {
        [typesM addObject:[NSString stringWithUTF8String:([_blockSignature getArgumentTypeAtIndex:i] ?: "")]];
    }
    
    return typesM;
}

@end

