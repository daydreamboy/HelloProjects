//
//  DGUIThemeUtil.h
//  
//
//  Created by wesley chen on 2020/8/9.
//  Copyright © 2020 wesley chen. All rights reserved.
//

#ifndef DGUIThemeUtil_h
#define DGUIThemeUtil_h

#import <objc/runtime.h>

#define ExtendImplementationOfVoidMethodWithSingleArgument(_targetClass, _targetSelector, _argumentType, _implementationBlock) \
    OverrideImplementation(_targetClass, _targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
        return ^(__unsafe_unretained __kindof NSObject *selfObject, _argumentType firstArgv) {\
        void (*originSelectorIMP)(id, SEL, _argumentType);\
        originSelectorIMP = (void (*)(id, SEL, _argumentType))originalIMPProvider();\
        originSelectorIMP(selfObject, originCMD, firstArgv);\
        _implementationBlock(selfObject, firstArgv);\
        };\
});

#define ExtendImplementationOfNonVoidMethodWithSingleArgument(_targetClass, _targetSelector, _argumentType, _returnType, _implementationBlock) \
     OverrideImplementation(_targetClass, _targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
         return ^_returnType (__unsafe_unretained __kindof NSObject *selfObject, _argumentType firstArgv) {\
                _returnType (*originSelectorIMP)(id, SEL, _argumentType);\
                originSelectorIMP = (_returnType (*)(id, SEL, _argumentType))originalIMPProvider();\
                _returnType result = originSelectorIMP(selfObject, originCMD, firstArgv);\
    return _implementationBlock(selfObject, firstArgv, result);\
};\
});\

#define ExtendImplementationOfNonVoidMethodWithoutArguments(_targetClass, _targetSelector, _returnType, _implementationBlock) \
    OverrideImplementation(_targetClass, _targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {\
   return ^_returnType (__unsafe_unretained __kindof NSObject *selfObject) {\
      _returnType (*originSelectorIMP)(id, SEL);\
      originSelectorIMP = (_returnType (*)(id, SEL))originalIMPProvider();\
      _returnType result = originSelectorIMP(selfObject, originCMD);\
      return _implementationBlock(selfObject, result);\
     };\
});

#define _QMUISynthesizeId(_getterName, _setterName, _policy) \
static char kAssociatedObjectKey_##_getterName;\
- (void)_setterName:(id)_getterName {\
objc_setAssociatedObject(self, &kAssociatedObjectKey_##_getterName, _getterName, OBJC_ASSOCIATION_##_policy##_NONATOMIC);\
}\
- (id)_getterName {\
return objc_getAssociatedObject(self, &kAssociatedObjectKey_##_getterName);\
}\

#define QMUISynthesizeIdStrongProperty(_getterName, _setterName) _QMUISynthesizeId(_getterName, _setterName, RETAIN)
#define QMUISynthesizeIdCopyProperty(_getterName, _setterName) _QMUISynthesizeId(_getterName, _setterName, COPY)

#define ArgumentToString(macro) #macro
#define ClangWarningConcat(warning_name) ArgumentToString(clang diagnostic ignored warning_name)
#define BeginIgnoreClangWarning(warningName) _Pragma("clang diagnostic push") _Pragma(ClangWarningConcat(#warningName))
#define EndIgnoreClangWarning _Pragma("clang diagnostic pop")
#define BeginIgnorePerformSelectorLeaksWarning BeginIgnoreClangWarning(-Warc-performSelector-leaks)
#define EndIgnorePerformSelectorLeaksWarning EndIgnoreClangWarning


CG_INLINE BOOL
HasOverrideSuperclassMethod(Class targetClass, SEL targetSelector) {
    Method method = class_getInstanceMethod(targetClass, targetSelector);
    if (!method) return NO;
    
    Method methodOfSuperclass = class_getInstanceMethod(class_getSuperclass(targetClass), targetSelector);
    if (!methodOfSuperclass) return YES;
    
    return method != methodOfSuperclass;
}


CG_INLINE BOOL
OverrideImplementation(Class targetClass, SEL targetSelector, id (^implementationBlock)(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void))) {
    Method originMethod = class_getInstanceMethod(targetClass, targetSelector);
    IMP imp = method_getImplementation(originMethod);
    BOOL hasOverride = HasOverrideSuperclassMethod(targetClass, targetSelector);
    
    IMP (^originalIMPProvider)(void) = ^IMP(void) {
        IMP result = NULL;
        if (!imp) {
            result = imp_implementationWithBlock(^(id selfObject){});
        } else {
            if (hasOverride) {
                result = imp;
            } else {
                Class superclass = class_getSuperclass(targetClass);
                result = class_getMethodImplementation(superclass, targetSelector);
            }
        }
        return result;
    };
    
    if (hasOverride) {
        method_setImplementation(originMethod, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)));
    } else {
        const char *typeEncoding = method_getTypeEncoding(originMethod);
        class_addMethod(targetClass, targetSelector, imp_implementationWithBlock(implementationBlock(targetClass, targetSelector, originalIMPProvider)), typeEncoding);
    }
    return YES;
}


CG_INLINE BOOL
ExtendImplementationOfVoidMethodWithoutArguments(Class targetClass, SEL targetSelector, void (^implementationBlock)(__kindof NSObject *selfObject)) {
    return OverrideImplementation(targetClass, targetSelector, ^id(__unsafe_unretained Class originClass, SEL originCMD, IMP (^originalIMPProvider)(void)) {
        void (^block)(__unsafe_unretained __kindof NSObject *selfObject) = ^(__unsafe_unretained __kindof NSObject *selfObject) {
            
            void (*originSelectorIMP)(id, SEL);
            originSelectorIMP = (void (*)(id, SEL))originalIMPProvider();
            originSelectorIMP(selfObject, originCMD);
            
            if([NSThread currentThread].isMainThread) {
                implementationBlock(selfObject);
            }
            
        };

        return block;
    });
}

#endif /* DGUIThemeUtil_h */
