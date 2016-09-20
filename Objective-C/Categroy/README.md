# 扩展（Category）
Category：不用继承对象，就直接增加新的method，或替换原本的method,每个class有哪些method，都是在runtime时加入的，我们可以通过runtime的class_addMethod的function，加入某个selector的操作。使用Category能够使用与class差不多的语法，同时也以一般操作method的方式，操作我们需要加入的method。

## 什么时候使用Category
当我们想要扩充的对象很难被继承时
### Foundation 对象
Foundation里面的基本对象如：NSString、NSArrar、NSDictionary、等class 的底层操作，除了可以透过Objective-C的介面呼叫外，也可以透过另一个C的介面，叫做Core Foundation,NSString 其实会对应Core Foundation里面的CFStringRef,NSArray对应CFArrayRef,我们甚至可以吧Foundation对象cast成Core Foundation的类别，当你遇到一个传入CFStringRef的function 的时候，只要建立NSString，让后cast称CFStringRef传入就可以了。
当使用alloc 、init产生一个Foundation对象的时候其实会得到一个同时有Foundation与Core Foundation操作的subclass, 而产生出来的对象，往往与你认知的有很大的差距，例如，我们认为NSMutableString 继承自NSString ，但是建立NSString 呼叫alloc、init的时候我们真正拿到的是_NSCFConstantString,而建立NSMutableString拿到的是_NSCFString,而_NSCFConstantString 其实继承自_NSCFString!
```
#define CLS(X) NSStringFromClass([x class])
NSLog(@"NSString:%@", CLS([NSString string]));
NSLog(@"NSMutableString:%@", CLS([NSMutableStringstring]));
#undef CLS
```

### Factory Method Pattern 操作的对象
Factory Method Pattern是一套用来解决不用特别指定是那个class，就可以建立对象的方法，比方说，某个class下面有许多subclass，但是对外部来说并不需要知道这些class，只要对最上层的class输入指定的条件，就能够创建符合要求的subclass。
UIKit中UIButton我们呼叫calss method： buttonWithType: ，通过传递按钮的type建立按钮事物，在大多数情况下返回UIButton对象，但是假如我们传递的type是UIRoundedRectButton。我们拿到的是UIRoundedRectButton,UIRoundedRectButton无法继承，他不在公开的header中。
### Singleton 对象
Singleton对象是指:某个class只有一个instance,每次都只对这一个instance操作，而不是建立新的instance。像UIApplication、NSUserDefault、NSNotificationCenter都采取了singleton设计。
### 在方案中多次出现的对象
随着项目的不断成长，某些class已经用的到处都是，当必须增加新的method，我们却无力把所有用到的地方都换成subclass，Category酒可以解决这种状况。

## 操作Category
语法：
```
@interface NSObject (SmallTalish)
- (void)printNl;
@end

@implementation NSObject (SmallTalish)
- (void)printNl {
  NSLog(@"%@", self);
}
@end
```
如此每一个对象都增加了printNl这个method,存档时存成NSObject+SmallTalish.h以及NSObject+SmallTalish.m;
导入头文件后可以这样呼叫
```
[myObject printNl];
```
## Category的其它用途
* 将一个很大的class切成几个部分
* 当一个class很大时，里面有很多method，我们可以考虑将这个class的method拆分成若干个category，将同一类的method放入一个category中方便管理
* 跨项目
category可以在多个项目中使用。
* 替换原来的method(不建议)
不建议这么做
這麼做卻非常危險，假如我們自己寫了一個class，我們又另外寫了一個 category 置換其中的 method，當我們日後想要修改這個 method 的內容，很容易忽略在 category中的同名 method，結果就是不管我們怎麼改動原本 method裡頭的程式，結果卻是什麼改變都沒有。
除了某一個 category 中可以出現與原本 class 中名稱相同的 method，我們甚至可以在好幾個 category 中，都出現名稱相同的 method，哪一個 category 在執行時被最後載入，就會變成是這個 category中的實作。
## Extensions
在语法上extensions像是一个没有名字的category，直接在class后面加上(),extensions定义的method，需要放在原本的class中
```
@interface MyClass : NSObject
@end

@interface MyClass ()
- (void)doSomething;
@end

@implementation MyClass
- (void)doSpmething {
}
@end
```
作用：
* 拆分Header
> 如果我们打算建一个很大的class,但是我们觉得header里面已经列出了太多的method，我们可以将一部分的method搬到extensions的定义里面。extensions除了可以放method外，还可以放成员变量。
* 管理 private Methods
> 我们在写一个class的时候，内部有一些method不需要，我们也不想放在public header中，但是不放在header中又会出现一个问题：在Xcode4.3之前，其它的method呼叫这些method的时候，compiler会不断的跳出警告，这些无关紧要的警告一多，我们往往会忽视真正重要的警告。
Category是否可以增加新的成员变量
因为Objective-C 对象会被编译成C的structure,我们虽然可以在category中增加新的method，但是我们却不能够增加新的成员变量。

使用Associated Objects，增加成员变量
引入objc/runtime.h 呼叫objc_setAssociatedObject 建立setter,用getAssociatedObject 建立getter
```
#import <objc/runtime.h>
@interface MyClass (MyCategory)
-(void)setMyVar:(NSString *)inMyVar;
- (NSString *)myVar;
@end

@implementation(MyCategory)
-(void)setMyVar:(NSString *)inMyVar {
  objc_setAssociatedObject(self, "myVar", inMyVar,OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)myVar {
  return objc_getAssociatedObject(self, "myVar");
}
```
虽然不能在category中增加成员变量，但是可以在extensions中增加；
```
@interface MyClass()
{
    NSString *myVar;
}
@end
//还可以这样
@implementation MyClass
{
  NSString *myVar;
}
@end
```
