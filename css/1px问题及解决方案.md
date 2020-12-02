# 1px问题及解决方案

> 本文档已更新于 [【前端橘子君】](http://xiaoysosheng.top/#/css/1px问题及解决方案) [【Github】](https://github.com/xiaoyaosheng-yu/library/blob/master/css/1px问题及解决方案.md)

在项目开发过程中，设计师经常会说，这里边框像素边框不对，要求1像素但是实际是2像素，当我们去查代码时我们写的就是`1px`，这是前端开发者经常遇到的一个问题，也就是`1px像素问题`。

要了解并解决问题，我们首先需要了解其原理才能从根本上找到解决方案。

首先我们需要对`物理像素`，`逻辑像素`和`设备像素比`有一个概念。

### 物理像素(DP)

物理像素又称**设备像素**，是组成显示屏的基本单位，每一台设备的物理像素在出厂时就已经固定好了，不会改变，我们平时看到的图片是通过每个像素不同颜色组合而成的。

设计师一般要求的像素就是物理像素。

### 逻辑像素(DIP)
逻辑像素又称为**设备独立像素**或**CSS像素**，是组成图像的基本单位，它是一个抽象概念，我们可以笼统的认为屏幕可视区域的宽度就是逻辑像素的大小。在1倍屏下，1倍逻辑像素=1倍物理像素；2倍屏下，1倍逻辑像素=2倍物理像素。逻辑像素是可变的，例如当我们放大页面的尺寸比例时，逻辑像素也就随之扩大。

前端开发者在CSS中设置的像素就是逻辑像素。

### 设备像素比(DPR)

设备像素比描述的是物理像素和逻辑像素之间的比例关系。

`设备像素比 = 物理像素 / 逻辑像素`。

怎么获取DPR？

`window.devicePixelRatio`或`@media screen and (-webkit-min-device-pixel-ratio: 2) {}`

### PPI

PPI指的是设备每英寸的物理像素点，说的简单点就是一英寸的屏幕中由多少个物理像素组合而成。

我们买手机的时候规格上会写上：
```
尺寸：5.5英寸
分辨率：1920 * 1080 像素
```
这里的`1920 * 1080`指的是物理像素，就是可视区域内总物理像素的数量，1920代表是长边所占像素大小，1080表示短边所占像素大小。

怎么计算PPI？
```javascript
斜边像素大小^2 = 长边像素大小^2 + 短边像素大小^2  (其中^2代表平方)
PPI = 斜边像素大小 / 设备尺寸

// 以上述手机的尺寸来举例
斜边像素大小^2 = 1920^2 + 1080^2;
PPI = 斜边像素大小 / 5.5英寸
```

PPI越高，图像越清晰。

回归正题，既然我们已经知道了这些概念了，那么就不难理解开篇中设计师和前端开发者之间的问题了，就是因为两者的单位是不同的。

下面就是解决方案。

### CSS媒体查询方案

我们知道了如何获取`设备像素比DPR`，那么我们就从这两点进行解决。

```css
.div {
  border-width: 1px;
}
/* 两倍像素下 */
@media screen and (-webkit-min-device-pixel-ratio: 2) {
  .div {
    border-width: 0.5px;
  }
}
/* 三倍像素下 */
@media screen and (-webkit-min-device-pixel-ratio: 3) {
  .div {
    border-width: 0.333333px;
  }
}
```

**缺点**：
- 代码量多
- 低版本IE不兼容

### viewport + rem

```javascript
var viewport = document.querySelector("meta[name=viewport]");
var ppi = 1;
if (window.devicePixelRatio == 2) ppi = 2;
if (window.devicePixelRatio == 3) ppi = 3;

viewport.setAttribute('content', `width=device-width,initial-scale=${1/ppi}, maximum-scale=${1/ppi}, minimum-scale=${1/ppi}, user-scalable=no`);

// 设置根字体大小
var docEl = document.documentElement; 
var fontsize = 10 * (docEl.clientWidth / 320) + 'px'; 
docEl.style.fontSize = fontsize;

// 在CSS中用rem单位就行了
```
为什么使用`320`作为基准?因为所有非视网膜屏幕的iphone在垂直的时候，宽度为320物理像素。

**缺点:**
- 由于JS对文档进行修改，所以性能上有一定影响
- 会对项目中所有使用`rem`单位的对象进行影响。不适合老项目改造。

### transform

```css
.div {
  width: 200%;
  transform: scale(0.5);
  transform-origin: top left;
}
```

**缺点**
- 对于已经使用的伪类(如：clearfix)，可能需要多层嵌套

### box-shadow模拟边框
```css
.div {
  box-shadow: inset 0px -1px 1px -1px #c8c7cc;
}
```
**缺点**
- 会有颜色渐变

-------

更多相关文档，请见：

线上地址 [【前端橘子君】](http://xiaoysosheng.top)

GitHub仓库[【前端橘子君】](https://github.com/xiaoyaosheng-yu/library)