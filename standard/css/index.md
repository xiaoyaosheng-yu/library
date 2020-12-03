### 文件命名
- 统一使用小写的英文字母、数字和下划线的组合
- 不得包含汉字、空格和特殊字符

```HTML
index.css
base_botton.css
```

### class命名
- class名称应该使用小写字母，数字和中划线的组合
- 应该避免过度小写，如.s
- 基于最近的父class应以父级class名称作为前缀

```CSS
.header-item {
  background-color: #fff;
}
```

### 缩进
- 两个空格代替一个tab制表符
- 禁用tab制表符
- 嵌套的节点应该缩进

```CSS
.header {
  background-color: #fff;
}
```

### 选择器独行
- 为选择器分组时，将单独的选择器单独放在一行

```CSS
.selector,
.selector-secondary,
.selector[type="text"] {
  background-color: #fff;
}
```

### 空格和换行
- 每个声明块的左花括号前添加一个空格
- 声明块的右花括号应当单独成行
- 每条声明语句之后应该插入一个空格
- 以逗号分隔的属性值，每个逗号后面都应该插入一个空格
- 属性值前应该插入一个空格

```CSS
.header {
  border: 1px solid #fff;
  font-size: 14px;
  color: rgba(255, 255, 255, .5);
}

.footer {
  font-size: 16px;
}
```

### 分号结尾
- 所有声明语句都应当以分号结尾

```CSS
.header {
  font-size: 14px;
  background-color: #fff;
}
```

### 16进制值应该小写
- 所有16进制的值应该全部小写

```CSS
.header {
  border: 1px solid #fff;
  font-size: 14px;
  color: #ff4400;
}
```

### 省略小数的0
- 对于属性值或颜色参数，省略小于 1 的小数前面的 0 

```CSS
.header {
  border: .5px solid #999;
}
```

### 0值省略单位
- 避免为 0 值指定单位

```CSS
.header {
  border: 0;
}
```

### 16进制简写
- 尽量使用简写形式的十六进制值

```CSS
.header {
  border: 1px solid #fff;
}
```

### 声明属性分组及顺序
- 相关的属性声明应当归为一组
- Positioning
- Box model
- Typographic
- Visual

```CSS
.header {
  /* Positioning */
  position: absolute;
  left: 0;
  top: 0;
  z-index: 100;

  /* Box model */
  display: block;
  float: right;
  width: 100px;
  height: 100px;

  /* Typographic */
  font-size: 16px;
  line-height: 50px;
  text-align: center;
  color: #333;

  /* Visual */
  opacity: 1;
}
```

### 不要使用@import
- @import较慢，还会额外增加请求次数，导致不可预期的问题
- 使用<link>代替
- 通过sass或less类似的css预处理器将多个css文件编译为一个文件

### 媒体查询的位置
- 应该放在相关规则附近
- 不要放在一个单独文件中
- 不要单独放在底部

```CSS
.header {
  font-size: 14px;
}
@media (min-width: 480px) {
  .header {
    font-size: 16px;
  }
}
```