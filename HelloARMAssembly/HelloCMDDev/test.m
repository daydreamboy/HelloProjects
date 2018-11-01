// clang -framework Cocoa -fobjc-arc test.m
// code from https://www.mikeash.com/pyblog/friday-qa-2011-12-16-disassembling-the-assembly-part-1.html
// clang -S test.m -o test.s -fobjc-arc

#import <Cocoa/Cocoa.h>


@interface MyClass : NSObject
{
    NSString *_name;
    int _number;
}

- (id)initWithName: (NSString *)name number: (int)number;

@property (strong) NSString *name;
@property int number;

@end

@implementation MyClass

@synthesize name = _name, number = _number;

- (id)initWithName: (NSString *)name number: (int)number
{
    if((self = [super init]))
    {
        _name = name;
        _number = number;
    }
    return self;
}

@end

NSString *MyFunction(NSString *parameter)
{
    NSString *string2 = [@"Prefix" stringByAppendingString: parameter];
    NSLog(@"%@", string2);
    return string2;
}

int main(int argc, char **argv)
{
    @autoreleasepool
    {
        MyClass *obj = [[MyClass alloc] initWithName: @"name" number: 42];
        NSString *string = MyFunction([obj name]);
        NSLog(@"%@", string);
        return 0;
    }
}