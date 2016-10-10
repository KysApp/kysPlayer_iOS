# bigPicScrollView
======================================
bigPicScrollView是可循环滚动的简单封装，用来展示活动海报等。
## 准备
* kysScrollPic文件夹拖入工程
* 由于分装中使用了sdwebimage用来下载图片所以需要在你的pod中添加sdwebimagez或者手动添加

## 初始化
```
kysScrollPicView *view = [[kysScrollPicView alloc] initWithFrame:CGRectMake(x,y, width, height)];
```
## 设置自动滚动间隔(默认或者传入1S以下的均为5)
```
[view setAutoScrollTime:5];
```
## 设置pagecontrol点的颜色
```
[view setCurrentPageIndicatorColor:[UIColor greenColor] otherPageIndicator:[UIColor grayColor]];
```
## 设置点的对其方式
目前只支持3种方式
```
//pagecontrol在中间 无文字
kysAlignmentCenter = 0,
//pagecontrol在左 文字在右
kysAlignmentLeft,
//pagecontrol在右 文字在左
kysAlignmentRight
```
设置
```
[view setPageControllerAlignment:kysAlignmentLeft]
```
## 设置数据标题和图片地址
```
(void)setDatasWithTitleArray:(NSArray *)titleArray imageArray:(NSArray *)imageArray
```
## 代理
设置代理
```
[view2 setDelegate:yourVCorView];
```
点击时返回所在数据index
```
(void)clickPicWithindex:(NSInteger)index
```
    
