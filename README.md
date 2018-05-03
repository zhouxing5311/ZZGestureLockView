# 简单易用的手势密码

## ZZGestureLockView部分特点
* 通过`drawRect`结合`UIPanGestureRecognizer`实现的手势密码。
* 每一个item使用自定义的`UIImageView`，也可以自定义view，并给出三种对应的状态即可。
* 可以自己制定连接颜色、宽度、密码最少个数、以及item的normal状态图片、selected状态图片以及warning状态图片。
* 通过代理回调最终的手势结果。




## 使用方法: 


```
//add lockview

_lockView = [[ZZGestureLockView alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-245)/2.0, 150, 245, 245)];
_lockView.itemWidth = 60;//item宽度
_lockView.miniPasswordLength = 4;//密码最短位数
_lockView.normalLineColor = [UIColor colorWithRed:252/255.0 green:222/255.0 blue:117/255.0 alpha:1];//线条正常色
_lockView.warningLineColor = [UIColor colorWithRed:249/255.0 green:78/255.0 blue:92/255.0 alpha:1];//线条警告色
_lockView.delegate = self;
[self.view addSubview:_lockView];



#pragma ZZGestureLockViewDelegate
- (void)zzGestureLockViewDidStartWithLockView:(ZZGestureLockView *)lockView {
   NSLog(@"begin-----");
}

- (void)zzGestureLockViewDidEndWithLockView:(ZZGestureLockView *)lockView itemState:(ZZGestureLockItemState)itemState gestureResult:(NSString *)gestureResult {

   NSLog(@"end----");

   if (itemState == ZZGestureLockItemStateNormal) {
      NSLog(@"password----%@",gestureResult);
   } else {
      NSLog(@"请至少连接4个点");
   }
}

```

### 效果展示:

![image](https://github.com/zhouxing5311/ZZGestureLockView/blob/master/ZZGestureLockView.gif) 


