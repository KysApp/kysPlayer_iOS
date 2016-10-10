//
//  IJKPlayerView.m
//  CMCCHuaWei
//
//  Created by kys on 16/5/20.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import "IJKPlayerView.h"

@implementation IJKPlayerView
# pragma mark - avplayerControlViewDelegate
-(void)GetProgressCHange:(float)Progress{
    if (_player.duration>0&&_player.loadState!=IJKMPMovieLoadStateUnknown) {
        [_player setCurrentPlaybackTime:Progress];
    }
}
-(void)backBtnAction{
    if (_delegate&&[_delegate respondsToSelector:@selector(backBtnAction)]) {
        [_delegate backBtnAction];
    }
}
//换台相关
- (void)changeViewItem:(NSInteger)index with:(NSInteger)definition{
    if (index == [_controlView currentPageNum]) {
        if ([_player currentPlaybackTime]>0 ) {
            _changedefinitionRePlay = [_player currentPlaybackTime];
        }
    }
    if (_delegate&&[_delegate respondsToSelector:@selector(changeViewItem:with:)]) {
        [_delegate changeViewItem:index with:definition];
    }
}
-(void)showDLNA{
    if (_delegate&&[_delegate respondsToSelector:@selector(showDLNA)]) {
        [_delegate showDLNA];
    }
}
-(void)changePlayerStaute:(BOOL)play{
    if (!_player) {
        return;
    }
    if (play) {
        [_player pause];
        _isPlaying = NO;
    }else{
        [_player play];
        _isPlaying = YES;
    }
}
-(void)needloadTime{
    NSTimeInterval duration = _player.duration;
    NSTimeInterval position = _player.currentPlaybackTime;
    if (duration) {
        [_controlView setPlayBtnState:_player.isPlaying];
        [_controlView SynCurrentTime:[NSString stringWithFormat:@"%f",position] DurrentTime:[NSString stringWithFormat:@"%f",duration]];
        [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(needloadTime) object:nil];
        if (![_controlView bottomHidden]) {
            [self performSelector:@selector(needloadTime) withObject:nil afterDelay:0.5];
        }
    }
}
- (instancetype)initWithStyle:(videoTypeState)type{
    self = [super init];
    if (self) {
        _isPlaying = NO;
#ifdef DEBUG
        [IJKFFMoviePlayerController setLogReport:YES];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_DEBUG];
#else
        [IJKFFMoviePlayerController setLogReport:NO];
        [IJKFFMoviePlayerController setLogLevel:k_IJK_LOG_INFO];
#endif
        [IJKFFMoviePlayerController checkIfFFmpegVersionMatch:YES];
        _controlView =[[avplayerControlView alloc]initWithVideType:type ProgramName:@"" FullScreen:NO];
        _controlView.translatesAutoresizingMaskIntoConstraints = NO;
        _controlView.delegate = self;
        [self addSubview:_controlView];
        NSArray *controlViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_controlView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_controlView)];
        NSArray *controlViewv = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_controlView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_controlView)];
        [self addConstraints:controlViewH];
        [self addConstraints:controlViewv];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect {
 // Drawing code
 }
 */
- (void)playerChangeWithURL:( NSURL * _Nullable )url{
    if (_player) {
        [self removePlayer];
        _isPlaying = NO;
    }
    if (url) {
        [_controlView.waitView startAnimating];
        [self addPlayer:url];
        [_player prepareToPlay];
        _isPlaying = YES;
    }
}

- (void)addPlayer:(NSURL *)url{
    IJKFFOptions *options = [IJKFFOptions optionsByDefault];
    [options setPlayerOptionIntValue:1 forKey:@"videotoolbox"];
    self.player = [[IJKFFMoviePlayerController alloc] initWithContentURL:url withOptions:options];
    _player.scalingMode = IJKMPMovieScalingModeFill;
    [_player setPauseInBackground:YES];
    _player.view.translatesAutoresizingMaskIntoConstraints = NO;
    _player.shouldAutoplay = YES;
    self.autoresizesSubviews = YES;
    [self insertSubview:_player.view belowSubview:_controlView];
    NSArray *playerViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[view]|" options:0 metrics:nil views:[NSDictionary dictionaryWithObject:_player.view forKey:@"view"]];
    NSArray *playerViewv = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[view]|" options:0 metrics:nil views:[NSDictionary dictionaryWithObject:_player.view forKey:@"view"]];
    [self addConstraints:playerViewH];
    [self addConstraints:playerViewv];
    [self installMovieNotificationObservers];
}

