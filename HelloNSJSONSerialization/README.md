# HelloNSJSONSerialization

### 1、安全使用NSJSONSerialization注意点



（1）JSON字符串转JSON对象

* 当JSON字符串不是数组或词典类型，需要使用NSJSONReadingAllowFragments，否则转成nil。举个例子，如下

```objective-c
JSONString = @"\"123\"";
data = [JSONString dataUsingEncoding:NSUTF8StringEncoding];

JSONObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:nil];
XCTAssertNil(JSONObject);

// Note: using NSJSONReadingAllowFragments allows fragments such as string, number, booleans
JSONObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
XCTAssertNotNil(JSONObject);
XCTAssertTrue([JSONObject isKindOfClass:[NSString class]]);
XCTAssertTrue([JSONObject isEqualToString:@"123"]);
```



（2）iOS 11+上NSNumber在JSON序列化中精度变很高

举个例子，如下

```objective-c
- (void)test_NSJSONSerialization_issue_on_iOS11 {
    id rootObject;
    
    // Case 1
    rootObject = @{@"num": @3.14 };
    NSError *error = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:rootObject options:kNilOptions error:&error];
    
    // BUG: https://openradar.appspot.com/34032848 (iOS 11+)
    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];;
    if (IOS11_OR_LATER) {
        XCTAssertEqualObjects(jsonString, @"{\"num\":3.1400000000000001}");
    }
    else {
        XCTAssertEqualObjects(jsonString, @"{\"num\":3.14}");
    }
}
```

网上也有人发现这个变化，

* https://openradar.appspot.com/34032848
* https://triplecc.github.io/2017/03/09/2017-03-09-nsjsonserializationhe-nsnumber/



（3）JSON对象转字符串

系统提供的方法`+[NSJSONSerialization dataWithJSONObject:options:error:]`可以将JSON对象转字符串，但是这里JSON对象仅限于NSArray和NSDictionary容器类型，如果是NSNumber/NSString/NSNull以及自定义类则会抛出异常。











