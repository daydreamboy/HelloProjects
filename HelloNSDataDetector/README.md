## HelloNSDataDetector



NSDataDetector继承自NSRegularExpression，它可以检测如下类型

```objective-c
typedef NS_OPTIONS(uint64_t, NSTextCheckingType) {    // a single type
    NSTextCheckingTypeOrthography           = 1ULL << 0,            // language identification
    NSTextCheckingTypeSpelling              = 1ULL << 1,            // spell checking
    NSTextCheckingTypeGrammar               = 1ULL << 2,            // grammar checking
    NSTextCheckingTypeDate                  = 1ULL << 3,            // date/time detection
    NSTextCheckingTypeAddress               = 1ULL << 4,            // address detection
    NSTextCheckingTypeLink                  = 1ULL << 5,            // link detection
    NSTextCheckingTypeQuote                 = 1ULL << 6,            // smart quotes
    NSTextCheckingTypeDash                  = 1ULL << 7,            // smart dashes
    NSTextCheckingTypeReplacement           = 1ULL << 8,            // fixed replacements, such as copyright symbol for (c)
    NSTextCheckingTypeCorrection            = 1ULL << 9,            // autocorrection
    NSTextCheckingTypeRegularExpression API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0))  = 1ULL << 10,           // regular expression matches
    NSTextCheckingTypePhoneNumber API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0))        = 1ULL << 11,           // phone number detection
    NSTextCheckingTypeTransitInformation API_AVAILABLE(macos(10.7), ios(4.0), watchos(2.0), tvos(9.0)) = 1ULL << 12            // transit (e.g. flight) info detection
};
```



当检测类型为NSTextCheckingTypeLink，NSDataDetector检测的url不局限于http或者https，甚至满足xxx://domain，这种格式都被识别成link。WCDataDetector增加只检测http或者https的属性，并修改不正确的scheme。

（TODO）

