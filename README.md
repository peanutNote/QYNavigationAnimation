## QYNavigationAnimation
* The navigation bar to push the animation
* 导航栏推送动画


## 使用方法
* 将QYNavigationAnimation文件导入项目中，使用QYNavigationAnimation创建导航栏控制器
* 为QYNavigationAnimation的导航栏对象设置QYNavigationAnimationModel属性，该属性为一个枚举类型:

```objc
typedef NS_ENUM(NSInteger, QYNavigationAnimationModel) {
    // 往上push
    QYNavigationUpPush,
    // 往左push
    QYNavigationLeftPush,
    // 往右push
    QYNavigationRightPush,
    // 往下push
    QYNavigationDownPush,
    // 往左上push
    QYNavigationLeftUpPush,
    // 往左下push
    QYNavigationLeftDownPush,
    // 往右上push
    QYNavigationRightUpPush,
    // 往右下push
    QYNavigationRightDownPush
};
```
* 效果如下：

![image](https://github.com/peanutNote/QYNavigationAnimation/blob/master/QYNavigationAnimation/demo.gif)