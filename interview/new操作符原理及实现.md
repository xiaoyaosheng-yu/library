> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/interview/new操作符原理及实现) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/interview/new操作符原理及实现.md)

### new 的用法

```javascript
// 定义构造函数
function Person (name) {
  this.name = name;
}

Person.prototype.age = 26;

// 创建实例
var person = new Person('前端橘子君');

// 调用实例
console.log(person.name); // 前端橘子君
console.log(person.age); // 26
console.log(person); // Person {name: "前端橘子君"}
```
这是一个很普通的实例，他们分别调用了实例和原型上的属性。

### 原理
根据**JavaScript高级程序设计**第六章构造函数模式中所写，使用`new`操作符创建实例会经过4个阶段：
- 1、创建一个新对象
- 2、将构造函数的作用域赋给新对象（因此 this 就指向了这个新对象）
- 3、执行构造函数中的代码（为这个新对象添加属性）
- 4、返回新对象

既然知道了步骤，那么我们就可以实现了。

### 实现
可能第二步比较难以理解，需要了解原型和原型链知识，详情可参考：[原型及原型链](http://xiaoysosheng.top/#/javascript/原型及原型链)。

我们先不管第二步，实现一个初始版本。

```javascript
/**
 * 实现new操作符
 * @param ctor 构造函数
 * @param args 构造函数需要的参数
*/
function _new (ctor, ...args) {
  // 第一步，创建新对象
  var obj = {};
  // 第二步，忽略
  
  // 第三步，执行构造函数，并将构造函数的初始属性都挂载在新对象上
  ctor.call(obj, ...args);
  // 返回新对象
  return obj;
}

// 定义构造函数
function Person (name) {
  this.name = name;
}
// 向构造函数的原型添加属性
Person.prototype.age = 26;

// 调用
var person = _new(Person, '前端橘子君')
console.log(person.name); // 前端橘子君
console.log(person.age); // 26
```
我们可以看到，我们可以调用实例的属性`name`，但是没法调用`Person`原型上的属性`age`，why？

因为`person`不在`Person`的原型链上，换句话说，`person`并不是`Person`的实例，验证一下。

```javascript
console.log(person instanceof Person); // false
```

不要奇怪，我们先来看看`person`和`Person`的原型链

### person和Person的原型链

不熟悉原型和原型链的请参考：[原型及原型链](http://xiaoysosheng.top/#/javascript/原型及原型链)，用最通俗易懂的语言教你了解什么是原型和原型链。

`person`的原型链：`person实例 -> Object.prototype -> null`

`Person`的原型链：`构造函数Person -> Object.prototype -> null`

我们所期望的原型链：`person实例 -> 构造函数Person -> Object.prototype -> null`

### 完整代码
既然我们知道了我们想要的原型链，通过观察，我们知道，只要将`person实例`的原型链(`__proto__`)指向`构造函数Person`的原型不就可以了么？

`obj.__proto__ = ctor.prototype`

这不就是第二步需要做的操作么？放进去再试试吧。

```javascript
/**
 * 实现new操作符
 * @param ctor 构造函数
 * @param args 构造函数需要的参数
*/
function _new (ctor, ...args) {
  // 第一步，创建新对象
  var obj = {};
  // 第二步，忽略
  obj.__proto__ = ctor.prototype
  // 第三步，执行构造函数，并将构造函数的初始属性都挂载在新对象上
  ctor.call(obj, ...args);
  // 返回新对象
  return obj;
}

// 定义构造函数
function Person (name) {
  this.name = name;
}
// 向构造函数的原型添加属性
Person.prototype.age = 26;

// 调用
var person = _new(Person, '前端橘子君')
console.log(person.name); // 前端橘子君
console.log(person.age); // 26
console.log(person instanceof Person); // true
```

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)