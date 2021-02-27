//
//  WCKeyboardShortcutManager.m
//  HelloObjCRuntime
//
//  Created by wesley chen on 17/1/10.
//  Copyright © 2017年 wesley chen. All rights reserved.
//

#import "WCKeyboardShortcutManager.h"
#import "WCSwizzleTool.h"
#import <objc/message.h>

#if TARGET_OS_SIMULATOR

// declare private properties for UIEvent
@interface UIEvent (UIPhysicalKeyboardEvent)

@property (nonatomic, strong) NSString *_modifiedInput;
@property (nonatomic, strong) NSString *_unmodifiedInput;
@property (nonatomic, assign) UIKeyModifierFlags _modifierFlags;
@property (nonatomic, assign) BOOL _isKeyDown;
@property (nonatomic, assign) long _keyCode;

@end

@interface WCKeyboardKeyInput : NSObject<NSCopying>
@property (nonatomic, copy, readonly) NSString *key;
@property (nonatomic, assign, readonly) UIKeyModifierFlags flags;
@property (nonatomic, copy, readonly) NSString *helpDescription;
@end

@implementation WCKeyboardKeyInput

- (BOOL)isEqual:(id)object {
    BOOL isEqual = NO;
    if ([object isKindOfClass:[WCKeyboardKeyInput class]]) {
        WCKeyboardKeyInput *keyCommand = (WCKeyboardKeyInput *)object;
        BOOL equalKeys = self.key == keyCommand.key || [self.key isEqual:keyCommand.key];
        BOOL equalFlags = self.flags == keyCommand.flags;
        isEqual = equalKeys && equalFlags;
    }
    return isEqual;
}

- (NSUInteger)hash {
    return [self.key hash] ^ self.flags;
}

- (id)copyWithZone:(NSZone *)zone {
    return [[self class] keyInputForKey:self.key flags:self.flags helpDescription:self.helpDescription];
}

- (NSString *)description {
    NSDictionary *keyMappings = @{ UIKeyInputUpArrow : @"↑",
                                   UIKeyInputDownArrow : @"↓",
                                   UIKeyInputLeftArrow : @"←",
                                   UIKeyInputRightArrow : @"→",
                                   UIKeyInputEscape : @"␛",
                                   @" " : @"␠"};
    
    NSString *prettyKey = nil;
    if (self.key && keyMappings[self.key]) {
        prettyKey = keyMappings[self.key];
    } else {
        prettyKey = [self.key uppercaseString];
    }
    
    NSString *prettyFlags = @"";
    if (self.flags & UIKeyModifierControl) {
        prettyFlags = [prettyFlags stringByAppendingString:@"⌃"];
    }
    if (self.flags & UIKeyModifierAlternate) {
        prettyFlags = [prettyFlags stringByAppendingString:@"⌥"];
    }
    if (self.flags & UIKeyModifierShift) {
        prettyFlags = [prettyFlags stringByAppendingString:@"⇧"];
    }
    if (self.flags & UIKeyModifierCommand) {
        prettyFlags = [prettyFlags stringByAppendingString:@"⌘"];
    }
    
    // Fudging to get easy columns with tabs
    if ([prettyFlags length] < 2) {
        prettyKey = [prettyKey stringByAppendingString:@"\t"];
    }
    
    return [NSString stringWithFormat:@"%@%@\t%@", prettyFlags, prettyKey, self.helpDescription];
}

+ (instancetype)keyInputForKey:(NSString *)key flags:(UIKeyModifierFlags)flags {
    return [self keyInputForKey:key flags:flags helpDescription:nil];
}

+ (instancetype)keyInputForKey:(NSString *)key flags:(UIKeyModifierFlags)flags helpDescription:(NSString *)helpDescription {
    WCKeyboardKeyInput *keyInput = [[self alloc] init];
    if (keyInput) {
        keyInput->_key = key;
        keyInput->_flags = flags;
        keyInput->_helpDescription = helpDescription;
    }
    return keyInput;
}

