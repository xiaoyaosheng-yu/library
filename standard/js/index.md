# javascript规范

### 文件命名
- 统一使用小写的英文字母、数字和下划线的组合
- 不得包含汉字、空格和特殊字符

### 命名规则
- 使用camelCase格式命名变量
- 全局变量为大写
- 常量 (如 PI) 为大写

```javascript
let firstName = "张三";
const PI = 3.14;
```

### 空格与运算符
- 运算符前后需要添加空格

```javascript
let num1 = 10;
let num2 = 20;
let count = num1 + num2;
```

### 缩进
- 两个空格代替一个tab制表符
- 禁用tab制表符
- 嵌套的节点应该缩进

```javascript
let count = 0;
for (let i = 0; i < 10; i++) {
  count += i;
}
```

### 分号结束符
- 一条语句以分号作为结束符
- if, for, 函数可以不以分号结束

```javascript
let count = 0;
for (let i = 0; i < 10; i++) {
  count += i;
}
```

### 通用规则
- 将左花括号放在第一行的结尾
- 左花括号前添加一空格
- 将右花括号独立放在一行
- 不要以分号结束一个复杂的声明，如if, for, 函数

```javascript
function count (prev, next) {
  return prev + next;
}
```

### 对象规则
- 将左花括号与类名放在同一行
- 冒号与属性值间有个空格
- 字符串使用双引号，数字不需要
- 最后一个属性-值对后面不要添加逗号
- 将右花括号独立放在一行，并以分号作为结束符号

```javascript
var person = {
  firstName: "John",
  lastName: "Doe",
  age: 50,
  eyeColor: "blue"
};
```

### 每行代码字符小于 80
- 为了便于阅读每行字符建议小于数 80 个
- 超过了 80 个字符，建议在运算符或者逗号后换行

```javascript
document.getElementById("demo").innerHTML = 
"Hello Runoob.";
```