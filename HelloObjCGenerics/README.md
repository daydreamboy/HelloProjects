# Objective-C Generics

---

### 1. Objective-C泛型

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C泛型[^1]是轻量级的泛型，仅用于对外接口的定义。Apple的一些集合类用到了泛型，例如NSArray，NSDictionary，NSSet等。

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用泛型的好处，如下

* 自动补全，有类型的提示
* 集合类中的元素，有泛型约束，能保证类型是一致的

### 2. 类的泛型

```
@interface GenericPetHotel<__covariant ObjectType> : NSObject
- (void)checkinPet:(ObjectType)animal withName:(NSString *)name;
- (ObjectType)checkoutPetWithName:(NSString *)name;
@end
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用__covariant ObjectType定义泛型类，.h文件中可以使用ObjectType作为参数类型，而.m文件中不能使用ObjectType，需要换成id类型。

使用这个泛型类，如下

```
GenericPetHotel<Cat *> *catHotel = [[GenericPetHotel<Cat *> alloc] init];
[catHotel checkinPet:[Cat new] withName:@"a cat"];
// Warning: Incompatible pointer types sending 'NSObject *' to parameter of type 'Cat *'
[catHotel checkinPet:[NSObject new] withName:@"NSObject"];
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C对泛型类的接口并不强制，即使接口参数不是对应的泛型类型，也不会产生编译错误，只是给出警告。


### 3. 更严格的类泛型

```
#import "Animal.h"

@interface RestrictedGenericPetHotel<__covariant ObjectType: Animal *> : NSObject
- (void)checkinPet:(Animal *)animal withName:(NSString *)name;
- (Animal *)checkoutPetWithName:(NSString *)name;
@end
```

```
#import "Swim.h"

@interface RestrictedByProtocolGenericPetHotel<__covariant ObjectType: id<Swim>> : NSObject
- (void)checkinPet:(id<Swim>)animal withName:(NSString *)name;
- (id<Swim>)checkoutPetWithName:(NSString *)name;
@end
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C的泛型类型支持泛型继承，即ObjectType可以指定一个基类或者实现某个协议的类。.h文件中的接口，都可以将ObjectType换成基类的类型。

```
// Error: Type argument 'NSString *' does not satisfy the bound ('Animal *') of type parameter 'ObjectType'
RestrictedGenericPetHotel<NSString *> *catHotel2 = [RestrictedGenericPetHotel new];
    
RestrictedGenericPetHotel<Cat *> *catHotel3 = [RestrictedGenericPetHotel new];
// Warning: Incompatible pointer types sending 'NSString *' to parameter of type 'Animal *'
[catHotel3 checkinPet:[NSString new] withName:@"a string"];
[catHotel3 checkinPet:[Cat new] withName:@"a cat"];
```

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;使用ObjectType继承基类的方式，更加严格一些，定义泛型类类型不对，会产生编译错误，但是方法的参数类型不对，则只会给出警告。

### 4. 分类的泛型

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Objective-C的分类也支持泛型[^2]，同样仅.h文件支持ObjectType。

```
@interface NSMutableArray<ObjectType> (Cat)
- (ObjectType)giveMeACat;
@end
```

### References

[^1]: http://drekka.ghost.io/objective-c-generics/
[^2]: https://stackoverflow.com/questions/32673975/is-there-a-way-to-use-objecttype-in-a-category-on-nsarray