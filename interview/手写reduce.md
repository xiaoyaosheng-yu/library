# 手写reduce

> 接收一个函数作为累加器，数组中的每个值（从左到右）开始缩减，最终计算为一个值

### 语法
```javascript
/**
 * @param function 必要参数，用于执行每个数组元素的函数
 * @param initialValue 可选参数，传递给函数的初始值
*/
array.reduce(
  /**
   * @param total 必要参数，初始值或计算结束后的返回值。
   * @param currentValue 必要参数，当前元素
   * @param currentIndex 可选参数，当前参数的下标
   * @param arr 可选参数，数组对象
  */
  function(total, currentValue, currentIndex, arr),
  initialValue
);
```

我们看到，