@end

//static const long WCKeyInputCodeDelete = 0x2a;
//static const long WCKeyInputCodeCapsLock = 0x39;
static const long WCKeyInputCodeControl = 0xe0;
static const long WCKeyInputCodeShift = 0xe1;
static const long WCKeyInputCodeAlternate = 0xe2;
static const long WCKeyInputCodeCommand = 0xe3;

@interface WCKeyboardShortcutManager ()
@property (nonatomic, strong) NSMutableDictionary *actionsForKeyInputs;

@property (nonatomic, assign, getter=isPressingShift)       BOOL pressingShift;
@property (nonatomic, assign, getter=isPressingCommand)     BOOL pressingCommand;
@property (nonatomic, assign, getter=isPressingControl)     BOOL pressingControl;
@property (nonatomic, assign, getter=isPressingAlternate)   BOOL pressingAlternate;
@end

@implementation WCKeyboardShortcutManager

#pragma mark - Public Methods

+ (instancetype)defaultManager {
    static WCKeyboardShortcutManager *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[[self class] alloc] init];
    });
    return sharedManager;
}

- (void)registerSimulatorShortcutWithKey:(NSString *)key modifiers:(UIKeyModifierFlags)modifiers action:(dispatch_block_t)action description:(NSString *)description {
    WCKeyboardKeyInput *keyInput = [WCKeyboardKeyInput keyInputForKey:key flags:modifiers helpDescription:description];
    [self.actionsForKeyInputs setObject:action forKey:keyInput];
}

- (NSString *)keyboardShortcutsDescription {
    NSMutableString *description = [NSMutableString string];
    NSArray *keyInputs = [[self.actionsForKeyInputs allKeys] sortedArrayUsingComparator:^NSComparisonResult(WCKeyboardKeyInput *input1, WCKeyboardKeyInput *input2) {
        return [input1.key caseInsensitiveCompare:input2.key];
    }];
    for (WCKeyboardKeyInput *keyInput in keyInputs) {
        [description appendFormat:@"%@\n", keyInput];
    }
    return [description copy];
}

#pragma mark

+ (void)load {
    SEL originalKeyEventSelector = NSSelectorFromString(@"handleKeyUIEvent:");
    SEL swizzledKeyEventSelector = [WCSwizzleTool swizzledSelectorWithSelector:originalKeyEventSelector];
    
    void (^handleKeyUIEventSwizzleBlock)(UIApplication *, UIEvent *) = ^(UIApplication *slf, UIEvent *event) {
        [[[self class] defaultManager] handleKeyboardEvent:event];
        
        ((void(*)(id, SEL, id))objc_msgSend)(slf, swizzledKeyEventSelector, event);
    };
    
    [WCSwizzleTool exchangeIMPWithClass:[UIApplication class] originalSelector:originalKeyEventSelector swizzledSelector:swizzledKeyEventSelector swizzledBlock:handleKeyUIEventSwizzleBlock];
}

- (instancetype)init {
    self = [super init];
    
    if (self) {
        _actionsForKeyInputs = [NSMutableDictionary dictionary];
        _enabled = YES;
    }
    
    return self;
}

