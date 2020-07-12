# UIPasteboard

[TOC]

## 1、介绍

UIPasteboard对象是用于单个app内或者多个app之间分享数据。



### （1）UIPasteboard分类

目前有两种类型UIPasteboard对象

* 通用类型（General Pasteboard），通过generalPasteboard类方法获取，或者指定UIPasteboardNameGeneral名称
* 命名类型（Named Pasteboard），使用pasteboardWithName:create:或者pasteboardWithUniqueName方法创建



### （2）创建UIPasteboard

#### a. 创建通用类型（General Pasteboard）

通过generalPasteboard类方法获取，或者指定UIPasteboardNameGeneral名称

```objective-c
- (void)test_create_general_pasteboard {
    UIPasteboard *output1;
    UIPasteboard *output2;
    UIPasteboard *output3;
    
    output1 = [UIPasteboard generalPasteboard];
    output2 = [UIPasteboard pasteboardWithName:UIPasteboardNameGeneral create:NO];
    output3 = [UIPasteboard pasteboardWithName:UIPasteboardNameGeneral create:YES];
    
    XCTAssertTrue(output1 == output2);
    XCTAssertTrue(output1 == output3);
}
```



#### b. 命名类型（Named Pasteboard）

使用pasteboardWithName:create:创建

```objective-c
output1 = [UIPasteboard pasteboardWithName:@"pasteboard1" create:YES];
output2 = [UIPasteboard pasteboardWithName:@"pasteboard2" create:YES];

output3 = [UIPasteboard pasteboardWithName:@"pasteboard1" create:YES];
output4 = [UIPasteboard pasteboardWithName:@"pasteboard2" create:NO];

XCTAssertFalse(output1 == output2);
XCTAssertTrue(output1 == output3);
XCTAssertTrue(output2 == output4);
```



使用pasteboardWithUniqueName方法创建

```objective-c
output1 = [UIPasteboard pasteboardWithUniqueName];
output2 = [UIPasteboard pasteboardWithUniqueName];
XCTAssertFalse(output1 == output2);
```



### （3）移除UIPasteboard

removePasteboardWithName:方法提供移除UIPasteboard，但是对系统pasteboard无效。一旦移除后，pasteboard对象不能使用。移除pasteboard的好处是释放资源。



## 2、UIPasteboard的结构

​      UIPasteboard的items属性是存放数据的地方，items是数组，每个元素是NSDictionary，key是UTI字符串，value是对应类型的数据，支持 NSData、NSString、NSArray、NSDictionary、NSDate、NSNumber、NSURL或UIImage。

### （1）UTI（Unique Type Identifier）

UTI决定数据的类型，UIPasteboard存放数据，必须指定对应UTI的类型。目前支持下面几种类型的数组，如下

| 数组                       | 值                                                           |
| -------------------------- | ------------------------------------------------------------ |
| UIPasteboardTypeListString | "public.utf8-plain-text"<br/>"public.text"                   |
| UIPasteboardTypeListURL    | "public.url"                                                 |
| UIPasteboardTypeListImage  | "public.png"<br/>"public.jpeg"<br/>"com.compuserve.gif"<br/>"com.apple.uikit.image" |
| UIPasteboardTypeListColor  | "com.apple.uikit.color"                                      |
| UIPasteboardTypeAutomatic  | "com.apple.uikit.type-automatic"                             |



说明

> 类似"public.png"的常量定义，在<CoreServices/UTCoreTypes.h>头文件中



测试代码，如下

```objective-c
- (void)test_pasteboardType {
    NSLog(@"Strings:\n%@\n", UIPasteboardTypeListString);
    NSLog(@"URLs:\n%@\n", UIPasteboardTypeListURL);
    NSLog(@"Images:\n%@\n", UIPasteboardTypeListImage);
    NSLog(@"Colors:\n%@\n", UIPasteboardTypeListColor);
    NSLog(@"Automatic:\n%@\n", UIPasteboardTypeAutomatic);
}
```



### （2）存储单个item

UIPasteboard的提供一些API来操作items的第一个元素，如下

```objective-c
// 使用访问data和value的方法
- (NSData *)dataForPasteboardType:(NSString *)pasteboardType;
- (id)valueForPasteboardType:(NSString *)pasteboardType;
// 使用存储data和value的方法
- (void)setData:(NSData *)data forPasteboardType:(NSString *)pasteboardType;
- (void)setValue:(id)value forPasteboardType:(NSString *)pasteboardType;
// 或者使用便利方法来访问和存储
@property(nonatomic, copy) NSString *string;
@property(nonatomic, copy) UIImage *image;
@property(nonatomic, copy) NSURL *URL;
@property(nonatomic, copy) UIColor *color;
```

