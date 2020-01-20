//
//  Tests_JSExport.m
//  Tests
//
//  Created by wesley_chen on 2019/2/15.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Person.h"
#import "MyPoint.h"
#import "WCJSCTool.h"

#define STR_OF_JSON(...) @#__VA_ARGS__

@interface Tests_JSExport : XCTestCase

@end

@implementation Tests_JSExport

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)test_use_class_by_JSExport {
    NSString *peopleJSON = STR_OF_JSON(
    [
        { "first": "Grace",     "last": "Hopper",   "year": 1906 },
        { "first": "Ada",       "last": "Lovelace", "year": 1815 },
        { "first": "Margaret",  "last": "Hamilton", "year": 1936 }
    ]
    );
    
    NSString *JSCode = STR_OF_JSON(
       var loadPeopleFromJSON = function(jsonString) {
           var data = JSON.parse(jsonString);
           var people = [];
           for (i = 0; i < data.length; i++) {
               var person = Person.createWithFirstNameLastName(data[i].first, data[i].last);
               person.birthYear = data[i].year;
               
               people.push(person);
           }
           return people;
       }
    );
    
    JSContext *context = [[JSContext alloc] init];
    context[@"Person"] = [Person class];
    [context evaluateScript:JSCode];
    
    // get load function
    JSValue *load = context[@"loadPeopleFromJSON"];
    // call with JSON and convert to an NSArray
    JSValue *loadResult = [load callWithArguments:@[peopleJSON]];
    NSArray<Person *> *people = [loadResult toArray];
    NSLog(@"%@", people);
    XCTAssertTrue(people.count == 3);
    XCTAssertEqualObjects(people[0].firstName, @"Grace");
    XCTAssertEqualObjects(people[1].firstName, @"Ada");
    XCTAssertEqualObjects(people[2].firstName, @"Margaret");
}

- (void)test_try_mustache_JS_library {
    NSArray<Person *> *people = @[
                                  [Person createWithFirstName:@"Grace" lastName:@"Hopper"],
                                  [Person createWithFirstName:@"Ada" lastName:@"Lovelace"],
                                  [Person createWithFirstName:@"Margaret" lastName:@"Hamilton"],
                                  ];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"mustache" ofType:@"js"];
    NSString *mustacheJSCode = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    
    JSContext *context = [[JSContext alloc] init];
    [context evaluateScript:mustacheJSCode];
    
    JSValue *mustacheRender = context[@"Mustache"][@"render"];
    NSString *template = @"{{getFullName}}, firstName: {{firstName}} lastName: {{lastName}}";
    
    for (Person *person in people) {
        NSLog(@"%@", [mustacheRender callWithArguments:@[template, person]]);
    }
}

- (void)test_MyPoint {
    JSValue *value;
    MyPoint *p;
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
        
        context[@"exception"] = exception;
        JSValue *keys = [context evaluateScript:@"Object.keys(exception)"];
        NSLog(@"keys: %@", keys);
    };
    
    context[@"MyPoint"] = [MyPoint class];
    
    // `new` keyword call native method like initXXX
    [context evaluateScript:@"var p = new MyPoint(1, 2);"];
    p = [context[@"p"] toObjectOfClass:[MyPoint class]];
    XCTAssertTrue(p.x == 1);
    XCTAssertTrue(p.y == 2);
    
    [context evaluateScript:@"p.setXY(3, 4);"];
    p = [context[@"p"] toObjectOfClass:[MyPoint class]];
    XCTAssertTrue(p.x == 3);
    XCTAssertTrue(p.y == 4);
    
    // call native class method
    [context evaluateScript:@"var point = MyPoint.makePointWithXY(3, 4);"];
    value = [context evaluateScript:@"point.description();"];
    NSLog(@"%@", [value toString]);
    
    // call native property getter
    value = [context evaluateScript:@"point.x;"];
    XCTAssertTrue([value toInt32] == 3);

    // call native property setter
    [context evaluateScript:@"point.x = 10;"];
    value = [context evaluateScript:@"point.x;"];
    XCTAssertTrue([value toInt32] == 10);
    
    // use native method which renamed by JSExportAs
    [context evaluateScript:@"var point2 = MyPoint.makeMyPointWithXY(5, 6);"];
    p = [context[@"point2"] toObjectOfClass:[MyPoint class]];
    XCTAssertTrue(p.x == 5);
    XCTAssertTrue(p.y == 6);
    
    // native method which renamed by JSExportAs can't be access
    [context evaluateScript:@"var point3 = MyPoint.makePoint2WithXY(7, 8);"]; // TypeError: MyPoint.makePoint2WithXY is not a function. (In 'MyPoint.makePoint2WithXY(7, 8)', 'MyPoint.makePoint2WithXY' is undefined)
    p = [context[@"point3"] toObjectOfClass:[MyPoint class]];
    XCTAssertNil(p);
}

// @see https://stackoverflow.com/a/21680112
// Deprecated, because of var %@ = function (){ return __%@();}; will hide the class method
extern void RHJSContextMakeClassAvailable(JSContext *context, Class class){
    NSString *className = NSStringFromClass(class);
    context[[NSString stringWithFormat:@"__%@", className]] = (id) ^(void){ return [[class alloc] init]; };
    [context evaluateScript:[NSString stringWithFormat:@"var %@ = function (){ return __%@();};", className, className]];
    
    //allow a class to perform other setup upon being loaded into a context.
    SEL selector = NSSelectorFromString(@"classWasMadeAvailableInContext:");
    if ([class respondsToSelector:selector]){
        ((void (*)(id, SEL, JSContext*))[class methodForSelector:selector])(class, selector, context);
    }
}

- (void)test_RHJSContextMakeClassAvailable_issue {
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    RHJSContextMakeClassAvailable(context, [MyPoint class]);
    [context evaluateScript:@"var point = MyPoint.makePointWithXY(3, 4);"]; // TypeError: MyPoint.makePointWithXY is not a function. (In 'MyPoint.makePointWithXY(3, 4)', 'MyPoint.makePointWithXY' is undefined)
    [context evaluateScript:@"var point2 = new MyPoint(); point2.setXY(3, 4);"]; // Ok
}

- (void)test_JSValue_and_native_share_object {
    JSContext *context = [[JSContext alloc] init];
    JSValue *pointValue;
    
    MyPoint *point = [MyPoint new];
    
    // native side set initial value
    point.x = 1;
    context[@"point"] = point;
    pointValue = context[@"point"];
    NSLog(@"point: %@", point);
    NSLog(@"pointValue: %@", pointValue);
    
    // native side change value
    point.x = 2;
    NSLog(@"point: %@", point);
    NSLog(@"pointValue: %@", pointValue);
    
    // JavaScript side change value
    [context evaluateScript:@"point.x = 3;"];
    NSLog(@"point: %@", point);
    NSLog(@"pointValue: %@", pointValue);
}

- (void)test_MyPoint_not_on_main_thread {
    __block MyPoint *p;
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };

    context[@"MyPoint"] = [MyPoint class];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        [context evaluateScript:@"var p = new MyPoint(1, 2); p.setXY(3, 4);"];
        p = [context[@"p"] toObjectOfClass:[MyPoint class]];
        XCTAssertTrue(p.x == 3);
        XCTAssertTrue(p.y == 4);
    });
}

@end
