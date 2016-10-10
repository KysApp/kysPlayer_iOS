//
//  avplayerControlView.h
//  MaiXiLP
//
//  Created by kys on 15/12/17.
//  Copyright © 2015年 KYS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "PageViewCollectionViewCell.h"
#import "livePageCollectionViewCell.h"
#import "UIView+UserData.h"

typedef NS_ENUM(NSInteger, controlViewState) {
    //小屏播放
    controlViewStateSmall,
    //大屏未锁定
    controlViewStateFullScreenUnlock,
    //大屏锁定
    controlViewStateFullScreenlock,
};
typedef NS_ENUM(NSInteger, displayOrientation) {
    //竖屏
    displayOrientationPortrait,//默认从0开始
    //左横
    displayOrientationLandscapeLeft,
    //右横
    displayOrientationLandscapeRight,
};
typedef NS_ENUM(NSInteger, videoTypeState) {
    //直播
    videoTypeStateLive,//默认从0开始
    //直播回看
    videoTypeStateLivePlayBack,
    //点播
    videoTypeStateVODPlay,
};
@protocol avplayerControlViewDelegate<NSObject>
@optional
//全屏按钮操作
-(void)GetProgressCHange:(float)Progress;//改变进度；
-(void)GetLightChange:(float)Light;
-(void)backBtnAction;
- (void)changeViewItem:(NSInteger)index with:(NSInteger)definition;
- (void)showDLNA;
- (void)changePlayerStaute:(BOOL)play;
- (void)needloadTime;
//添加／取消收藏
- (void)changewhetherfavourite:(BOOL)isfavorited;
@end
@interface avplayerControlView : UIView<UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UITableViewDelegate,UITableViewDataSource>
{
#pragma mark 顶部控件
    //顶部底视图
    UIView *_titleView;
    //底部视图
    UIView *_bottomView;
    //顶部时间
    UILabel *_timeLabel;
    //顶部标题
    UILabel *_titleLabel;
    //顶部返回按钮
    UIButton *_backBtn;
#pragma mark 底部控件
    //播放、暂停按钮
    UIButton *_playBtn;
    //播放进度条
    UISlider *_playTimeSlider;
    //播放时间和总长度
    UILabel *_playerTimeLabel;
    //清晰度选择按钮
    UIButton *_playStyleBtn;
    //直播台。点播集数选择按钮
    UIButton *_choicePageBtn;
    //全屏按钮
    UIButton *_fullScreenBtn;
    //airplay
    MPVolumeView *_airplayView;
    //收藏按钮
    UIButton *_favBtn;
#pragma mark 独立控件
    //菊花图
    UIActivityIndicatorView *_waitView;
    //锁屏按钮
    UIButton *_lockBtn;
    //清晰度选择框
    UITableView *_definitionChoiceView;
    //集数选择框
    UICollectionView *_pageChoiceView;
    UIView *_breakPointShowView;
    //airplay提示
    UILabel *_airplayLab;
    //提示
    UIView *_tipView;
    //界面隐藏时间
    NSTimer *_timer;
#pragma mark 手势控制
    CGPoint _beginPoint;
    CGFloat _beginVoice;
    CGFloat _beginBrightness;
    float _beginprocess;
    UISlider *_MPPC;
    NSString *_type;
    BOOL _sliderIsDrag;
    NSTimeInterval _breakPoint;
    //清晰度名称List
    NSArray *_definitionNameList;
    CGSize _screenSize;
}
//avplayerControlViewDelegate 代理
@property (nonatomic,weak) id<avplayerControlViewDelegate>delegate;
//当前UI类型
@property (nonatomic) controlViewState controlState;
//当前播放类型
@property (nonatomic) videoTypeState videoType;
//缓冲图
@property (nonatomic) UIActivityIndicatorView *waitView;
//清晰度
@property (nonatomic) NSInteger definition;
//当前播放的集数
@property (nonatomic) NSInteger currentPageNum;
//选台/选集按钮名字
@property (nonatomic) NSArray *choicePageNameList;

#pragma -mark 方法
/**
 *  初始化 必须调用
 *
 *  @param videType    播放类型
 *  @param programName 暂不使用
 *  @param fullScreen  暂不使用
 *
 *  @return
 */
- (id)initWithVideType:(videoTypeState)videType ProgramName:(NSString *)programName FullScreen:(BOOL)fullScreen;
/**
 *  设置播放类型
 *
 *  @param type 播放类型
 */
- (void)setvideType:(videoTypeState)type;
/**
 *  刷新控制层
 */
- (void)refreshPlayerControllerView;
/**
 *  刷新进度条时间
 *
 *  @param currentTime 当前时间
 *  @param durrentime  总共时间
 */
- (void)SynCurrentTime:(NSString *)currentTime DurrentTime:(NSString *)durrentime;
/**
 *  更新名称
 *
 *  @param title 名字
 */
- (void)updateTitle:(NSString *)title;
/**
 *  推出时移除监听
 */
- (void)removeairplay;
/**
 *  查看是否需要刷新时间
 *
 *  @return
 */
- (BOOL)bottomHidden;
/**
 *  更新播放按钮状态
 *
 *  @param play
 */
- (void)setPlayBtnState:(BOOL)play;
/**
 *  视频加载成功时调用
 *
 *  @param duration
 */
- (void)changeTheDuration:(float)duration;
/**
 *  更新收藏按钮状态
 *
 *  @param isfav
 */
- (void)changeFavBtnWithFav:(BOOL)isfav;
/**
 *  更新书签时间
 *
 *  @param breakPoint
 */
- (void)setbreakPoint:(NSTimeInterval)breakPoint;

@end
