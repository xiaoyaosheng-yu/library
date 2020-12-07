> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/interview/手写instanceof) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/interview/手写instanceof.md)

> `instanceof`用于判断一个实例是否属于某种类型。

### 前置知识
理解`instanceof`需要对原型和原型链有一定理解，如果有所欠缺者可以参考：

[原型及原型链](http://xiaoysosheng.top/#/javascript/原型及原型链)

### 用法

和`typeof`不同的是，`instanceof`要求开发者必须传入要比较的类型，比如：

```javascript
typeof [] // 输出`object` 

[] instanceof Array // 输出`true`
```

其返回值是一个布尔类型

### 规则
1、如果是比较基本数据类型，则输出`false`
2、其他类型，则从其原型链网上寻找，直至找到与比较类型相等的
3、如果到`Object.prototype.__proto__`仍然没有找到，则返回`false`

原型链知识请参考：[原型及原型链](http://xiaoysosheng.top/#/javascript/原型及原型链)

### 实现
```javascript
// 实现
function myInstanceof (L, R) {
  var baseType = ['string', 'number', 'boolean', 'undefined', 'symbol'];
  if (baseType.includes(typeof L)) return false; // 如果是基本数据类型，则直接输出`false`

  L = L.__proto__; // 获取当前原型

  while (true) {
    if (L === null) return false; // 找到`Object.prototype.__proto__`仍未找到
    if (L === R.prototype) return true; // 找到了与之相等的原型
    L = L.__proto__; // 如果没有找到与之相等的原型，则向上寻找
  }
}

// 调用
console.log(myInstanceof('abc', String)); // false

console.log(myInstanceof([], Array)); // true
console.log(myInstanceof([], Object)); // true

console.log(myInstanceof({}, Object)); // true

function Person () {}
let person = new Person();
console.log(myInstanceof(person, Person)); // true
```

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)