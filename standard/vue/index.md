### 文件命名
- 统一使用小写的英文字母、数字和下划线的组合
- 不得包含汉字、空格和特殊字符

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
// 在template模板中使用组件，应使用pascal-case格式，必须闭合组件，不允许使用自闭合标签
<base-botton></base-botton>
```

### data 必须是一个函数
- 组件的data必须是一个函数

```javascript
data () {
  return {
    message: 'hello world'
  };
}
```

### props定义应该尽量详细
- 使用cameCase驼峰命名
- 必须指定类型
- 必须加上注释，表明其含义
- 必须加上require或default，二选其一
- 如果有业务需要，必须加上validator验证

```javascript
export default {
  props: {
    status: {
      type: String,
      required: true,
      validator: () => {
        return {
          'success',
          'info',
          'error'
        };
      }.indexOf(value) != -1
    }
  }
};
```

### 为组件样式设置作用域
- 为防止样式影响到全局或其他样式，需要设置scope作用域

```HTML
<style scoped>
  .brtn-close {
    font-size: 16px;
  }
</style>
```

### 组件属性过多应该换行
- 如果特性属性过多，应该主动换行

```HTML
<base-header fontSize="16" color="#ffrr00"
  lineHeight="20"></base-header>
```

### 模板中使用简单表达式
- 如果模板中有复杂的表达式，应该使用计算属性

```HTML
<div>{{ normalizeFullName }}</div>
```
```javascript
export default {
  computed: {
    normalizeFullName: () => {
      return this.fullName.split(' ').map((word) => word[0].toUpperCase() + word.slice(1)).join(' ');
    }
  }
};
```

### 指令使用缩写形式
- 为保证代码的简洁性和一致性，vue指令应该使用缩写
- 用 : 表示 v-bind:
- 用 @ 表示 v-on:
- 用 # 标识 v-slot:
- 要么都用缩写，要么都不用

### 标签顺序的一致性
- 文件应该保持 template -> script -> style 的书写顺序

```HTML
<template></template>

<script></script>

<style></style>
```

### script标签内部结构顺序
- components
- props
- data
- computed
- watch
- filter
- 钩子函数
- methods

```javascript
export default {
  components: {},
  props: {},
  data: () => {},
  computed: {},
  watch: {},
  filter: {},
  beforeRouterEnter: () => {},
  methods: {}
};
```