# Objective-C Generics

[TOC]
---

### 1、Objective-C泛型[^1]

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C泛型是轻量级的泛型，仅用于对外接口的定义。Apple的一些集合类用到了泛型，例如NSArray，NSDictionary，NSSet等。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用泛型的好处，如下

* 自动补全，有类型的提示
* 集合类中的元素，有泛型约束，能保证类型是一致的



### 2、类的泛型

```objective-c
@interface GenericPetHotel<__covariant ObjectType> : NSObject
- (void)checkinPet:(ObjectType)animal withName:(NSString *)name;
- (ObjectType)checkoutPetWithName:(NSString *)name;
@end
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用`__covariant ObjectType`定义泛型类，.h文件中可以使用`ObjectType`作为参数类型，而.m文件中不能使用`ObjectType`，需要换成`id`类型。

使用这个泛型类，如下

```objective-c
GenericPetHotel<Cat *> *catHotel = [[GenericPetHotel<Cat *> alloc] init];
[catHotel checkinPet:[Cat new] withName:@"a cat"];
// Warning: Incompatible pointer types sending 'NSObject *' to parameter of type 'Cat *'
[catHotel checkinPet:[NSObject new] withName:@"NSObject"];
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C对泛型类的接口并不强制，即使接口参数不是对应的泛型类型，也不会产生编译错误，只是给出警告。



### 3、更严格的类泛型

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C的泛型类型支持泛型继承，即ObjectType可以指定一个基类或者实现某个协议的类。另外，.h文件中的接口，都可以将ObjectType换成基类的类型。



* ObjectType继承基类

```objective-c
#import "Animal.h"

@interface RestrictedGenericPetHotel<__covariant ObjectType: Animal *> : NSObject
- (void)checkinPet:(Animal *)animal withName:(NSString *)name;
- (Animal *)checkoutPetWithName:(NSString *)name;
@end
```

* ObjectType继承某个协议

```objective-c
#import "Swim.h"

@interface RestrictedByProtocolGenericPetHotel<__covariant ObjectType: id<Swim>> : NSObject
- (void)checkinPet:(id<Swim>)animal withName:(NSString *)name;
- (id<Swim>)checkoutPetWithName:(NSString *)name;
@end
```



&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用ObjectType继承基类的方式，更加严格一些，定义泛型类类型不对，会产生编译错误，但是方法的参数类型不对，则只会给出警告。

```objective-c
// Error: Type argument 'NSString *' does not satisfy the bound ('Animal *') of type parameter 'ObjectType'
RestrictedGenericPetHotel<NSString *> *catHotel2 = [RestrictedGenericPetHotel new];
    
RestrictedGenericPetHotel<Cat *> *catHotel3 = [RestrictedGenericPetHotel new];

// Warning: Incompatible pointer types sending 'NSString *' to parameter of type 'Animal *'
[catHotel3 checkinPet:[NSString new] withName:@"a string"];
[catHotel3 checkinPet:[Cat new] withName:@"a cat"];
```



### 4、分类的泛型[^2]

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C的分类也支持泛型，同样仅.h文件支持ObjectType。

```objective-c
@interface NSMutableArray<ObjectType> (Cat)
- (ObjectType)giveMeACat;
@end
```



### 5、__kindof的用法

`__kindof`是Xcode 7+支持的关键词[^3]，在容器类（NSArray、NSDictionary）用于修饰元素类型。



举个例子，如下

声明`__kindof`和不带`__kindof`的属性，如下

```objective-c
@property (strong, nonatomic) NSMutableArray<UIView *> *subviews;
@property (strong, nonatomic) NSMutableArray<__kindof UIView *> *moreLooseSubviews;
```

使用NSArray时，如下

```objective-c
UIView *someView = [UIView new];
[self.subviews addObject:someView];
[self.moreLooseSubviews addObject:someView];

UIButton *someButton = [UIButton new];
[self.subviews addObject:someButton];
[self.moreLooseSubviews addObject:someButton];

__unused UIView *v1 = self.subviews[0];
__unused UIView *v2 = self.moreLooseSubviews[0];

// Warning: Incompatible pointer types initializing 'UIButton *' with an expression of type 'UIView *'
__unused UIButton *b1 = [self.subviews objectAtIndex:0];

// Fix Warning: Need type conversion
__unused UIButton *b2 = (UIButton *)[self.subviews objectAtIndex:0];

// Ok: no warning, use __kindof for UIButton is kind of UIView
__unused UIButton *b3 = [self.moreLooseSubviews objectAtIndex:0];
```

可以归纳几点

* `__kindof`描述类型的继承关系，取元素时，不会有warning

* 没有指定`__kindof`，取元素时，会报warning。消除warning需要类型转换。



可见，没有指定`__kindof`，实际上这种方式更加严格一些，推荐不使用`__kindof`[^4]。



### References

[^1]: http://drekka.ghost.io/objective-c-generics/
[^2]: https://stackoverflow.com/questions/32673975/is-there-a-way-to-use-objecttype-in-a-category-on-nsarray
[^3]: http://www.russbishop.net/objective-c-generics
[^4]: https://stackoverflow.com/a/33799210 

