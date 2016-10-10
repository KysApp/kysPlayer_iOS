# kysPlayer
======================================
kysPlayer目前基于IJK的封装，增加控制层方便使用
## 准备
* kysPlayer文件夹拖入工程
* 需要链接下列库文件
    *VideoToolbox.framework
    *QuartzCore.framework
    *OpenGLES.framework
    *MobileCoreServices.freamwork
    *MediaPlayer.framework
    *AudioToolbox.framework
    *libz.tbd
    *libbz2.tbd
* 由于肯定会使用到转屏的相关功能 所以提供了kysNavigationController,kysTabBarController,kysRootViewController的简单封装，达到页面控制是否旋转的目的，默认为只支持Portrait方向。

## 初始化
```
_playerView = [[IJKPlayerView alloc] initWithStyle:videoTypeStateVODPlay];
```
## 设置播放地址
```
[_playerView playerChangeWithURL:[NSURL URLWithString:url]];
```
## 设置上边栏显示名称
```
[_playerView updateTitle:@"测试视频"];
```
## 设置控制层的状态
支持的类型
```
typedef NS_ENUM(NSInteger, controlViewState) {
    //小屏播放
    controlViewStateSmall,
    //大屏未锁定
    controlViewStateFullScreenUnlock,
    //大屏锁定
    controlViewStateFullScreenlock,
};
```
使用
```
[_playerView setControlState:controlViewStateSmall];
```
ps:只有处理屏幕旋转时才使用，其它时候使用会产生错乱
## 设置选集 学台的名称
传入字符串数组 当作名称显示在选择按钮上
```
[_playerView setpageViewcontent:@[@"1",@"2"]];
```
## 设置当前播出的集数和台
一般只在换台的回调中使用
```
[_playerView setCurrentIndex:index];
```

## 代理
设置代理
```
[_playerView setDelegate:yourVCorView];
```
点击返回按钮(小屏幕时用来回到上一级视图控制器，大屏时不会回调)
```
- (void)backBtnAction;
```
控制页面上切换剧集与直播台的回调
切换剧集与直播台时的处理网络请求等等 页面上各种需要切换播放地址的也可以主动调用。
```
- (void)changeViewItem:(NSInteger)index with:(NSInteger)definition;
```
## 必须要注意的地方
#### 转屏
##### 播放器所在的视图控制器需要重写
```
//判断是否旋转，播放器锁屏状态时返回否
- (BOOL)shouldAutorotate{
    if ([_playerView getControlState] == controlViewStateFullScreenlock) {
        return NO;
    }else{
        return YES;
    }
}
//旋转支持方向
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
```
##### 需要注册观察通知
```
[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
```
orientChange()方法中要对页面UI进行处理 具体参见demo
#### 释放
返回时需要释放资源
```
//停止播放器继续加载 释放播放数据缓存
[_playerView playerChangeWithURL:nil];
//移除播放器
[_playerView removeFromSuperview];
//移除通知
[[NSNotificationCenter defaultCenter] removeObserver:self];
```