- (void)removePlayer{
    [self removeMovieNotificationObservers];
    [_player shutdown];
    [_player.view removeFromSuperview];
    _player = nil;
}
//控制层代理
#pragma _mark 播放控件代理
-(void)playorpause:(NSNotification *)notification
{
    NSDictionary *playorpausedic = [notification userInfo];
    int a=[[playorpausedic objectForKey:@"playorpause"] boolValue];
    if( a==YES ){
        //        [_player changeStatuePlay:NO];
    }else{
        //        [_player changeStatuePlay:YES];
    }
    
}

- (void)setCurrentIndex:(NSInteger)index{
    [[_controlView waitView] startAnimating];
    [_controlView setCurrentPageNum:index];
}
- (void)setControlState:(controlViewState)statue{
    [_controlView setControlState:statue];
    [_controlView refreshPlayerControllerView];
}
- (controlViewState)getControlState{
    return _controlView.controlState;
}
- (void)setpageViewcontent:(NSArray *)array{
    [_controlView setChoicePageNameList:array];
}
- (void)updateTitle:( NSString * _Nonnull )str{
    if (str) {
        [_controlView updateTitle:str];
    }
}
- (void)changewhetherfavourite:(BOOL)isfavorited{
    if (_delegate&&[_delegate respondsToSelector:@selector(dofavourite:)]) {
        [_delegate dofavourite:isfavorited];
    }
}

#pragma mark Install Movie Notifications

/* Register observers for the various movie object notifications. */
-(void)installMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(loadStateDidChange:)
                                                 name:IJKMPMoviePlayerLoadStateDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackDidFinish:)
                                                 name:IJKMPMoviePlayerPlaybackDidFinishNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(mediaIsPreparedToPlayDidChange:)
                                                 name:IJKMPMediaPlaybackIsPreparedToPlayDidChangeNotification
                                               object:_player];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(moviePlayBackStateDidChange:)
                                                 name:IJKMPMoviePlayerPlaybackStateDidChangeNotification
                                               object:_player];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(resumePlay) name:UIApplicationDidBecomeActiveNotification object:nil];
}

- (void)loadStateDidChange:(NSNotification*)notification{
    if (_player.loadState == IJKMPMovieLoadStateStalled) {
        [[_controlView waitView] startAnimating];
    }else if (_player.loadState == (IJKMPMovieLoadStatePlayable|IJKMPMovieLoadStatePlaythroughOK)){
        [[_controlView waitView] stopAnimating];
        if (_player.duration>0) {
            [_controlView setvideType:videoTypeStateVODPlay];
            [self needloadTime];
            if (_changedefinitionRePlay>0.0) {
                [self GetProgressCHange:(_changedefinitionRePlay*100)/100];
                [_controlView setbreakPoint:0];
                _changedefinitionRePlay = 0.0;
            }
        }else{
            [_controlView setvideType:videoTypeStateLive];
        }
    }
}
- (void)moviePlayBackDidFinish:(NSNotification*)notification{
}
- (void)mediaIsPreparedToPlayDidChange:(NSNotification*)notification{
    
}
- (void)moviePlayBackStateDidChange:(NSNotification*)notification{
    if (_player.loadState == IJKMPMovieLoadStateUnknown&&!_player.isPreparedToPlay) {
        UIAlertView *alertview = [[UIAlertView alloc] initWithTitle:nil message:@"视频无法解析" delegate:nil cancelButtonTitle:@"好的" otherButtonTitles:nil];
        [alertview show];
    }else if(_player.duration>0){
        [_controlView changeTheDuration:_player.duration];
    }
}
#pragma mark Remove Movie Notification Handlers

/* Remove the movie notification observers from the movie object. */
-(void)removeMovieNotificationObservers
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
-(void)resumePlay{
    if (_isPlaying&&_player) {
        [_player play];
    }
}
- (void)setfavBtn:(BOOL)isfav{
    [_controlView changeFavBtnWithFav:isfav];
}
- (void)showBreakPoint:(NSString *)breakPoint{
    [_controlView setbreakPoint:[breakPoint doubleValue]/1000];
}
- (NSUInteger)getdefinition{
    return [_controlView definition];
}
/**
 *  更新书签时间
 *
 *  @param breakPoint
 */
- (void)setdefinition:(NSInteger)definition{
    [_controlView setDefinition:definition];
}
- (NSUInteger)indexOfbreakPoint:(NSString *)page{
    NSUInteger aa = [[_controlView choicePageNameList] indexOfObject:page];
    if (aa>0&&aa<[_controlView choicePageNameList].count) {
        return aa;
        
    }else{
        return 0;
    }
}
@end