- (void)handleKeyboardEvent:(UIEvent *)event {
    if (!self.enabled) {
        return;
    }
    
    NSString *modifiedInput = nil;      // modified key name, e.g. shift + key
    NSString *unmodifiedInput = nil;    // orignal key name
    UIKeyModifierFlags flags = 0;       // e.g. shift, alt, command, crtl
    BOOL isKeyDown = NO;                // strike key is down or up
    
    if ([event respondsToSelector:@selector(_modifiedInput)]) {
        modifiedInput = [event _modifiedInput];
    }
    
    if ([event respondsToSelector:@selector(_unmodifiedInput)]) {
        unmodifiedInput = [event _unmodifiedInput];
    }
    
    if ([event respondsToSelector:@selector(_modifierFlags)]) {
        flags = [event _modifierFlags];
    }
    
    if ([event respondsToSelector:@selector(_isKeyDown)]) {
        isKeyDown = [event _isKeyDown];
    }
    
    BOOL interactionEnabled = ![[UIApplication sharedApplication] isIgnoringInteractionEvents];
    BOOL hasFirstResponder = NO;
    // only when key down & printable key & app allows interactive
    if (isKeyDown && modifiedInput.length && interactionEnabled) {
        UIResponder *firstResponder = nil;
        for (UIWindow *window in [self allWindows]) {
            firstResponder = [window valueForKey:@"firstResponder"];
            if (firstResponder) {
                hasFirstResponder = YES;
                break;
            }
        }
        
        // ignore key commands (except escape) when there's an active responder
        if (firstResponder) {
            if ([unmodifiedInput isEqual:UIKeyInputEscape]) {
                [firstResponder resignFirstResponder];
            }
        }
        else {
            // create a model for key input
            WCKeyboardKeyInput *exactMatch = [WCKeyboardKeyInput keyInputForKey:unmodifiedInput flags:flags];
            
            // lookup action block for key input
            dispatch_block_t actionBlock = self.actionsForKeyInputs[exactMatch];
            
            if (!actionBlock) {
                // check again for shift + key (uppercase) or single key (Caps Lock)
                WCKeyboardKeyInput *shiftMatch = [WCKeyboardKeyInput keyInputForKey:modifiedInput flags:flags&(!UIKeyModifierShift)];
                actionBlock = self.actionsForKeyInputs[shiftMatch];
            }
            
            if (!actionBlock) {
                // check again for single key (lowercase)
                WCKeyboardKeyInput *capitalMatch = [WCKeyboardKeyInput keyInputForKey:[unmodifiedInput uppercaseString] flags:flags];
                actionBlock = self.actionsForKeyInputs[capitalMatch];
            }
            
            if (actionBlock) {
                actionBlock();
            }
        }
    }
    
    // Calling _keyCode on events from the simulator keyboard will crash.
    // It is only safe to call _keyCode when there's not an active responder.
    if (!hasFirstResponder && [event respondsToSelector:@selector(_keyCode)]) {
        // when key up, hasFirstResponder always is NO
        long keyCode = [event _keyCode];
        switch (keyCode) {
            case WCKeyInputCodeControl: { self.pressingControl = isKeyDown; break; }
            case WCKeyInputCodeCommand: { self.pressingCommand = isKeyDown; break; }
            case WCKeyInputCodeShift: { self.pressingShift = isKeyDown; break; }
            case WCKeyInputCodeAlternate: { self.pressingAlternate = isKeyDown; break; }
            default:
                break;
        }
    }
}

- (NSArray *)allWindows {
    __unsafe_unretained NSArray *windows = nil;
    
    // compose private method
    NSArray *allWindowsComponents = @[@"al", @"lWindo", @"wsIncl", @"udingInt", @"ernalWin", @"dows:o", @"nlyVisi", @"bleWin", @"dows:"];
    SEL allWindowsSelector = NSSelectorFromString([allWindowsComponents componentsJoinedByString:@""]);
    
    if ([[UIWindow class] respondsToSelector:allWindowsSelector]) {
        BOOL includeInternalWindows = YES;
        BOOL onlyVisibleWindows = NO;
        
        NSMethodSignature *methodSignature = [[UIWindow class] methodSignatureForSelector:allWindowsSelector];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:methodSignature];
        
        invocation.target = [UIWindow class];
        invocation.selector = allWindowsSelector;
        [invocation setArgument:&includeInternalWindows atIndex:2];
        [invocation setArgument:&onlyVisibleWindows atIndex:3];
        [invocation invoke];
        
        [invocation getReturnValue:&windows];
    }
    
    return windows;
}

@end

#endif
