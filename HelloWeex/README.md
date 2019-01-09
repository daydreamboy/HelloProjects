# HelloWeex
[TOC]

## 1、Weex介绍

​         Weex官方地址：http://weex.apache.org/cn/

​         官方定义Weex是，一套构建高性能、可扩展的原生应用跨平台开发方案。个人觉得有点抽象，不太好理解。围绕官方的定义，自己做另一种理解。

* 原生应用
  * 指的是Weex在Android/iOS/H5有一个引擎（或俗称SDK），这个SDK负责调用native能力完成特定的事情
* 跨平台
  * 指的是Weex在Android/iOS/H5平台各自提供自己的SDK。

* 可扩展
  * Weex SDK除了调用native能力，同时支持前端框架的DSL（Vue.js和Rax）。简单来说，使用Vue.js或者Rax的语法，作为可执行的代码。Weex去执行这些可执行代码，并调用native的接口。从使用前端框架以及部署方式来看，满足可扩展性，并能实时更新代码。
* 高性能
  * 应该指的是Weex SDK调用native的能力，接近native开发的性能。

* 开发方案
  * Weex的一整套涉及到前端、Android、iOS以及少部分服务端知识，技术栈比较广，开发可能有一定难度，所以称为开发方案，也可以接受。



## 2、Weex的HelloWorld示例

以iOS平台上的HelloWorld程序来示例Weex的开发过程。



### （1）建立Weex环境[^1]

Weex的命令行工具都是基于node.js的，所以需要安装node

```shell
$ brew install node
```



安装weex-toolkit，weex-toolkit提供weex命令行工具

```shell
$ npm install -g weex-toolkit
```



查看Weex环境的版本

node版本

```shell
$ node -v
```



npm版本

```shell
$ npm -v
```



weex-toolkit版本

```shell
$ weex -v
```



### （2）集成WeexSDK到Xcode工程

Weex在iOS平台提供CocoaPods的接入方式，pod名为WeexSDK，如下

```ruby
pod 'WeexSDK'
```



### （3）准备服务端DSL文件

DSL文件就是Vue.js文件或者Rax文件。Weex要求DSL文件后缀名为`.we`



这里采用Vue.js语法，作为示例，如下

```xml
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
HelloWeex.we文件的内容，分为三个部分

* template用于布局
* style用于样式
* script用于交互。

> 这三个部分，按照Vue.js语法来的



完成上面we文件后，使用weex命令将这个文件部署到本地服务端上。

```shell
$ weex helloweex.we
```

​        执行该命令，默认会打开浏览器访问本地服务端的网页，该网页有个QRCode，以及“查看文件源码”的超链接。

* 使用[Weex Playground](https://weex.apache.org/cn/playground.html) app可以扫二维码，预览helloweex.we对应的原生iOS界面。
* 复制“查看文件源码”的超链接，例如http://192.168.199.157:8081/helloweex.js，客户端可以使用该url（后面称为weex url）来生成WeexSDK渲染出来的view。



> [Weex Playground](https://weex.apache.org/cn/playground.html)是搭载WeexSDK的app（for iOS/Android），用于调试.we文件以及学习Weex支持的特性。



### （4）建立Weex视图[^2]

iOS客户端集成WeexSDK后，完成下面几个步骤



#### 初始化WeexSDK

在application:didFinishLaunchingWithOptions:中初始化WeexSDK

```objective-c
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

WeexSDK初始化只需一次。



#### 获取WeexSDK渲染的View

将Weex url（weex命令部署生成的url）提供给`WXSDKInstance`对象，并调用API获取View的生命周期事件。

```objective-c
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

当renderFinish被回调时，Weex渲染的view就创建出来了。

从上面过程可以得出几点结论

* 渲染过程是异步的，而且需要网络下载
* View内容是动态的，而且是实时的
* 使用WeexSDK需要管理WXSDKInstance的生命周期，以及异常情况（onFailed事件等）




### 5. Other Weex Tips

#### 5.1 创建weex模板工程

1. weex create \<weex-project\>
2. cd \<weex-project\>
3. npm install，安装依赖文件到node_modules文件夹
4. npm run dev & npm run serve，开启web服务



## 3、Weex的概念



### （1）组件

Weex组件（component）对应的是DSL的标签。Weex有下面一些内置组件[^3]。

- [`<div>`](http://weex.apache.org/cn/references/components/div.html)
- [`<image>`](http://weex.apache.org/cn/references/components/image.html)
- [`<text>`](http://weex.apache.org/cn/references/components/text.html)
- [`<a>`](http://weex.apache.org/cn/references/components/a.html)
- [`<list>`](http://weex.apache.org/cn/references/components/list.html)
- [`<cell>`](http://weex.apache.org/cn/references/components/cell.html)
- [`<recycle-list>`](http://weex.apache.org/cn/references/components/recycle-list.html)
- [ `<refresh>`&`<loading>` ](http://weex.apache.org/cn/references/components/refresh.html)
- [`<scroller>`](http://weex.apache.org/cn/references/components/scroller.html)
- [`<input>`](http://weex.apache.org/cn/references/components/input.html)
- [`<textarea>`](http://weex.apache.org/cn/references/components/textarea.html)
- [`<switch>`](http://weex.apache.org/cn/references/components/switch.html)
- [`<slider>`](http://weex.apache.org/cn/references/components/slider.html)
- [`<indicator>`](http://weex.apache.org/cn/references/components/indicator.html)
- [`video`](http://weex.apache.org/cn/references/components/video.html)
- [`<waterfall>`](http://weex.apache.org/cn/references/components/waterfall.html)
- [`<web>`](http://weex.apache.org/cn/references/components/web.html)





References
--

[^1]: https://weex-project.io/cn/guide/set-up-env.html
[^2]: https://www.cnblogs.com/liangqihui/p/6866556.html

[^3]: http://weex.apache.org/cn/references/components/index.html 