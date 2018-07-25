//
//  Manager.m
//  header_dir
//
//  Created by wesley_chen on 10/11/2017.
//

#import "Manager.h"

@implementation Manager
- (void)doSomething {
    NSLog(@"called %@: %@", NSStringFromClass(self.class), NSStringFromSelector(_cmd));
}
@end
