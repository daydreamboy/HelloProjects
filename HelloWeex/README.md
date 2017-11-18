# HelloWeex
--

### 1. Setup Weex Environment[^1]

* brew install node   
`node -v`，`npm -v`
* npm install -g weex-toolkit    
`weex -v`

### 2. Integrate WeexSDK to Xcode project

Podfile

```
pod 'WeexSDK'
```

### 3. Prepare server-end files

* Write .we file

```
<!-- Note: template for layout -->
<template>
  <div>
    <image class="thumbnail" src="http://image.coolapk.com/apk_logo/2015/0817/257251_1439790718_385.png"></image>
    <text class="title" onclick="onClickTitle">Hello Weex</text>
  </div>
</template>

<!-- Note: style for render -->
<style>
  .title { color: red; }
</style>

<!-- Note: script for interaction -->
<script>
  module.exports = {
    methods: {
      onClickTitle: function (e) {
        console.log(e);
        // alert("title clicked.");
      }
    }
  }
</script>
```
&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;.we文件采用vue语法，分为三个部分：template用于布局，style用于样式，script用于交互。

* start server for provide .we file

```
$ weex helloweex.we
```

打开web server提供helloweex.js的url访，页面中有个url（例如http://192.168.199.157:8081/helloweex.js），需要客户端去访问。

### 4. Setup a Weex View[^2]

* 在application:didFinishLaunchingWithOptions:中注册WeexSDK

```
- (void)setupWeex {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //business configuration
        [WXAppConfiguration setAppGroup:@"AliApp"];
        [WXAppConfiguration setAppName:@"WeexDemo"];
        [WXAppConfiguration setAppVersion:@"1.0.0"];
        
        //init sdk environment
        [WXSDKEngine initSDKEnvironment];
        
        //set the log level
        [WXLog setLogLevel:WXLogLevelAll];
    });
}
```

* 使用WXSDKInstance对象绑定js的url并获取对应的weex view

```
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.weexSDK.viewController = self;
    self.weexSDK.frame = CGRectMake(0, 64, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) - 64);
    
    [self.weexSDK renderWithURL:[NSURL URLWithString:self.weexUrl]];
    
    __weak typeof(self) weakSelf = self;
    self.weexSDK.onCreate = ^(UIView *view) {
        NSLog(@"weexSDK onCreate");
        [weakSelf.view addSubview:view];
    };
    
    self.weexSDK.renderFinish = ^(UIView *view) {
        NSLog(@"weexSDK renderFinish");
    };
    
    self.weexSDK.onFailed = ^(NSError *error) {
        NSLog(@"weexSDK onFailed : %@\n", error);
    };
}

- (void)dealloc {
    [_weexSDK destroyInstance];
}

#pragma mark - Getters

- (WXSDKInstance *)weexSDK {
    if (!_weexSDK) {
        _weexSDK = [WXSDKInstance new];
    }
    return _weexSDK;
}
```

上面self.weexUrl是server端提供的url，对应的是一个将we文件编译好的js文件。


### 5. Other Weex Tips

#### 5.1 创建weex模板工程

1. weex create \<weex-project\>
2. cd \<weex-project\>
3. npm install，安装依赖文件到node_modules文件夹
4. npm run dev & npm run serve，开启web服务

References
--

[^1]: https://weex-project.io/cn/guide/set-up-env.html
[^2]: https://www.cnblogs.com/liangqihui/p/6866556.html
