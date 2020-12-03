### 文件命名
- 统一使用小写的英文字母、数字和下划线的组合
- 不得包含汉字、空格和特殊字符
- 如果是组件，可以使用中划线将多个字母进行组合

```HTML
index.html
logo_lp.png
```

### HTML类型
- 规定字符编码
- IE 兼容模式
- doctype 大写
- 指定lang属性

```HTML
<!DOCTYPE html>
<html lang="en-us">
  <head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta charset="UTF-8" />
    <title>HTML类型</title>
  </head>
  <body>
    <img src="images/company-logo.png" alt="Company" />
  </body>
</html>
```

### 缩进
- 两个空格代替一个tab制表符
- 禁用tab制表符
- 嵌套的节点应该缩进

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta charset="UTF-8" />
    <title>HTML类型</title>
  </head>
  <body>
    <img src="images/company-logo.png" alt="Company" />
  </body>
</html>
```

### 分块注释
- 块级元素
- 列表元素
- 表格元素

```HTML
<!DOCTYPE html>
<html>
  <head>
    <meta http-equiv="X-UA-Compatible" content="IE=Edge" />
    <meta charset="UTF-8" />
    <title>HTML类型</title>
  </head>
  <body>
    <!-- list start -->
    <ul>
      <li>列表元素</li>
      <li>列表元素</li>
      <li>列表元素</li>
    </ul>
    <!-- list end -->
  </body>
</html>
```

### 引号
- 元素属性需要使用双引号

```HTML
<div class="demo" id="demo" name="demo" data-id="198"></div>
```

### 省略type属性
- style
- link
- script

```HTML
<link rel="stylesheet" href="element.min.js"></link>
<script src="jquery.min.js"></script>
```

### 属性顺序
- class
- id, name
- data-*
- src, for, type, href
- title, alt
- aria-*, role

```HTML
<div class="demo" id="demo" name="demo" data-id="198"></div>
```

### 标签闭合
- 所有元素必须闭合
- 自闭合标签需要用"/>"进行闭合

```HTML
<div class="demo"></div>
<hr />
```
### 元素名小写
- 所有元素使用小写字母
- 不允许使用大写字母

```HTML
<!-- 错误写法 -->
<DIV class="demo"></DIV>

<!-- 正确写法 -->
<div class="demo"></div>
```

### 属性名小写
- 所有属性使用小写字母
- 不允许使用大写字母

```HTML
<!-- 错误写法 -->
<div CLASS="demo"></div>

<!-- 正确写法 -->
<div class="demo"></div>
```

### 布尔型属性
- 布尔型属性不强制要求赋值

```HTML
<input type="text" disabled />

<select>
  <option value="1" selected>1</option>
</select>
```

### 组件名规范
- 多个单词使用KebabCase格式
- 组件文件名使用pascal-case格式
- 基础文件名必须以base开头
- 与父组件紧密结合的子组件必须以父组件名为前缀
- 在template模板中使用组件，应使用pascal-case格式，必须闭合组件，不允许使用自闭合标签

```javascript
// 多个单词使用KebabCase格式
export default {
  name: 'Todo'
};
// 组件名称使用pascal-case格式
base-header.vue
// 基础文件名必须以base开头
base-botton.vue
// 与父组件紧密结合的子组件必须以父组件名为前缀
todo-item.vue
<!-- 在template模板中使用组件，应使用pascal-case格式，必须闭合组件，不允许使用自闭合标签 -->
<base-botton></base-botton>
```

### 常用命名规范(非强制)
- header: 页头
- nav：导航
- footer: 页脚
- column：栏目
- sidebar：侧栏
- left:左侧
- wrapper或wrap：页面外围控制整体布局宽度
- center:中间
- right:右侧
- logo：标志
- loginbar：登陆条
- main:页面主体
- banner：广告
- news：新闻
- hot：热点
- subnav：子导航
- download：下载
- submenu：子菜单
- menu：菜单
- friendlink：友情链接
- search：搜索
- scroll：滚动
- copyright:版权　
- tab:标签页
- content/container：内容
- msg:提示信息
- list: 文章列表
- joinus：加入
- title：栏目标题
- service:服务
- guide：指南
- status：状态
- register:注册
- partner：合作伙伴
- vote：投票
