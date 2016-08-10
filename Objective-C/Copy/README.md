# 深拷贝与浅拷贝
浅拷贝，不拷贝对象本身，只拷贝对象的指针；深拷贝则拷贝对象到另一块地址中
浅复制就是指针拷贝；深复制就是内容拷贝。

## 要对对象进行拷贝，对象必须实现NSCopying(对应copy) NSMutableCopying（对应mutableCopy） 协议并要实现相应的方法
NSCopying
```
  - (id)copyWithZone:(nullable NSZone *)zone {
   [self class] className = [[[self class] allocWithZone:zone] init];
  // set porperties  ...
  return className;
  }
```

NSMutableCopying //自定义的 一般没有可变的对象


## 系统非集合类对象（指的是 NSString, NSNumber）的copy 与 mutableCopy

```
  NSString *string = @"origin";
  NSString *stringCopy = [string copy];
  NSMutableString *mutableString = [string mutableCopy];
```

string 与 stringCopy 地址一样 是浅拷贝，与mutableString地址不一样 进行了内容拷贝

```
  NSMutableString *string = [NSMutableString stringWithString: @"origin"];
  //copy
  NSString *stringCopy = [string copy];
  NSMutableString *mStringCopy = [string copy];
  NSMutableString *stringMCopy = [string mutableCopy];
  //change value
  [mStringCopy appendString:@"mm"]; //crash
  [string appendString:@" origion!"];
  [stringMCopy appendString:@"!!"];
```

copy 返回的对象是不可变的（[mStringCopy appendString:@"mm"] 会cash）;四个对象的地址都不一样，进行的都是内容拷贝
### 综上两个例子，我们可以得出结论：


  在非集合类对象中：对immutable对象进行copy操作，是指针复制，mutableCopy操作时内容复制；对mutable对象进行copy和mutableCopy都是内容复制。用代码简单表示如下：

* [immutableObject copy] // 浅复制
* [immutableObject mutableCopy] //深复制
* [mutableObject copy] //深复制
* [mutableObject mutableCopy] //深复制


## 集合对象(NSArray,NSSet,NSDictionary...) 的浅拷贝与深拷贝

浅拷贝 ：只拷贝地址，不拷贝内容 
单层深拷贝 ：拷贝内容到新的地址，但是集合元素的地址不变；
完全深拷贝 ：集合与内容的地址都发生变化。
```
  NSArray *array = @[ copy01, copy02, copy03 ];
  NSMutableArray *marray = [array mutableCopy];  //单层深拷贝
  NSArray *copyArray = [array copy];  //浅拷贝

  NSMutableArray *marray = [[NSMutableArray alloc] initWithArray:array];  //单层深拷贝
  NSMutableArray *marray_2 =
  [[NSMutableArray alloc] initWithArray:array copyItems:NO];  //单层深拷贝
  NSMutableArray *marray_3 =
  [[NSMutableArray alloc] initWithArray:array copyItems:YES]; //完全深拷贝(集合内的对象也会之行mutableCopy方法，如果没有实现NSMutableCopying 会carsh)
  NSArray *copyArray = [marray copy]; //单层深拷贝
  NSMutableArray *mutableCopyArray = [marray mutableCopy]; //单层深拷贝

```
结论
在集合类对象中，对immutable对象进行copy，是指针复制，mutableCopy是内容复制；对mutable对象进行copy和mutableCopy都是内容复制。但是：集合对象的内容复制仅限于对象本身，对象元素仍然是指针复制。用代码简单表示如下：

* [immutableObject copy] // 浅复制
* [immutableObject mutableCopy] //单层深复制
* [mutableObject copy] //单层深复制
* [mutableObject mutableCopy] //单层深复制



