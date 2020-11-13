# this指向问题

> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/javascript/this指向问题) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/javascript/this指向问题.md)

### 特别牢记
> this的指向不是在函数定义时确定的，而是在函数**调用时**确定<br>this默认情况下指向window，严格模式下为undefined

### 隐式绑定

> 即this指向距离其**最近**的调用者

```javascript
// this的隐式绑定
function fn() {
  console.log(this);
}

var obj = {
  name: '橘子君',
  fn: function () {
    console.log(this);
  }
}

fn(); // 输出：window
obj.fn(); // 输出：{name: "橘子君", fn: ƒ}
```

用大白话来说，所谓的**最近**的调用者就函数前面最近的一个对象。

在上述代码中：
- `obj.fn()`：距离函数 fn 最近的一个调用者是`obj`，所以最终输出`{name: "橘子君", fn: ƒ}`
- `fn()`：函数`fn`没有最近的调用者，所以会指向全局`window`，即本文最开始说的，默认情况下指向`window`
- `fn()`：`fn()` 也可以理解为`window.fn()`，其最近的一个调用者就是全局的 window

### 显式绑定(强制修改)

在JS中，有一些函数可以强制修改`this`的指向，如call, apply, bind等
> 1、call, apply, bind 中的this会指向传入的第一个参数<br>2、如果这些函数调用时没有传入参数，则指向默认对象(`window`或`undefined`)

```javascript
// 显式绑定
function sum() {
  console.log(this)
}
var obj = {
  name: '橘子君'
}

sum.call(obj) // {name: "橘子君", fn: ƒ}
sum.apply() // window
sum.bind(obj)() // {name: "橘子君", fn: ƒ}
```

### 构造函数中的this
```javascript
// 构造函数的this
function Fn () {
  this.name = '橘子君';
  console.log(this);
}

// 返回一个对象类型
function Fn2 () {
  this.name = '橘子君';
  return { name: '小橘子' }
}

// 返回一个基本类型
function Fn3 () {
  this.name = '橘子君';
  return 123;
}

new Fn() // 输出：Fn {name: "橘子君"}

console.log(new Fn()) // 输出：Fn {name: "橘子君"}
console.log(new Fn2()) // 输出：{name: "小橘子"}
console.log(new Fn3()) // 输出：Fn3 {name: "橘子君"}
```

**结论：**
> 构造函数中的this指向该函数创建的实例对象

**拓展知识(new相关)**
- 1、如果该构造函数返回一个对象类型(如Object，Array，Function，Symbol， <font color='red'>null 除外</font>)，则通过`new`关键字创建的实例指向其返回值
- 2、否则返回该构造函数创建的实例对象

### 箭头函数中的this

箭头函数中的`this`是一种特别的情况，因为箭头函数本身并不存在`this`，其`this`是由**其父级作用域继承而来**

> 

```javascript
function fn () {
  return () => console.log(this)
}

var obj = {
  name: '橘子君',
  fn: function () {
    return () => console.log(this)
  }
}

fn()() // 输出：window
obj.fn()() // 输出：{name: "橘子君", fn: ƒ}
```

从上述代码来理解`箭头函数中的this由其父级作用域继承而来`这句话

从`this`的`隐式绑定`中我们知道：
- `fn()`中的`this`指向全局的`window`，而箭头函数继承自父级(即`fn`)，所以箭头函数中的`this`等于`fn()`中的`this`，即`全局window`
- 同理，`obj.fn()`中的`this`指向对象`obj`，所以`obj.fn()()`中的`this`指向`obj`

注意事项：**箭头函数中的`this`无法通过bind、call、apply进行修改**。

### 立即执行函数中的this

立即执行函数中的`this`就一句话：`永远指向全局window`

```javascript
(function () {
  console.log(this) // 输出window
})()
```


-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)