注意

> 即使设置的UTI类型不同，当前设置的item会覆盖之前存储的item



setValue:forPasteboardType:方法，官方文档描述，如下

> Use this method to put an object—such as an [`NSString`](dash-apple-api://load?topic_id=1408245&language=occ), [`NSArray`](dash-apple-api://load?topic_id=1411329&language=occ), [`NSDictionary`](dash-apple-api://load?topic_id=1415595&language=occ), [`NSDate`](dash-apple-api://load?topic_id=1407266&language=occ), [`NSNumber`](dash-apple-api://load?topic_id=1409820&language=occ), [`UIImage`](dash-apple-api://load?topic_id=1624118&language=occ), or [`NSURL`](dash-apple-api://load?topic_id=1409805&language=occ) object—on the pasteboard. (For images, you can also use the [`image`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622069)or [`images`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622086) properties; for all other data, such as raw binary data, use the [`setData:forPasteboardType:`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622075) method.) This method writes the object as the first item in the pasteboard. Calling this method replaces any items currently in the pasteboard.

应该是支持存放NSDictionary、NSArray等，但是通过valueForPasteboardType取出是NSData，这个NSData实际是经过NSPropertyListSerialization序列化的NSData，可以用它解析出NSDictionary、NSArray等对象。

举个例子，如下

```objective-c
[pasteboard setValue:@{ @"text": @"123" } forPasteboardType:(id)kUTTypeText];
value = [pasteboard valueForPasteboardType:(id)kUTTypeText];
XCTAssertFalse([value isKindOfClass:[NSDictionary class]]);

data = [pasteboard dataForPasteboardType:(id)kUTTypeText];
dict = [NSPropertyListSerialization propertyListWithData:data options:kNilOptions format:NULL error:&error];
XCTAssertTrue([dict isKindOfClass:[NSDictionary class]]);
XCTAssertEqualObjects(dict[@"text"], @"123");
```

> 示例代码，见test_single_items方法



### （3）存储多个item

UIPasteboard的提供一些API来操作items中多个元素，如下

```objective-c
// 直接访问和存储items
@property(nonatomic, copy) NSArray<NSDictionary<NSString *,id> *> *items;
// 使用访问data和value的方法
- (NSArray<NSData *> *)dataForPasteboardType:(NSString *)pasteboardType inItemSet:(NSIndexSet *)itemSet;
- (NSArray *)valuesForPasteboardType:(NSString *)pasteboardType inItemSet:(NSIndexSet *)itemSet;
// 使用存储data和value的方法
- (void)addItems:(NSArray<NSDictionary<NSString *,id> *> *)items;
- (void)setItems:(NSArray<NSDictionary<NSString *,id> *> *)items options:(NSDictionary<UIPasteboardOption, id> *)options; // iOS 10.0+
// 或者使用便利方法来访问和存储
@property(nonatomic, copy) NSArray<NSString *> *strings;
@property(nonatomic, copy) NSArray<UIImage *> *images;
@property(nonatomic, copy) NSArray<NSURL *> *URLs;
@property(nonatomic, copy) NSArray<UIColor *> *colors;
```

注意

> 使用便利方法设置，都会覆盖之前的数据，即使数据个数不一样。举个例子，如下
>
> ```objective-c
> pasteboard.strings = @[ @"1", @"2", @"3" ];
> 
> pasteboard.URLs = @[
>     [NSURL URLWithString:@"https://www.baidu.com/"],
>     [NSURL URLWithString:@"https://www.taobao.com/"],
> ];
> 
> XCTAssertTrue(pasteboard.strings.count == 2);
> XCTAssertEqualObjects(pasteboard.strings[0], @"https://www.baidu.com/");
> XCTAssertEqualObjects(pasteboard.strings[1], @"https://www.taobao.com/");
> 
> XCTAssertEqualObjects(pasteboard.URLs[0], [NSURL URLWithString:@"https://www.baidu.com/"]);
> XCTAssertEqualObjects(pasteboard.URLs[1], [NSURL URLWithString:@"https://www.taobao.com/"]);
> ```
>
> 

存储多个item，可以将不同类型的数据一次性存到pasteboard中。举个例子，如下

```objective-c
[pasteboard setItems:@[
    @{
        (id)kUTTypeText: @"hello, world"
    },
    @{
        (id)kUTTypeText: [UIColor redColor]
    },
    @{
        (id)kUTTypeJPEG: UIImageJPEGRepresentation([UIImage imageNamed:@"image.jpeg"], 1)
    }
]];

XCTAssertTrue(pasteboard.items.count == 3);

values = [pasteboard valuesForPasteboardType:(id)kUTTypeText inItemSet:[NSIndexSet indexSetWithIndex:1]];
data = values.firstObject;
XCTAssertTrue([data isKindOfClass:[NSData class]]);

id valueByUnarchiver = [NSKeyedUnarchiver unarchivedObjectOfClass:[UIColor class] fromData:data error:&error];
id valueByPlist = [NSPropertyListSerialization propertyListWithData:data options:kNilOptions format:NULL error:&error];
XCTAssertTrue([valueByUnarchiver isKindOfClass:[UIColor class]]);
XCTAssertTrue([valueByPlist isKindOfClass:[NSDictionary class]]);
```



setItems:options:方法（仅在iOS 10+上）有一个UIPasteboardOption参数，目前支持两个选项

| 选项                             | 值类型         | 作用                                                         |
| -------------------------------- | -------------- | ------------------------------------------------------------ |
| UIPasteboardOptionExpirationDate | NSDate         | 设置某个future时间点，系统将pasteboard中对应数据移除         |
| UIPasteboardOptionLocalOnly      | NSNumber<BOOL> | 数据是否仅当前设备。如果是NO，则可以通过Handoff功能粘贴到其他设备上 |



### （4）检查数据类型

​        如果使用便利方法设置过NSString、UIImage、NSURL和UIColor，不要通过获取值来判断是否存在，官方描述如下

> Do not use the [`string`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622092) or [`strings`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622091) properties to determine whether a pasteboard contains string data, because doing so consumes resources needlessly.

iOS 10+提供下面几个方法，用于判断对应类型是否存在，如下

```objective-c
@property(nonatomic, readonly) BOOL hasColors;
@property(nonatomic, readonly) BOOL hasImages;
@property(nonatomic, readonly) BOOL hasStrings;
@property(nonatomic, readonly) BOOL hasURLs;
```



### （5）监听pasteboard内容变化

UIPasteboard有一个changeCount属性，当pasteboard的items存在变化时，用于计算次数。

当items添加、修改或删除时，增加changeCount。当changeCount变化后，发送UIPasteboardChangedNotification和UIPasteboardRemovedNotification。这两个通知的userInfo有下面2个key，如下

* UIPasteboardChangedTypesAddedKey
* UIPasteboardChangedTypesRemovedKey

官方文档对changeCount属性，描述如下

> Whenever the contents of a pasteboard changes—specifically, when pasteboard items are added, modified, or removed—`UIPasteboard` increments the value of this property. After it increments the change count, UIPasteboard posts the notifications named [`UIPasteboardChangedNotification`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622104)(for additions and modifications) and [`UIPasteboardRemovedNotification`](dash-apple-api://load?request_key=hcPbJVw0Dk#dash_1622082) (for removals). These notifications include (in the `userInfo` dictionary) the types of the pasteboard items added or removed. Because `UIPasteboard` waits until the end of the current event loop before incrementing the change count, notifications can be batched. The class also updates the change count when an app reactivates and another app has changed the pasteboard contents. When users restart a device, the change count is reset to zero.



## 3、iOS 10+对UIPasteboard持久化的改变

UIPasteboard提供一个persistent属性，决定是否需要持久化。iOS 10+之后该方法废弃，不能支持自定义设置持久化。

区别如下表

| 系统    | General Pasteboard | Named Pasteboard                                             |
| ------- | ------------------ | ------------------------------------------------------------ |
| iOS 10+ | 系统自动设置持久化 | 不支持持久化。persistent属性设置无效。可以换成AppGroup的shared containers。 |
| iOS 9-  | 待测试             | persistent属性，如果为YES，则pasteboard的生命周期，是系统运行时期（系统重新失效）；如果NO，则pasteboard的生命周期，是进程运行时期（app杀掉失效） |

说明

> 可以进行白盒测试，基于App生命周期（App杀掉）、系统生命周期（系统重启）



