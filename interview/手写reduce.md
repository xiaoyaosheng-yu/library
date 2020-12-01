# 手写reduce
> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/interview/手写reduce) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/interview/手写reduce.md)

> 接收一个函数作为累加器，遍历数组中的每个值（从左到右），最终计算并返回为一个值

### 语法
```javascript
/**
 * @param function 必要参数，用于执行每个数组元素的函数
 * @param initialValue 可选参数，传递给函数的初始值
*/
array.reduce(
  /**
   * @param total 必要参数，初始值或计算结束后的结果。
   * @param currentValue 必要参数，当前元素
   * @param currentIndex 可选参数，当前参数的下标
   * @param arr 可选参数，数组对象
  */
  function(total, currentValue, currentIndex, arr),
  initialValue
);
```

我们注意：

1、`reduce`方法接受两个参数(详见上述注释)。

2、累加函数`callback`接受4个参数(详见上述注释)，其中特别说明的是，如果初始值`initialValue`不存在，则`total`为数组第一项，`currentValue`为下一项。

3、如果数组为空数组，则返回初始值(默认为undefined)。

### 初始值存在

我们暂时只考虑初始值`currentValue`存在的情况，看看怎么手撕`reduce`。

先看看怎么用
```javascript
var arr = [1, 2, 3, 4, 5];
// 调用
arr.reduce(function (total, currentValue) {
  // 返回累加的结果
  return total + currentValue;
}, 0);
```

我们需要考虑一个问题，`reduce`内部怎么获取`arr`数组，如果像上述例子，累加器只传两个参数，那么肯定不能通过第四个参数获取，这个时候我们可以考虑`this`了，因为此时的`this`指向的就是`arr`，具体不细说了，可以参考[this指向问题](http://xiaoysosheng.top/#/javascript/this指向问题)。

再来看怎么实现。
```javascript
Array.prototype.reduce2 = function (callback, initialValue) { // 接受两个参数，累加器和初始值
  let i = 0;
  // 如果初始值存在，则第一次计算的值即为初始值
  for (i; i < this.length; i++) {
    // 通过 callback 的计算规则对数组进行累加
    initialValue = callback(initialValue, this[i], i, this);
  }
  return initialValue;
}

var array = [1, 2, 3, 4, 5];
array.reduce2(function (a, b) {
  return a + b;
}, 0); // 输出15
```

根据`reduce`定义我们知道，其最终返回的是一个值，这个值怎么获取呢？**初始值 + 数组根据callback的规则计算后的值**。

怎么理解**数组根据callback的规则计算后的值**这句话？

很简单，就是`callback`只是一个计算规则，`reduce`内部会根据这个规则对数组进行遍历计算。

### 初始值不存在
我们知道，`initialValue`是一个可选项，可以是任意值，任意类型，甚至这个值还可以不传。

上面已经考虑了初始值存在的问题，这里就考虑一下初始值不存在时的情况。

```javascript
Array.prototype.reduce2 = function (callback, initialValue) { // 接受两个参数，累加器和初始值
  let i = 0;
  if (!initialValue) {
    initialValue = this[i]; // 将数组的第一项作为初始值
    i++; // 将当前值设置为数组的第二项的值
  }
  // -------------
  for (i; i < this.length; i++) {
    // 通过 callback 的计算规则对数组进行累加
    initialValue = callback(initialValue, this[i], i, this);
  }
  return initialValue;
}

var array = [1, 2, 3, 4, 5];
array.reduce2(function (a, b) {
  return a + b;
}); // 输出15
```

我们看到这里其实无初始值和有初始值唯一的区别就是：当没有初始值时，手动将数组的第一项设置为初始值，将数组的第二项设置为当前值。这也是对**语法**章节中第二点的解释。

手撕`reduce`的源码到这里就差不多了，只是这里还缺少一些校验，比如校验累计器`callback`是否为一个函数；如果数组为空时，如何返回；`this`是否为一个数组，我们来优化一下。

### 优化
```javascript
Array.prototype.reduce2 = function (callback, initialValue) { // 接受两个参数，累加器和初始值
  // 校验
  if (!Array.isArray(this)) {
    throw('调用对象必须是一个数组');
  }
  if (typeof callback != 'function') {
    throw('累计器必须是一个函数类型');
  }
  if (this.length === 0) {
    return initialValue;
  }
  // 正式开始
  let i = 0;
  if (!initialValue) {
    initialValue = this[i]; // 将数组的第一项作为初始值
    i++; // 将当前值设置为数组的第二项的值
  }
  for (i; i < this.length; i++) {
    // 通过 callback 的计算规则对数组进行累加
    initialValue = callback(initialValue, this[i], i, this);
  }
  return initialValue;
}
```

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)