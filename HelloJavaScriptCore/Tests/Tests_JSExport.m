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
#import "MyCycle.h"
#import "MyCycle_noInitMethod.h"
#import "MyCycle_twoMoreInitMethod.h"
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

#pragma mark - JSExport with constructor

- (void)test_constructor_noInitMethod {
    MyCycle_noInitMethod *c;
    JSValue *value;
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception]; // TypeError: MyCycle_noInitMethodConstructor is not a constructor (evaluating 'new MyCycle_noInitMethod()')
    };
    context[@"MyCycle_noInitMethod"] = [MyCycle_noInitMethod class];
    
    // Case: `new` keyword will call JSExport init or initXXX:..: method
    [context evaluateScript:@"var c = new MyCycle_noInitMethod();"];
    value = context[@"c"];
    XCTAssertTrue(value.isUndefined);
    
    c = [value toObjectOfClass:[MyCycle_noInitMethod class]];
    XCTAssertNil(c);
    
    XCTAssertTrue(c.radius == 0);
    XCTAssertTrue(c.diameter == 0);
}

- (void)test_constructor_twoMoreInitMethod {
    MyCycle_twoMoreInitMethod *c;
    JSValue *value;
    
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        XCTAssertEqualObjects([exception toString], @"TypeError: MyCycle_twoMoreInitMethodConstructor is not a constructor (evaluating 'new MyCycle_twoMoreInitMethod()')");
    };
    context[@"MyCycle_twoMoreInitMethod"] = [MyCycle_twoMoreInitMethod class];
    
    // Case: `new` keyword call native init or init method, but only one init method in JSExport
    [context evaluateScript:@"var c = new MyCycle_twoMoreInitMethod();"]; // ERROR: Class MyCycle_twoMoreInitMethod exported more than one init family method via JSExport. Class MyCycle_twoMoreInitMethod will not have a callable JavaScript constructor function.
    value = context[@"c"];
    XCTAssertTrue(value.isUndefined);
    
    c = [value toObjectOfClass:[MyCycle_twoMoreInitMethod class]];
    XCTAssertNil(c);
    
    XCTAssertTrue(c.radius == 0);
    XCTAssertTrue(c.diameter == 0);
}

- (void)test_constructor {
    JSValue *value;
    MyCycle *c;
    JSContext *context = [[JSContext alloc] init];
    context.exceptionHandler = ^(JSContext *context, JSValue *exception) {
        [WCJSCTool printExceptionValue:exception];
    };
    
    context[@"MyCycle"] = [MyCycle class];
    
    // Case 1:
    [context evaluateScript:@"var c1 = new MyCycle();"];
    value = context[@"c1"];
    c = [value toObjectOfClass:[MyCycle class]];
    XCTAssertTrue(c.radius == 0);
    XCTAssertTrue(c.diameter == 0);
    XCTAssertTrue(c.x == 0);
    XCTAssertTrue(c.y == 0);
    
    // Case 2:
    [context evaluateScript:@"var c2 = new MyCycle(2);"];
    value = context[@"c2"];
    c = [value toObjectOfClass:[MyCycle class]];
    XCTAssertTrue(c.radius == 2);
    XCTAssertTrue(c.diameter == 4);
    XCTAssertTrue(c.x == 0);
    XCTAssertTrue(c.y == 0);
    
    // Case 3:
    [context evaluateScript:@"var c3 = new MyCycle(2, 1);"];
    c = [context[@"c3"] toObjectOfClass:[MyCycle class]];
    XCTAssertTrue(c.radius == 2);
    XCTAssertTrue(c.diameter == 4);
    XCTAssertTrue(c.x == 1);
    XCTAssertTrue(c.y == 0);
    
    // Case 4:
    [context evaluateScript:@"var c4 = new MyCycle(2, 1, 3);"];
    c = [context[@"c4"] toObjectOfClass:[MyCycle class]];
    XCTAssertTrue(c.radius == 2);
    XCTAssertTrue(c.diameter == 4);
    XCTAssertTrue(c.x == 1);
    XCTAssertTrue(c.y == 3);
}

#pragma mark -

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
