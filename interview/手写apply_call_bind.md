# 手写apply、call、bind函数

> > 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/interview/手写apply_call_bind) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/interview/%E6%89%8B%E5%86%99apply_call_bind.md)

### this指向
```javascript
// this指向
function fn () {
  console.log(this)
}

var obj = {
  name: '张三'
}
obj.fn = fn;

obj.fn() // 输出：obj
fn() // 输出window
```
> 1、非严格模式下默认指向全局的window<br>2、this指向调用者

在上述代码中
- `obj.fn()`中函数 fn 的调用者是 obj，所以最后输出`obj`对象
- `fn()`可以看作是`window.fn()`，window 是函数 fn 的调用者，所以输出`window`对象。

详情可见 [this指向问题](http://xiaoysosheng.top/#/interview/手写apply_call_bind)

### call、apply、bind的用法
```javascript
function sum (a, b) {
  console.log(a + b, this);
}

var obj = {
  name: '橘子君'
}

sum(1, 2) // window
sum.call(obj, 1, 2) // obj
sum.apply(obj, [1, 2]) // obj
sum.bind(obj)(1, 2) // obj
```

可以看到，默认状况下，`this`指向的是`window`，而call、apply、bind函数改变了this的指向.

### call的实现方式
```javascript
sum.call(obj, 1, 2)
```
先看看参数，第一个参数是目标对象，即需要修改的`this`指向的参数，其余参数为`sum`函数的真实参数

这里需要解决两个问题
- 1、怎么修改`this`指向
- 2、参数长度可变问题

第二个问题很好解决，用ES6的解构就行
第一个问题也好解决，最开始的时候说过函数中的`this`指向被调用者，那么我们在call函数内部用`obj.sum()`就可以将`this`指向调用者`obj`了

```javascript
/**
 * @params {Object} ctx 即目标对象
 * @params {any} args 真实的参数
*/
Function.prototype._call = function (ctx, ...args) { // 用结构的方法解决可变参数的问题
  ctx.fn = this; // 修改this的指向
  return ctx.fn(...args); // 此时的this指向的就是ctx
}

function sum (a, b) {
  console.log(a + b, this);
}

var obj = {
  name: '橘子君'
}
sum._call(obj, 1, 2); // 输出：3 {name: "橘子君", fn: ƒ}

var obj2 = {
  name: '橘子君',
  fn (a, b) {
    console.log(a * b, this)
  }
}
sum._call(obj2, 1, 2) // 输出：3 {name: "橘子君", fn: ƒ}
obj2.sum(1, 2) // 输出：3 {name: "橘子君", fn: ƒ}
```

可以看到，这里实现了`call`的基本功能，但是这种写法又出现了两个问题

- `目标对象ctx`中新增了一个`sum`方法
- 当目标对象中存在一个同名方法时（即上述代码中的`fn`），会覆盖对象自身的同名方法

第一个问题好解决，可以用`delete`方法进行删除

至于第二个问题，在ES6中新引入了一种数据类型：`Symbol`
> **Symbol()**: 创造一个独一无二的值，但不是字符串，而是一个新的数据类型

```javascript
var obj = {};
var n = obj[Symbol()] = 1
console.log(obj[Symbol()]) // 输出：undefined
console.log(n) // 输出： 1
```

因此我们可以用`Symbol()`来解决上述遗留的第二个问题

```javascript
Function.prototype._call = function (ctx, ...args) { // 用结构的方法解决可变参数的问题
  ctx = ctx || window; // 默认为window
  let Sym = Symbol('fn'); // 创建临时属性
  ctx[Sym] = this; // 修改this的指向
  let result = ctx[Sym](...args);
  delete ctx[Sym]; // 删除临时属性
  return result;
}

function sum (a, b) {
  console.log(a + b, this);
}

var obj = {
  name: '橘子君'
}

sum._call(obj, 1, 2); // 输出：3 {name: "橘子君"}
```

到此为止，`call`的方法已经实现了。

### apply的实现方式
apply和call的实现方法可以说是一样的，甚至说apply比call要简单，因为它的参数数量是固定的，只有2个，即目标对象和参数数组

在**call的实现方式**中，因为我们调用的时候用了解构，所以我们只要针对`call`方法修改**一行代码**就行了。

```javascript
Function.prototype._apply = function (ctx, args) { // 固定参数数量
  ctx = ctx || window;
  let Sym = Symbol('fn');
  ctx[Sym] = this;
  let result = ctx[Sym](...args);
  delete ctx[Sym];
  return result;
}

function sum (a, b) {
  console.log(a + b, this);
}

var obj = {
  name: '橘子君'
}

sum._apply(obj, [1, 2]); // 输出：3 {name: "橘子君"}
```

### bind的实现方式
`bind`函数是一个高阶函数，因为它返回的不是一个具体数值，而是一个函数
```javascript
var obj = {}
function sum(a, b) {
  console.log(a + b)
};
sum.bind(obj); // 输出：ƒ sum () {}
sum.bind(obj)(1, 2) // 输出：3
```
既然如此，我们先来看看怎么实现它。
```javascript
Function.prototype._bind = function (ctx) {
  ctx = ctx || window;
  let Sym = Symbol('fn');
  ctx[Sym] = this;
  return function (...args) { // 相比call和apply，bind方法只是多了一层外壳而已。
    // 调用方法和删除临时属性放到了返回函数体中
    let result = ctx[Sym](...args);
    delete ctx[Sym];
    return result;
  }
}
var obj = {
  name: '橘子君'
}
function sum(a, b) {
  console.log(a + b)
  console.log(this);
};
sum._bind(obj)(1,2) // 输出：3 {name: '橘子君'}
```

相比apply和call方法，不同的是bind方法将`sum`函数的实际调用和删除临时属性放到了返回的函数体中，其他的基本都是一致的。

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)