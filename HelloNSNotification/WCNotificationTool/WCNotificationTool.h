//
//  WCNotificationTool.h
//  HelloNSNotification
//
//  Created by wesley_chen on 2021/4/1.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface WCNotificationTool : NSObject

#pragma mark - Auto remove from NSNotificationCenter

/**
 Add observer to NSNotificationCenter with selector
 
 @param observer the observer
 @param selector the selector
 @param name the notification name
 @param object the object
 
 @return YES if registered successfully, NO if parameters are wrong or the observer has yet registered
 @see https://github.com/intuit/AutoRemoveObserver
 */
+ (BOOL)addObserver:(id)observer selector:(SEL)selector name:(nullable NSNotificationName)name object:(nullable id)object;

/**
 Add observer to NSNotificationCenter with block
 
 @param observer the observer
 @param name the notification name
 @param object the object
 @param queue the queue
 @param block the callback
 
 @return YES if registered successfully, NO if parameters are wrong or the observer has yet registered
 */
+ (BOOL)addObserver:(id)observer name:(nullable NSNotificationName)name object:(nullable id)object queue:(nullable NSOperationQueue *)queue usingBlock:(void (^)(NSNotification *notification))block;

@end

NS_ASSUME_NONNULL_END
