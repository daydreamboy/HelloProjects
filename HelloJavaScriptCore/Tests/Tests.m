//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/2/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <JavaScriptCore/JavaScriptCore.h>
#import "WCJSCTool.h"

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    NSLog(@"\n");
}

- (void)tearDown {
    NSLog(@"\n");
    [super tearDown];
}

- (void)testExample {
    NSString *string = @"\n\nfunction __export(m) {\n  for (var p in m) {\n    if (!exports.hasOwnProperty(p)) exports[p] = m[p];\n  }\n}\n\nexports.__esModule = true;\n\nvar mpds_api_1 = __webpack_require__(/*! @ali/mpds-api */ \"./node_modules/_@ali_mpds-api@0.1.18@@ali/mpds-api/dist/index.js\");\n\nvar MPAPI = {\n  call: function call(api, params, func) {\n    window.WindVane.call('OpenAPI4WindVane', 'call', params, function (data) {\n      func(data);\n    }, function (err) {\n      console.log(JSON.stringify(err));\n    });\n  },\n  getVersions: function getVersions(callback) {\n    window.WindVane.call('OpenAPI4WindVane', 'getVersions', null, function (data) {\n      callback(data);\n    }, function (err) {\n      console.log(JSON.stringify(err));\n    });\n  }\n};\nmpds_api_1.init({\n  caller: MPAPI.call,\n  versioner: MPAPI.getVersions,\n  platform: navigator.platform,\n  identity: 'default'\n});\nmpds_api_1.privateAPI.init().getVersions().subscribe(function (data) {\n  mpds_api_1.init({\n    versions: data\n  });\n}, function (err) {\n  console.log(JSON.stringify(err));\n}, function () {});\n\nfunction getIdentifier(userId, userNick) {\n  var plt = navigator.platform;\n  var isIOS = false;\n\n  if (plt && plt === 'iOS') {\n    isIOS = true;\n  }\n\n  if (isIOS) {\n    return userId + '#' + '3';\n  } else {\n    return userNick + userId;\n  }\n}\n\nexports.getIdentifier = getIdentifier;\n\n__export(__webpack_require__(/*! @ali/mpds-api */ \"./node_modules/_@ali_mpds-api@0.1.18@@ali/mpds-api/dist/index.js\"));\n\n//# sourceURL=webpack:///./node_modules/_@ali_mpds-api-windvane@0.1.25@@ali/mpds-api-windvane/dist/index.js?";
    NSLog(@"%@", string);
}

- (void)test_checkJSValueTypeWithValue {
    NSString *output;
    
    JSContext *context = [[JSContext alloc] init];
    
    [context evaluateScript:@"var x1;"];
    [context evaluateScript:@"var x2 = 10;"];
    [context evaluateScript:@"var x3 = 'a';"];
    [context evaluateScript:@"var x4 = true;"];
    [context evaluateScript:@"var x5 = null;"];
    [context evaluateScript:@"var x6 = Symbol('id');"];
    [context evaluateScript:@"var x7 = Math;"];
    [context evaluateScript:@"var x8 = alert;"];
    [context evaluateScript:@"var x9 = JSON;"];
    [context evaluateScript:@"var x10 = Object;"];
    [context evaluateScript:@"var x11 = () => {};"];
    
    // Case 1
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x1"] inContext:context];
    XCTAssertEqualObjects(output, @"undefined");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x2"] inContext:context];
    XCTAssertEqualObjects(output, @"number");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x3"] inContext:context];
    XCTAssertEqualObjects(output, @"string");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x4"] inContext:context];
    XCTAssertEqualObjects(output, @"boolean");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x5"] inContext:context];
    XCTAssertEqualObjects(output, @"object");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x6"] inContext:context];
    XCTAssertEqualObjects(output, @"symbol");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x7"] inContext:context];
    XCTAssertEqualObjects(output, @"object");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x8"] inContext:context];
    XCTAssertEqualObjects(output, @"undefined");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x9"] inContext:context];
    XCTAssertEqualObjects(output, @"object");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x10"] inContext:context];
    XCTAssertEqualObjects(output, @"function");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x11"] inContext:context];
    XCTAssertEqualObjects(output, @"function");
    
    // Case 2
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x1"] inContext:nil];
    XCTAssertEqualObjects(output, @"undefined");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x2"] inContext:nil];
    XCTAssertEqualObjects(output, @"number");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x3"] inContext:nil];
    XCTAssertEqualObjects(output, @"string");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x4"] inContext:nil];
    XCTAssertEqualObjects(output, @"boolean");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x5"] inContext:nil];
    XCTAssertEqualObjects(output, @"object");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x6"] inContext:nil];
    XCTAssertEqualObjects(output, @"symbol");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x7"] inContext:nil];
    XCTAssertEqualObjects(output, @"object");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x8"] inContext:nil];
    XCTAssertEqualObjects(output, @"undefined");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x9"] inContext:nil];
    XCTAssertEqualObjects(output, @"object");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x10"] inContext:nil];
    XCTAssertEqualObjects(output, @"function");
    
    output = [WCJSCTool checkJSValueTypeWithValue:context[@"x11"] inContext:nil];
    XCTAssertEqualObjects(output, @"function");
}

- (void)test_dumpPropertiesWithValue {
    NSDictionary *output;
    
    JSContext *context = [[JSContext alloc] init];
    
    output = [WCJSCTool dumpPropertiesWithValue:context[@"console"]];
    NSLog(@"%@", output);
    [context evaluateScript:@"console.log(1);"]; // No output to console
    
    output = [WCJSCTool dumpPropertiesWithValue:context[@"globalThis"]];
    NSLog(@"%@", output);
    
    output = [WCJSCTool dumpPropertiesWithValue:context.globalObject];
    NSLog(@"%@", output);
    
    [context evaluateScript:@"var globalMap = { a: 1, b: 2 };"];
    output = [WCJSCTool dumpPropertiesWithValue:context[@"globalMap"]];
    NSLog(@"%@", output);
    
    output = [WCJSCTool dumpPropertiesWithValue:context.globalObject];
    NSLog(@"%@", output);
    
    output = [WCJSCTool dumpPropertiesWithValue:context[@"JSON"]];
    NSLog(@"%@", output);
}

- (void)test_injectConsoleLogWithContext_logBlock {
    JSContext *context;
    
    // Case 1
    context = [[JSContext alloc] init];
    [WCJSCTool injectConsoleLogWithContext:context logBlock:nil];
    [context evaluateScript:@"console.log(1);"];
    
    // Case 2
    context = [[JSContext alloc] init];
    [WCJSCTool injectConsoleLogWithContext:context logBlock:^(id  _Nonnull object) {
        NSLog(@"%@", object);
    }];
    [context evaluateScript:@"console.log({a: 65});"];
}

@end
