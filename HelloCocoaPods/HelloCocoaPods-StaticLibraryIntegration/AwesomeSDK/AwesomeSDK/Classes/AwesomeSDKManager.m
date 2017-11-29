//
//  AwesomeSDKManager.m
//  AwesomeSDK
//
//  Created by wesley_chen on 07/11/2017.
//

#import "AwesomeSDKManager.h"
#import <Contacts/Contacts.h>
#import <ContactsUI/ContactsUI.h>
#import <ThisAStaticLibrary/StaticClass.h>

@implementation AwesomeSDKManager
+ (void)doSomething {
    NSLog(@"test");
    CNContact *contact = [CNContact new];
    NSLog(@"%@", contact);

    StaticClass *obj = [[StaticClass alloc] initWithName:@"Jack"];
    [obj printName];
    
    NSLog(@"%@", NSStringFromClass([obj class]));
}
@end
