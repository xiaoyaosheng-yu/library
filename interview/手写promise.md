> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/interview/手写promise) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/interview/手写promise.md)

`promise`就是将异步任务队列化，将多个异步任务按照顺序输出，同时用链式调用解决回调地狱的问题。

文章尾部附上完整源码

### 用法
```javascript
var p = new Promise((resolve, reject) => {
  setTimeout(() => {
    resolve('我是异步返回的数据')
  }, 1000);
});

p.then(data => {
  console.log(data);
});
```

### promise规范

- 存在三个状态：等待态(pending)，执行态(fulfilled)，失败态(rejected)
- 初始态为等待态，可以转化为执行态和失败态
- 执行态不可转化为其他状态，且必须有一个不可变的终值(value)
- 失败态不可转化为其他状态，且必须有一个不可变的原因(reason)
- 必须提供一个`then`方法，以供访问其当前值，终值及原因
- `then`方法提供两个参数：`onFulfilled`和`onRejected`
- `onFulfilled`和`onRejected`如果不是函数类型，必须忽略其
- 如果`executor`执行报错，直接执行`reject`
- 不同的`promise`可以相互套用

更多规范细节可以参考[Promise A+ 规范](https://malcolmyu.github.io/2015/06/12/Promises-A-Plus)

### 规范版的初始版本
```javascript
// 依据规范生成初始版本
class NewPromise {
  constructor (executor) {
    // 存在三种状态
    this.enumStatus = {
      PADDING: 'padding',
      FULFILLED: 'fulfilled',
      REJECTED: 'rejected'
    };
    // 初始态为等待态
    this.state = this.enumStatus.PADDING;
    // 必须存在一个终值
    this.value = '';
    // 必须存在一个被拒绝的原因
    this.reason = '';
    // 转化执行态
    let resolve = (value) => {
      // 修改状态
      this.state = this.enumStatus.FULFILLED;
      // 必须有一个终值
      this.value = value;
    };
    // 转化失败态
    let reject = (reason) => {
      // 修改状态
      this.state = this.enumStatus.REJECTED;
      // 如果是失败态，必须有一个据因
      this.reason = reason;
    };
    // 如果executor执行报错，直接执行reject
    try {
      executor(resolve, reject);
    } catch (err) {
      reject(err);
    }
  }
  // 必须包含then方法
  then (onFulfilled, onRejected) {
    // 保证onFulfilled和onRejected都是函数类型
    onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : value => value;
		onRejected = typeof onRejected === 'function' ? onRejected : err => { Throw(err) };
    // 如果当前状态为执行态，则执行onFulfilled函数，将终值作为该函数的参数，否则忽略其
    if (this.state === this.enumStatus.FULFILLED) {
      onFulfilled(this.value);
    }
    // 如果当前状态为拒绝态，则执行onRejected函数，将据因作为该函数的参数，否则忽略其
    if (this.state === this.enumStatus.REJECTED) {
      onRejected(this.reason);
    }
  }
}
```

此时的Promise已经可以实现基本的功能了，不信的话调用看看。
```javascript
var p = new NewPromise((resolve, reject) => {
  resolve('前端橘子君');
});

p.then((data) => {
  console.log(data);
});
// 输出前端橘子君
```

但是这个不能解决异步问题。
```javascript
var p = new NewPromise((resolve, reject) => {
  // 模拟服务器返回数据
  setTimeout(() => {
    resolve('前端橘子君');
  }, 1000);
});

p.then((data) => {
  console.log(data);
});

// 不会打印任何东西
```

怎么解决这个问题呢？我们可以借助[发布-订阅者模式](http://xiaoysosheng.top/#/mode/发布订阅者模式)来处理。

不管在响应服务器返回数据期间`then`函数中做了什么，用一个队列来将`then`中的操作依次保存起来，等服务器的数据返回后依次执行依次不就可以了么？

### 解决promise异步问题
只将修改部分的代码，不再多述其他重复代码
```javascript
class NewPromise {
  constructor (executor) {
    ...
    // 任务中心
    this.onFulfilledQueue = [];
    this.onRejectedQueue = [];
    // 转化执行态
    let resolve = (value) => {
      ...
      // 当服务器数据返回时，依次执行预存的成功事务
      this.onFulfilledQueue.map(fn => fn(this.value));
    };
    // 转化失败态
    let reject = (reason) => {
      ...
      // 当服务器数据返回时，依次执行预存的失败事务
      this.onRejectedQueue.map(fn => fn(this.reason));
    };
    ...
  }
  then (onFulfilled, onRejected) {
    ...
    // 如果当前状态为等待态，则将其加入事务
    if (this.state === this.enumStatus.PADDING) {
      this.onFulfilledQueue.push(() => {
        onFulfilled(this.value);
      });
      this.onRejectedQueue.push(()=> {
        onRejected(this.reason);
      });
    }
  }
}
```

再执行一下上面的操作，肯定会输出你想要的结果。

还有两个问题：
- 1、既然可以链式调用，则说明其返回的是一个`Promise`对象，new 一个作为结果不就可以了么。
- 2、链式调用，如果用户将自身作为结果返回，会造成死循环，所以我们需要对其进行一些比较处理
- 3、其他(详情参考[Promise A+ 规范](https://malcolmyu.github.io/2015/06/12/Promises-A-Plus))

### 解决方案
- 如果`promise`和`x`相等，则拒绝执行`promise`
- 如果`x`是一个对象或函数，且其有`then`属性是一个函数，则以`x`作为作用域执行`then`函数
- 如果`then`执行后返回的值仍然是一个`promise`，则递归调用`resolvePromise`
- 否则以`x`为参数执行`promise`
- 如果`x`不是一个对象或函数，则以`x`为参数执行`promise`

```javascript
/**
 * @param promise2 新的promise
 * @param x 原始的promise
 * @param resolve promise2的resolve
 * @param reject promise2的reject
*/
function resolvePromise(promise2, x, resolve, reject) {
  // 防止循环调用
  if (promise2 === x) {
    reject(Throw('不允许循环调用'));
  }
  if (x != null && (typeof x === 'object' || typeof x === 'function')) {
    //函数或对象
    let then = x.then;
    if (typeof then === 'function') {
      // 如果函数运行后的返回值仍然是一个promise，则递归调用resolvePromise
      then.call(x, res => resolvePromise(promise2, res, resolve, reject), err => reject(err));
    }else {
      resolve(x);
    }
  } else {
    //普通值
    resolve(x)
  }
}
```

### 改造then方法
通过了解决方案，我们接着在`then`方法中使用`resolvePromise`
```javascript
class NewPromise {
  ...
  then (onFulfilled, onRejected) {
    // 保证onFulfilled和onRejected都是函数类型
    onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : value => value;
    onRejected = typeof onRejected === 'function' ? onRejected : err => { Throw(err) };
    let promise2 = new NewPromise((resolve, reject) => {
      // 如果onFulfilled是函数类型，且状态为执行态，则执行该函数，将终值作为该函数的参数，否则忽略其
      if (this.state === this.enumStatus.FULFILLED) {
        setTimeout(() => {
          resolvePromise(promise2, onFulfilled(this.value), resolve, reject);
        }, 0);
      }
      // 如果onRejected是函数类型，且状态为拒绝态，则执行该函数，将据因作为该函数的参数，否则忽略其
      if (this.state === this.enumStatus.REJECTED) {
        setTimeout(() => {
          resolvePromise(promise2, onRejected(this.reason), resolve, reject);
        }, 0);
      }
      // 如果当前状态为等待态，则将其加入事务
      if (this.state === this.enumStatus.PADDING) {
        this.onFulfilledQueue.push(() => {
          resolvePromise(promise2, onFulfilled(this.value), resolve, reject);
        });
        this.onRejectedQueue.push(()=> {
          resolvePromise(promise2, onRejected(this.reason), resolve, reject);
        });
      }
    });
    return promise2;
  }
}
```

其实对`then`方法的改造并没有那么多，只是将原本调用的地方用`resolvePromise`替换了而已，很多人会说为什么会有一个`setTimeout`呢？

如果仔细看过规范的话里边涉及到一条，`then 方法可以被同一个 promise 调用多次`。

返回的`promise`是一个异步对象，如果不使用`setTimeout`，就有可能只执行第一个`then`，后边的就不会执行了，这点请自行验证。

调用试试
```javascript
var p1 = new NewPromise((resolve, reject) => {
  setTimeout(() => {
    resolve('前端橘子君');
  }, 3000);
});

var p2 = new NewPromise((resolve, reject) => {
  setTimeout(() => {
    resolve('我是链式调用的结果')
  }, 3000);
})

p1.then((data) => {
  console.log(data);
  return p2;
}).then(data => {
  console.log(data);
});
```

至此，`promise`才算真正的完成了。

本案例不是完整代码，因为该案例还有多个地方没有设计的，比如，`promise.all`，`promise.resolve`, `promise.reject`, `promise.race`，所以本文仅供学习参考使用

### 案例完整代码
```javascript
// 依据规范生成初始版本
class NewPromise {
  constructor (executor) {
    // 存在三种状态
    this.enumStatus = {
      PADDING: 'padding',
      FULFILLED: 'fulfilled',
      REJECTED: 'rejected'
    };
    // 初始态为等待态
    this.state = this.enumStatus.PADDING;
    // 必须存在一个终值
    this.value = '';
    // 必须存在一个被拒绝的原因
    this.reason = '';
    // 任务中心
    this.onFulfilledQueue = [];
    this.onRejectedQueue = [];
    // 转化执行态
    let resolve = (value) => {
      // 修改状态
      this.state = this.enumStatus.FULFILLED;
      // 必须有一个终值
      this.value = value;
      // 当服务器数据返回时，依次执行预存的成功事务
      this.onFulfilledQueue.map(fn => fn(this.value));
    };
    // 转化失败态
    let reject = (reason) => {
      // 修改状态
      this.state = this.enumStatus.REJECTED;
      // 如果是失败态，必须有一个据因
      this.reason = reason;
      // 当服务器数据返回时，依次执行预存的失败事务
      this.onRejectedQueue.map(fn => fn(this.reason));
    };
    // 如果executor执行报错，直接执行reject
    try {
      executor(resolve, reject);
    } catch (err) {
      reject(err);
    }
  }
  // 必须包含then方法
  then (onFulfilled, onRejected) {
    // 保证onFulfilled和onRejected都是函数类型
    onFulfilled = typeof onFulfilled === 'function' ? onFulfilled : value => value;
    onRejected = typeof onRejected === 'function' ? onRejected : err => { Throw(err) };
    let promise2 = new NewPromise((resolve, reject) => {
      // 如果onFulfilled是函数类型，且状态为执行态，则执行该函数，将终值作为该函数的参数，否则忽略其
      if (this.state === this.enumStatus.FULFILLED) {
        setTimeout(() => {
          resolvePromise(promise2, onFulfilled(this.value), resolve, reject);
        }, 0);
      }
      // 如果onRejected是函数类型，且状态为拒绝态，则执行该函数，将据因作为该函数的参数，否则忽略其
      if (this.state === this.enumStatus.REJECTED) {
        setTimeout(() => {
          resolvePromise(promise2, onRejected(this.reason), resolve, reject);
        }, 0);
      }
      // 如果当前状态为等待态，则将其加入事务
      if (this.state === this.enumStatus.PADDING) {
        this.onFulfilledQueue.push(() => {
          resolvePromise(promise2, onFulfilled(this.value), resolve, reject);
        });
        this.onRejectedQueue.push(()=> {
          resolvePromise(promise2, onRejected(this.reason), resolve, reject);
        });
      }
    });
    return promise2;
  }
}

function resolvePromise(promise2, x, resolve, reject) {
  // 防止循环调用
  if (promise2 === x) {
    reject(Throw('不允许循环调用'));
  }
  if (x != null && (typeof x === 'object' || typeof x === 'function')) {
    //函数或对象
    let then = x.then;
    if (typeof then === 'function') {
      // 如果函数运行后的返回值仍然是一个promise，则递归调用resolvePromise
      then.call(x, res => resolvePromise(promise2, res, resolve, reject), err => reject(err));
    }else {
      resolve(x);
    }
  } else {
    //普通值
    resolve(x)
  }
}

// 调用
var p1 = new NewPromise((resolve, reject) => {
  setTimeout(() => {
    resolve('前端橘子君');
  }, 1000);
});

var p2 = new NewPromise((resolve, reject) => {
  setTimeout(() => {
    resolve('我是链式调用的结果')
  }, 3000);
})

p1.then((data) => {
  console.log(data);
  return p2;
}).then(data => {
  console.log(data);
});
```

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)