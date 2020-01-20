//
//  Tests.m
//  Tests
//
//  Created by wesley_chen on 2019/2/14.
//  Copyright © 2019 wesley_chen. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface Tests : XCTestCase

@end

@implementation Tests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSString *string = @"\n\nfunction __export(m) {\n  for (var p in m) {\n    if (!exports.hasOwnProperty(p)) exports[p] = m[p];\n  }\n}\n\nexports.__esModule = true;\n\nvar mpds_api_1 = __webpack_require__(/*! @ali/mpds-api */ \"./node_modules/_@ali_mpds-api@0.1.18@@ali/mpds-api/dist/index.js\");\n\nvar MPAPI = {\n  call: function call(api, params, func) {\n    window.WindVane.call('OpenAPI4WindVane', 'call', params, function (data) {\n      func(data);\n    }, function (err) {\n      console.log(JSON.stringify(err));\n    });\n  },\n  getVersions: function getVersions(callback) {\n    window.WindVane.call('OpenAPI4WindVane', 'getVersions', null, function (data) {\n      callback(data);\n    }, function (err) {\n      console.log(JSON.stringify(err));\n    });\n  }\n};\nmpds_api_1.init({\n  caller: MPAPI.call,\n  versioner: MPAPI.getVersions,\n  platform: navigator.platform,\n  identity: 'default'\n});\nmpds_api_1.privateAPI.init().getVersions().subscribe(function (data) {\n  mpds_api_1.init({\n    versions: data\n  });\n}, function (err) {\n  console.log(JSON.stringify(err));\n}, function () {});\n\nfunction getIdentifier(userId, userNick) {\n  var plt = navigator.platform;\n  var isIOS = false;\n\n  if (plt && plt === 'iOS') {\n    isIOS = true;\n  }\n\n  if (isIOS) {\n    return userId + '#' + '3';\n  } else {\n    return userNick + userId;\n  }\n}\n\nexports.getIdentifier = getIdentifier;\n\n__export(__webpack_require__(/*! @ali/mpds-api */ \"./node_modules/_@ali_mpds-api@0.1.18@@ali/mpds-api/dist/index.js\"));\n\n//# sourceURL=webpack:///./node_modules/_@ali_mpds-api-windvane@0.1.25@@ali/mpds-api-windvane/dist/index.js?";
    NSLog(@"%@", string);
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
