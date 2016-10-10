//
//  IJKPlayerView.h
//  CMCCHuaWei
//
//  Created by kys on 16/5/20.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <IJKMediaFramework/IJKMediaFramework.h>
//播放器控制层
#import "avplayerControlView.h"
@protocol IJKPlayViewDelegate<NSObject>
@optional
//小屏幕时返回按钮回调
- (void)backBtnAction;
//切换集数 台标 清晰度
- (void)changeViewItem:(NSInteger)index with:(NSInteger)definition;
//DLNA图标回调
- (void)showDLNA;
//收藏/取消收藏
- (void)dofavourite:(BOOL)favorited;
@end
@interface IJKPlayerView : UIView<avplayerControlViewDelegate>{
    avplayerControlView * _controlView;
    NSArray *_DLNAList;
    BOOL _isPlaying;
}
//播放器
@property(atomic, retain)  IJKFFMoviePlayerController<IJKMediaPlayback>* _Nullable  player;
//代理
@property(nonatomic,weak) _Nullable id<IJKPlayViewDelegate>delegate;
//切换清晰度时的继续播放seek
@property(nonatomic) float changedefinitionRePlay;
//初始化类型
- (instancetype)initWithStyle:(videoTypeState )type;
//切换播放
- (void)playerChangeWithURL:( NSURL * _Nullable )url;
//设置title
- (void)updateTitle:( NSString * _Nonnull )str;
//设置控制层状态
- (void)setControlState:(controlViewState)statue;
//获取控制层状态
- (controlViewState)getControlState;
//设置选集 学台的名称
- (void)setpageViewcontent:(NSArray *)array;
//当前集数
- (void)setCurrentIndex:(NSInteger)index;
//设置收藏状态
- (void)setfavBtn:(BOOL)isfav;
//显示书签 播放历史
- (void)showBreakPoint:(NSString *)breakPoint;
//获取清醒度
- (NSUInteger)getdefinition;
//
- (NSUInteger)indexOfbreakPoint:(NSString *)page;
/**
 *  更新书签时间
 *
 *  @param breakPoint
 */
- (void)setdefinition:(NSInteger)definition;
@end
