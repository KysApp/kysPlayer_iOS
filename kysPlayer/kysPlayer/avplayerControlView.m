//
//  avplayerControlView.m
//  MaiXiLP
//
//  Created by kys on 15/12/17.
//  Copyright © 2015年 KYS. All rights reserved.
//

#import "avplayerControlView.h"

@implementation avplayerControlView
#pragma mark - 初始化UI
-(id)initWithVideType:(videoTypeState)videType ProgramName:(NSString *)programName FullScreen:(BOOL)fullScreen{
    self = [super init];
    _screenSize = [[UIScreen mainScreen] bounds].size;
    _definitionNameList = @[@"超清",@"高清",@"标清"];
    _choicePageNameList = [NSArray array];
    _videoType = videType;
    [self initAirPlay];
    self.controlState = controlViewStateSmall;
    [self addWaitView];
    [self addTitleView];
    [self addBottomView];
//    [self adddefinitionChoiceView];
    [self addpageChoiceView];
    [self addLockBtn];
    [self refreshPlayerControllerView];
    [self refreshViewHiddenTime];
    //手势提醒
    //手势提醒
    id PanGesture = [[NSUserDefaults standardUserDefaults] objectForKey:@"HasKnownPanGesture"];
    if (!PanGesture) {
        [self addtipView];
        [[NSUserDefaults standardUserDefaults] setObject:@"1" forKey:@"HasKnownPanGesture"];
    }
    //继续播放label
    [self addBreakPointView];
    //手势控制
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self  action:@selector(addPanGestureRecognizer:)];
    [self addGestureRecognizer:pan];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayAvailabilityChanged:)
                                                 name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(airPlayActivityChanged:)
                                                 name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
    return self;
}
/**
 *  初始化airPlay图标 获取调节音量控件
 */
- (void)initAirPlay{
    _airplayView = [[MPVolumeView alloc] init];
    _airplayView.showsVolumeSlider = NO;
    for (UIView *view in [_airplayView subviews]){
        if ([view.class.description isEqualToString:@"MPVolumeSlider"]){
            _MPPC = (UISlider*)view;
            break;
        }
    }
}
/**
 *  缓冲图以及airplay提示label
 */
-(void)addWaitView
{
    _airplayLab = [[UILabel alloc] init];
    _airplayLab.text = @"通过airplay在设备上播放";
    _airplayLab.textAlignment = NSTextAlignmentCenter;
    _airplayLab.textColor = [UIColor whiteColor];
    _airplayLab.font = [UIFont systemFontOfSize:10];
    [self addSubview:_airplayLab];
    _airplayLab.translatesAutoresizingMaskIntoConstraints = NO;
    NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[_airplayLab]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_airplayLab)];
    NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-50-[_airplayLab]-50-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_airplayLab)];
    [self addConstraints:h];
    [self addConstraints:v];
    _airplayLab.hidden = YES;
    _waitView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    _waitView.hidesWhenStopped = YES;
    [_waitView startAnimating];
    _waitView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_waitView];
    NSArray *_waitViewHoriontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_waitView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_waitView)];
    NSArray *_waitViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_waitView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_waitView)];
    [self addConstraints:_waitViewHoriontal];
    [self addConstraints:_waitViewVertical];
}
/**
 *  播放控件上边条
 */
-(void)addTitleView
{
    _titleView = [[UIView alloc] init];
    _titleView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor whiteColor];
    _timeLabel.textAlignment = NSTextAlignmentCenter;
    _timeLabel.font = [UIFont systemFontOfSize:14];
    _titleLabel = [[UILabel alloc] init];
    _titleLabel.textAlignment = NSTextAlignmentCenter;
    _titleLabel.textColor = [UIColor whiteColor];
    _backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_backBtn setImage:[UIImage imageNamed:@"live_back"] forState:UIControlStateNormal];
    [_backBtn addTarget:self action:@selector(btnAction) forControlEvents:UIControlEventTouchUpInside];
    _backBtn.frame = CGRectMake(0, 0, 40, 40);
    [_titleView addSubview:_timeLabel];
    [_titleView addSubview:_titleLabel];
    [_titleView addSubview:_backBtn];
    [self addSubview:_titleView];
    _titleView.translatesAutoresizingMaskIntoConstraints = NO;
    _timeLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _titleLabel.translatesAutoresizingMaskIntoConstraints = NO;
    _backBtn.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_titleView,_timeLabel,_titleLabel,_backBtn);
    NSArray *_titleViewHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_titleView]|" options:0 metrics:nil views:viewDic];
    NSArray *_titleViewVertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_titleView(40)]" options:0 metrics:nil views:viewDic];
    [self addConstraints:_titleViewHorizontal];
    [self addConstraints:_titleViewVertical];
    NSArray *titleSubViewHorizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_backBtn(40)]-40-[_titleLabel][_timeLabel(80)]|" options:0 metrics:nil views:viewDic];
    [_titleView addConstraints:titleSubViewHorizontal];
    for (UIView *view in _titleView.subviews) {
        _titleViewHorizontal = [NSLayoutConstraint
                                constraintsWithVisualFormat:@"V:|[View]|"
                                options:NSLayoutFormatAlignAllCenterY
                                metrics:nil
                                views:@{@"View" : view}];
        [_titleView addConstraints:_titleViewHorizontal];
    }
}
/**
 *  播放控件下边条
 */
-(void)addBottomView
{
    _bottomView = [[UIView alloc] init];
    _bottomView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _playBtn.frame = CGRectMake(10, 0, 40, 40);
    [_playBtn setImage:[UIImage imageNamed:@"live_landscape_stop"] forState:UIControlStateNormal];
    [_playBtn setImage:[UIImage imageNamed:@"live_landscape_play"] forState:UIControlStateSelected];
    [_playBtn addTarget:self action:@selector(playOrPauseAction) forControlEvents:UIControlEventTouchUpInside];
    _playTimeSlider = [[UISlider alloc] initWithFrame:CGRectMake(0, 0, 10, 40)];
    _playTimeSlider.userInteractionEnabled = YES;
    //    _playTimeSlider.maximumTrackTintColor =kcustomDeepGray;
    //    _playTimeSlider.minimumTrackTintColor =[UIColor whiteColor];
    _playTimeSlider.maximumValue =100;
    _playTimeSlider.minimumValue =0;
    _playTimeSlider.value =0;
    [_playTimeSlider setThumbImage:[self imageWithColor:CGSizeMake(10, 10) color:[UIColor clearColor]] forState:UIControlStateNormal];
    [_playTimeSlider setThumbImage:[self imageWithColor:CGSizeMake(10, 10) color:[UIColor clearColor]] forState:UIControlStateHighlighted];
    [_playTimeSlider setMinimumTrackImage:[self imageWithColor:CGSizeMake(10, 10) color:[UIColor whiteColor]] forState:UIControlStateNormal];
    //滑块左边的图片
    [_playTimeSlider setMaximumTrackImage:[self imageWithColor:CGSizeMake(10, 10) color:[UIColor grayColor]] forState:UIControlStateNormal];//滑块右边的图片
    [_playTimeSlider addTarget:self action:@selector(didSliderTouchDown) forControlEvents:UIControlEventTouchDown];
    [_playTimeSlider addTarget:self action:@selector(didSliderTouchCancel) forControlEvents:UIControlEventTouchCancel];
    [_playTimeSlider addTarget:self action:@selector(didSliderTouchUpOutside) forControlEvents:UIControlEventTouchUpOutside];
    [_playTimeSlider addTarget:self action:@selector(didSliderTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    _sliderIsDrag = NO;
    //播放时间label
    _playerTimeLabel = [[UILabel alloc] init];
    _playerTimeLabel.textColor = [UIColor whiteColor];
    _playerTimeLabel.font = [UIFont systemFontOfSize:10];
    _playerTimeLabel.textAlignment = NSTextAlignmentCenter;
    _playerTimeLabel.text = @"--:--/--:--";
    [_bottomView addSubview:_playerTimeLabel];
    [_bottomView addSubview:_playTimeSlider];
    [_bottomView addSubview:_playBtn];
    _playStyleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _definition = 2;
    if (_definition == 0) {
        [_playStyleBtn setImage:[UIImage imageNamed:@"live_vhd"] forState:UIControlStateNormal];
    }else if(_definition == 1){
        [_playStyleBtn setImage:[UIImage imageNamed:@"live_hd"] forState:UIControlStateNormal];
    }else{
        [_playStyleBtn setImage:[UIImage imageNamed:@"live_sd"] forState:UIControlStateNormal];
    }
    [_playStyleBtn addTarget:self action:@selector(playStyleBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_playStyleBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 2, 10, 2)];
    //集数选择
    _choicePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    CGFloat choiceW;
    if (_videoType == videoTypeStateLive) {
        [_choicePageBtn setImage:[UIImage imageNamed:@"live_drama_g"] forState:UIControlStateNormal];
        choiceW = 30;
    }else{
        [_choicePageBtn setImage:[UIImage imageNamed:@"live_drama"] forState:UIControlStateNormal];
        choiceW = 40;
    }
    [_choicePageBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    [_choicePageBtn addTarget:self action:@selector(choicePageAction:) forControlEvents:UIControlEventTouchUpInside];
    //收藏
    _favBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_favBtn setImage:[UIImage imageNamed:@"live_collection"] forState:UIControlStateNormal];
    [_favBtn setImage:[UIImage imageNamed:@"live_precolle"] forState:UIControlStateSelected];
    [_favBtn addTarget:self action:@selector(favBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [_favBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    //全屏按钮
    _fullScreenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_fullScreenBtn setImage:[UIImage imageNamed:@"live_blowup"] forState:UIControlStateNormal];
    [_fullScreenBtn addTarget:self action:@selector(changePlayerFullScreen) forControlEvents:UIControlEventTouchUpInside];
    [_fullScreenBtn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setImage:[UIImage imageNamed:@"ic_airplay"] forState:UIControlStateNormal];
    [btn setImageEdgeInsets:UIEdgeInsetsMake(10, 5, 10, 5)];
    btn.titleLabel.font = [UIFont systemFontOfSize:8];
    [btn setTintColor:[UIColor whiteColor]];
    [btn addTarget:self action:@selector(showDNLA) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:btn];
    [_bottomView addSubview:_fullScreenBtn];
    [_bottomView addSubview:_choicePageBtn];
    [_bottomView addSubview:_favBtn];
    [_bottomView addSubview:_airplayView];
    [self addSubview:_bottomView];
    _bottomView.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *viewDic = NSDictionaryOfVariableBindings(_playBtn,_playTimeSlider,_playerTimeLabel,_choicePageBtn,_fullScreenBtn,_airplayView,_favBtn,btn);
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_bottomView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)];
    NSArray *vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_bottomView(40)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_bottomView)];
    [self addConstraints:horizontal];
    [self addConstraints:vertical];
    for (UIView *view in _bottomView.subviews) {
        view.translatesAutoresizingMaskIntoConstraints = NO;
        vertical = [NSLayoutConstraint
                    constraintsWithVisualFormat:@"V:|[View]|"
                    options:NSLayoutFormatAlignAllCenterY
                    metrics:nil
                    views:@{@"View" : view}];
        [_bottomView addConstraints:vertical];
    }
    horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[_playBtn(40)]-10-[_playTimeSlider][_playerTimeLabel(105)]-10-[_airplayView(30)][btn(30)][_choicePageBtn(choiceW)][_favBtn(30)][_fullScreenBtn(30)]-5-|" options:0 metrics:[NSDictionary dictionaryWithObject:[NSNumber numberWithFloat:choiceW] forKey:@"choiceW"] views:viewDic];
    [_bottomView addConstraints:horizontal];
    [_airplayView hideByWidth:YES];
    [_favBtn hideByWidth:YES];
}
/**
 *  清晰度选择View
 */
- (void)adddefinitionChoiceView{
    _definitionChoiceView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 10, 10) style:UITableViewStylePlain];
    _definitionChoiceView.delegate = self;
    _definitionChoiceView.dataSource = self;
    _definitionChoiceView.tableHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    _definitionChoiceView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0.1, 0.1)];
    _definitionChoiceView.translatesAutoresizingMaskIntoConstraints = NO;
    _definitionChoiceView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    _definitionChoiceView.separatorInset = UIEdgeInsetsZero;
    _definitionChoiceView.separatorColor = [UIColor whiteColor];
    _definitionChoiceView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255 blue:0/255 alpha:0.5];
    if ([_definitionChoiceView respondsToSelector:@selector(setLayoutMargins:)]) {
        [_definitionChoiceView setLayoutMargins:UIEdgeInsetsZero];
    }
    [self addSubview:_definitionChoiceView];
    _definitionChoiceView.hidden = YES;
    NSLayoutConstraint *_definitionChoiceViewcenter = [NSLayoutConstraint constraintWithItem:_definitionChoiceView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:_playStyleBtn attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSArray *playStyleChoiceViewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[_definitionChoiceView(60)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_definitionChoiceView)];
    NSArray *playStyleChoiceViewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_definitionChoiceView(60)][_bottomView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_definitionChoiceView,_bottomView)];
    [self addConstraint:_definitionChoiceViewcenter];
    [self addConstraints:playStyleChoiceViewH];
    [self addConstraints:playStyleChoiceViewV];
}
/**
 *  选集选台
 */
- (void)addpageChoiceView{
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.minimumInteritemSpacing = 10;
    layout.sectionInset = UIEdgeInsetsMake(15, 0, 15, 0);
    CGFloat pageChoiceToTop;
    if (_videoType == videoTypeStateLive) {
        layout.minimumLineSpacing = 1;
        pageChoiceToTop = 20;
        [_playBtn hideByWidth:YES];
        layout.itemSize = CGSizeMake(159, 30);;
    }else{
        pageChoiceToTop = 59;
        layout.minimumLineSpacing = 10;
        layout.itemSize = CGSizeMake(37, 22);
        layout.sectionInset = UIEdgeInsetsMake(16, 12, 16, 12);
    }
    _pageChoiceView = [[UICollectionView alloc] initWithFrame:CGRectMake(_screenSize.height-159, 40 + pageChoiceToTop, 159, _screenSize.width - 80 - pageChoiceToTop) collectionViewLayout:layout];
    _pageChoiceView.delegate = self;
    _pageChoiceView.dataSource = self;
    _pageChoiceView.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255 blue:0/255 alpha:0.5];
    [_pageChoiceView setShowsVerticalScrollIndicator:NO];
    [_pageChoiceView registerClass:[PageViewCollectionViewCell class] forCellWithReuseIdentifier:@"vodCell"];
    [_pageChoiceView registerClass:[livePageCollectionViewCell class] forCellWithReuseIdentifier:@"liveCell"];
    [self addSubview:_pageChoiceView];
}
//继续播放label
- (void)addBreakPointView{
    _breakPointShowView = [[UIView alloc] init];
    _breakPointShowView.translatesAutoresizingMaskIntoConstraints = NO;
    [_breakPointShowView setBackgroundColor:[UIColor colorWithRed:50.0/255.0 green:50.0/255.0 blue:50.0/255.0 alpha:0.5]];
    [self addSubview:_breakPointShowView];
    NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_breakPointShowView(160)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_breakPointShowView)];
    NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[_breakPointShowView(30)]-10-[_bottomView]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_breakPointShowView,_bottomView)];
    [self addConstraints:h];
    [self addConstraints:v];
    UIButton *cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.translatesAutoresizingMaskIntoConstraints = NO;
    [cancel setImage:[UIImage imageNamed:@"close"] forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(hiddenBreakPointView) forControlEvents:UIControlEventTouchUpInside];
    [_breakPointShowView addSubview:cancel];
    UIButton *jump = [UIButton buttonWithType:UIButtonTypeCustom];
    jump.translatesAutoresizingMaskIntoConstraints = NO;
    jump.tag = 10;
    jump.titleLabel.font = [UIFont systemFontOfSize:10];
    [jump setTitle:@"跳转到上次观看" forState:UIControlStateNormal];
    [jump addTarget:self action:@selector(breakPointActionJump) forControlEvents:UIControlEventTouchUpInside];
    [_breakPointShowView addSubview:jump];
    NSArray *horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[cancel(20)][jump]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancel,jump)];
    NSArray *vertical1 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[cancel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(cancel)];
    NSArray *vertical2 = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[jump]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(jump)];
    [_breakPointShowView addConstraints:horizontal];
    [_breakPointShowView addConstraints:vertical1];
    [_breakPointShowView addConstraints:vertical2];
    [self hiddenBreakPointView];
}
/**
 *  锁屏按钮
 */
- (void)addLockBtn{
    _lockBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    _lockBtn.frame = CGRectMake(20, _screenSize.width/2-20, 40, 40);
    [_lockBtn setImage:[UIImage imageNamed:@"live_lock_off"] forState:UIControlStateNormal];
    [_lockBtn setImage:[UIImage imageNamed:@"live_lock_on"] forState:UIControlStateSelected];
    [_lockBtn addTarget:self action:@selector(lockBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    _lockBtn.hidden = YES;
    [self addSubview:_lockBtn];
}
//手势提示
- (void)addtipView{
    _tipView = [[UIView alloc] init];
    _tipView.userInteractionEnabled = NO;
    _tipView.translatesAutoresizingMaskIntoConstraints = NO;
    [self addSubview:_tipView];
    NSArray *tipviewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_tipView]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tipView)];
    NSArray *tipviewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-60-[_tipView]-60-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_tipView)];
    [self addConstraints:tipviewH];
    [self addConstraints:tipviewV];
    UIImageView *lightview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_Brightness"]];
    lightview.contentMode = UIViewContentModeScaleAspectFit;
    lightview.translatesAutoresizingMaskIntoConstraints = NO;
    [_tipView addSubview:lightview];
    NSArray *lightviewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lightview(28)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lightview)];
    NSArray *lightviewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[lightview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lightview)];
    [_tipView addConstraints:lightviewH];
    [_tipView addConstraints:lightviewV];
    UIImageView *volumnview = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"live_volume"]];
    volumnview.translatesAutoresizingMaskIntoConstraints = NO;
    volumnview.contentMode = UIViewContentModeScaleAspectFit;
    [_tipView addSubview:volumnview];
    NSArray *volumnviewH = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[volumnview(28)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(volumnview)];
    NSArray *volumnviewV = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[volumnview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(volumnview)];
    [_tipView addConstraints:volumnviewH];
    [_tipView addConstraints:volumnviewV];
}
#pragma mark - 手势控制
-(void)addPanGestureRecognizer:(UIPanGestureRecognizer *)sender{
    if (_controlState != controlViewStateFullScreenlock) {
        CGPoint nowPoint = [sender locationInView:self];
        if (sender.state == UIGestureRecognizerStateBegan) {
            _beginVoice = _MPPC.value;
            _beginPoint = nowPoint;
            _beginprocess = _playTimeSlider.value;
            _beginBrightness = [[UIScreen mainScreen] brightness];
        }else if(sender.state == UIGestureRecognizerStateChanged){
            if (!_type) {
                if (fabs(nowPoint.x - _beginPoint.x) < fabs(nowPoint.y - _beginPoint.y)) {
                    if ((_controlState == controlViewStateSmall&&_beginPoint.x>_screenSize.width/2)||_beginPoint.x>_screenSize.height/2) {
                        _type = @"voice";
                    }else{
                        _type = @"light";
                    }
                }else{
                    _type = @"process";
                }
            }
            if ([_type isEqualToString:@"process"]) {
                [_timer invalidate];
                _timer = nil;
                _sliderIsDrag = YES;
                if (_bottomView.hidden) {
                    [self hiddenControlViewOrNot];
                    if (_delegate&&[_delegate respondsToSelector:@selector(needloadTime)]&&(_videoType == videoTypeStateVODPlay||videoTypeStateLivePlayBack)) {
                        [_delegate needloadTime];
                    }
                }
                _playTimeSlider.value = _beginprocess + (nowPoint.x - _beginPoint.x);
            }else if ([_type isEqualToString:@"voice"]) {
                _MPPC.value = _beginVoice + (_beginPoint.y - nowPoint.y)/_screenSize.width;
            }else if ([_type isEqualToString:@"light"]){
                [[UIScreen mainScreen] setBrightness:_beginBrightness + (_beginPoint.y - nowPoint.y)/500];
            }
            
        }else if(sender.state == UIGestureRecognizerStateEnded){
            if ([_type isEqualToString:@"process"]&&(_videoType == videoTypeStateVODPlay||videoTypeStateLivePlayBack)&&(nowPoint.y<_screenSize.width-40)) {
                if (_delegate&&[_delegate respondsToSelector:@selector(GetProgressCHange:)]) {
                    [_delegate GetProgressCHange:_playTimeSlider.value];
                    [self refreshViewHiddenTime];
                }
            }
            _sliderIsDrag = NO;
            _type = nil;
        }
    }
}
//解/锁屏
-(void)lockBtnAction:(UIButton *)sender
{
    _breakPointShowView.hidden = YES;
    sender.selected = !sender.selected;
    if (sender.selected) {
        _controlState = controlViewStateFullScreenlock;
        [self changevisible];
    }else{
        _controlState = controlViewStateFullScreenUnlock;
        [self changevisible];
    }
}
-(void)setCurrentPageNum:(NSInteger)currentPageNum{
    if (currentPageNum>_choicePageNameList.count-1||currentPageNum<0) {
        return;
    }
    _currentPageNum = currentPageNum;
    _playTimeSlider.value = 0;
    [_pageChoiceView reloadData];
    if (_choicePageNameList.count > 0) {
        [_pageChoiceView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:_currentPageNum inSection:0] atScrollPosition:UICollectionViewScrollPositionCenteredVertically animated:NO];
    }
}

-(void)playStyleBtnAction{
    _pageChoiceView.hidden = YES;
    [self refreshViewHiddenTime];
    _definitionChoiceView.hidden = !_definitionChoiceView.hidden;
}

-(void)hiddenBreakPointView{
    _breakPointShowView.hidden = YES;
    _breakPoint = 0;
}

-(void)breakPointActionJump{
    if (_delegate&&[_delegate respondsToSelector:@selector(GetProgressCHange:)]) {
        [_delegate GetProgressCHange:_breakPoint];
        [self refreshViewHiddenTime];
    }
    [self hiddenBreakPointView];
}

-(void)playOrPauseAction
{
    _definitionChoiceView.hidden = YES;
    _pageChoiceView.hidden = YES;
    [self refreshViewHiddenTime];
    _playBtn.selected = !_playBtn.selected;
    NSNumber *playorpause=[NSNumber numberWithBool:_playBtn.selected];
    NSDictionary *playorpausedic = [NSDictionary dictionaryWithObjectsAndKeys:playorpause,@"playorpause", nil];
    [[NSNotificationCenter defaultCenter]postNotificationName:@"playorpause" object:self userInfo:playorpausedic];
    if (_delegate&&[_delegate respondsToSelector:@selector(changePlayerStaute:)]) {
        [_delegate changePlayerStaute:_playBtn.selected];
    }
}

-(void)favBtnAction:(UIButton *)sender{
    _definitionChoiceView.hidden = YES;
    _pageChoiceView.hidden = YES;
    [self refreshViewHiddenTime];
    if (_favBtn.selected) {
        if (_delegate&&[_delegate respondsToSelector:@selector(changewhetherfavourite:)]) {
            [_delegate changewhetherfavourite:NO];
        }
    }else{
        if (_delegate&&[_delegate respondsToSelector:@selector(changewhetherfavourite:)]) {
            [_delegate changewhetherfavourite:YES];
        }
    }
}

-(void)choicePageAction:(UIButton *)sender
{
    _definitionChoiceView.hidden = YES;
    _tipView.hidden = YES;
    if (_choicePageNameList.count == 0) {
        return;
    }
    sender.selected = !sender.selected;
    _pageChoiceView.hidden = !_pageChoiceView.hidden;
    if (sender.selected == YES) {
        [_timer invalidate];
        _timer = nil;
    }else{
        [self refreshViewHiddenTime];
    }
}
-(void)showvolumn:(UIButton *)sender
{
    _pageChoiceView.hidden = YES;
    [self hiddenBreakPointView];
    [self refreshViewHiddenTime];
}
-(void)changePlayerFullScreen
{
    [self refreshViewHiddenTime];
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}

-(void)btnAction
{
    if (_controlState == controlViewStateFullScreenUnlock) {
        if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
            SEL selector = NSSelectorFromString(@"setOrientation:");
            NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
            [invocation setSelector:selector];
            [invocation setTarget:[UIDevice currentDevice]];
            int val = UIInterfaceOrientationPortrait;
            [invocation setArgument:&val atIndex:2];
            [invocation invoke];
        }
    }else{
        [_timer invalidate];
        _timer = nil;
        if (_delegate&&[_delegate respondsToSelector:@selector(backBtnAction)]) {
            [_delegate backBtnAction];
        }
    }
}
#pragma mark - 选集选台collectionview代理
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _choicePageNameList.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (_videoType == videoTypeStateVODPlay) {
        PageViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"vodCell" forIndexPath:indexPath];
        cell.name.text = _choicePageNameList[indexPath.row];
        if (indexPath.row == _currentPageNum) {
            cell.name.textColor = [UIColor blueColor];
            cell.contentView.layer.borderColor = [[UIColor blueColor] CGColor];
        }else{
            cell.name.textColor = [UIColor whiteColor];
            cell.contentView.layer.borderColor = [UIColor whiteColor].CGColor;
        }
        return cell;
    }else{
        livePageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"liveCell" forIndexPath:indexPath];
        [cell setNameLabelText:_choicePageNameList[indexPath.row]];
        if (indexPath.row == _currentPageNum) {
            [cell setChoice:YES];
        }else{
            [cell setChoice:NO];
        }
        return cell;
    }
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == _currentPageNum) {
        return;
    }
    _pageChoiceView.hidden = YES;
    _choicePageBtn.selected = NO;
    [self hiddenControlViewOrNot];
    if ([[self delegate] respondsToSelector:@selector(changeViewItem:with:)]) {
        [[self delegate] changeViewItem:indexPath.row with:-1];
    }
}
-(void) refreshViewHiddenTime
{
    NSDate *date = [NSDate date];
    NSDateFormatter *format = [[NSDateFormatter alloc] init];
    [format setDateFormat:@"hh:mm"];
    _timeLabel.text = [format stringFromDate:date];
    [_timer invalidate];
    _timer = nil;
    _timer = [NSTimer scheduledTimerWithTimeInterval:4 target:self selector:@selector(hiddenControlViewOrNot) userInfo:nil repeats:NO];
    if (_delegate&&[_delegate respondsToSelector:@selector(needloadTime)]&&(_videoType == videoTypeStateVODPlay||videoTypeStateLivePlayBack)) {
        [_delegate needloadTime];
    }
}
-(void) hiddenControlViewOrNot
{
    _definitionChoiceView.hidden = YES;
    if (_controlState != controlViewStateSmall) {
        _lockBtn.hidden = !_lockBtn.hidden;
    }
    if (!_lockBtn.selected) {
        _titleView.hidden = !_titleView.hidden;
        _bottomView.hidden = !_bottomView.hidden;
    }
    if (_lockBtn.hidden&&_bottomView.hidden) {
        _tipView.hidden = YES;
    }
}
-(void) touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    _definitionChoiceView.hidden = YES;
    _pageChoiceView.hidden = YES;
    _choicePageBtn.selected = NO;
    [_timer invalidate];
    _timer = nil;
    [self hiddenControlViewOrNot];
    if ((_controlState == controlViewStateSmall&&_bottomView.hidden == NO)||_lockBtn.hidden == NO) {
        [self refreshViewHiddenTime];
    }
}
//airplay监听
- (void)airPlayAvailabilityChanged:(NSNotification *)notification {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         if ([_airplayView areWirelessRoutesAvailable]) {
                             [_airplayView hideByWidth:NO];
                         } else if (! [_airplayView isWirelessRouteActive]) {
                             [_airplayView hideByWidth:YES];
                         }
                         [self layoutIfNeeded];
                     }];
}


- (void)airPlayActivityChanged:(NSNotification *)notification {
    [UIView animateWithDuration:0.4f
                     animations:^{
                         if ([_airplayView isWirelessRouteActive]) {
                             _airplayLab.hidden = NO;
                         } else {
                             _airplayLab.hidden = YES;
                         }
                     }];
}

- (void)changevisible{
    switch (_controlState) {
        case controlViewStateSmall:
            _lockBtn.hidden = YES;
            [_fullScreenBtn hideByWidth:NO];
            [_playerTimeLabel hideByWidth:YES];
            [_choicePageBtn hideByWidth:YES];
            _titleView.hidden = NO;
            _bottomView.hidden = NO;
            _pageChoiceView.hidden = YES;
            _playTimeSlider.hidden = YES;
            _choicePageBtn.selected = NO;
            _definitionChoiceView.hidden = YES;
            if (_videoType == videoTypeStateLive) {
                [_playBtn hideByWidth:YES];
//                [_favBtn hideByWidth:YES];
            }else if (_videoType == videoTypeStateLivePlayBack){
                [_playBtn hideByWidth:NO];
//                [_favBtn hideByWidth:YES];
            }else{
                [_playBtn hideByWidth:NO];
//                [_favBtn hideByWidth:NO];
            }
            break;
        case controlViewStateFullScreenUnlock:
            _lockBtn.hidden = NO;
            _pageChoiceView.hidden = YES;
            _choicePageBtn.selected = NO;
            _titleView.hidden = NO;
            _bottomView.hidden = NO;
            _definitionChoiceView.hidden = YES;
            if (_choicePageNameList.count <= 1) {
                [_choicePageBtn hideByWidth:YES];
            }else{
                [_choicePageBtn hideByWidth:NO];
            }
            [_fullScreenBtn hideByWidth:YES];
            if (_videoType == videoTypeStateVODPlay) {
                [self changeBtnsWithLive:NO];
            }else if (_videoType == videoTypeStateLivePlayBack){
                [self changeBtnsWithLive:NO];
//                [_favBtn hideByWidth:YES];
            }else{
                [self changeBtnsWithLive:YES];
            }
            break;
        case controlViewStateFullScreenlock:
            _titleView.hidden = YES;
            _bottomView.hidden = YES;
            _pageChoiceView.hidden = YES;
            _choicePageBtn.selected = NO;
            _definitionChoiceView.hidden = YES;
            break;
        default:
            break;
    }
    [self refreshViewHiddenTime];
}
//直播点播切换
- (void)changeBtnsWithLive:(BOOL)isLive{
    [_playerTimeLabel hideByWidth:isLive];
    _playTimeSlider.hidden = isLive;
//    [_favBtn hideByWidth:isLive];
    [_playBtn hideByWidth:isLive];
}
//显示dlna选择
- (void)showDNLA{
    if (_delegate&&[_delegate respondsToSelector:@selector(showDLNA)]) {
        [_delegate showDLNA];
    }
}
#pragma mark - 进度条拖动
- (IBAction)didSliderTouchDown
{
    [_timer invalidate];
    _timer = nil;
    _sliderIsDrag = YES;
}

- (IBAction)didSliderTouchCancel
{
    _sliderIsDrag = NO;
    [self hiddenControlViewOrNot];
}

- (IBAction)didSliderTouchUpOutside
{
    _pageChoiceView.hidden = YES;
    _sliderIsDrag = NO;
    if (_delegate&&[_delegate respondsToSelector:@selector(GetProgressCHange:)]) {
        [_delegate GetProgressCHange:_playTimeSlider.value];
    }
    [self hiddenControlViewOrNot];
}

- (IBAction)didSliderTouchUpInside
{
    _pageChoiceView.hidden = YES;
    _sliderIsDrag = NO;
    if (_delegate&&[_delegate respondsToSelector:@selector(GetProgressCHange:)]) {
        [_delegate GetProgressCHange:_playTimeSlider.value];
    }
    [self refreshViewHiddenTime];
}
#pragma mark - 清晰度选择tableview代理
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.text = [_definitionNameList objectAtIndex:indexPath.row];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.font = [UIFont systemFontOfSize:10];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (_definition == indexPath.row) {
        cell.textLabel.textColor = [UIColor greenColor];
    }else{
        cell.textLabel.textColor = [UIColor whiteColor];
    }
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 20;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    _definitionChoiceView.hidden = YES;
    if (indexPath.row == _definition) {
        return;
    }
    if ([[self delegate] respondsToSelector:@selector(changeViewItem:with:)]) {
        [[self delegate] changeViewItem:_currentPageNum with:indexPath.row];
    }
}
- (void)setDefinition:(NSInteger)definition{
    if (definition<0||definition>2){
        return;
    }
    _definition = definition;
    [_definitionChoiceView reloadData];
    if (_definition == 0) {
        [_playStyleBtn setImage:[UIImage imageNamed:@"live_vhd"] forState:UIControlStateNormal];
    }else if(_definition == 1){
        [_playStyleBtn setImage:[UIImage imageNamed:@"live_hd"] forState:UIControlStateNormal];
    }else{
        [_playStyleBtn setImage:[UIImage imageNamed:@"live_sd"] forState:UIControlStateNormal];
    }
}
-(UIImage *)imageWithColor:(CGSize)size color:(UIColor*)color
{
    CGRect rect = CGRectMake(0, 0, size.width, size.height);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}
#pragma mark - 可被访问方法
- (void)setvideType:(videoTypeState)type{
    if ((_videoType == videoTypeStateLive||_videoType == videoTypeStateLivePlayBack) && type == videoTypeStateVODPlay) {
        _videoType = videoTypeStateLivePlayBack;
    }else{
        _videoType = type;
    }
    _playBtn.selected = NO;
    [self changevisible];
}
- (void)refreshPlayerControllerView
{
    [self changevisible];
}
- (void)SynCurrentTime:(NSString *)currentTime DurrentTime:(NSString *)durrentime
{
    double time =[currentTime intValue];
    double duration =[durrentime intValue];
    int hour = time/3600;
    int Currentminute = (time-hour*3600)/60;
    int second = time-Currentminute*60-hour*3600;
    int hour1 = duration/3600;
    int minute1 = (duration-hour1*3600)/60;
    int second1 =duration-minute1*60-hour1*3600;
    if (_sliderIsDrag) {
        time = _playTimeSlider.value;
        int hour = time/3600;
        int Currentminute = (time-hour*3600)/60;
        int second = time-Currentminute*60-hour*3600;
        _playerTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d/%02d:%02d:%02d",hour,Currentminute,second,hour1,minute1,second1];
    }else{
        if (_videoType == videoTypeStateLive) {
            return;
        }
        _playerTimeLabel.text = [NSString stringWithFormat:@"%02d:%02d:%02d/%02d:%02d:%02d",hour,Currentminute,second,hour1,minute1,second1];
        if(_playBtn.selected == 0){
            _playTimeSlider.value = time;
        }
    }
}
- (void) updateTitle:(NSString*)title{
    _titleLabel.text = title;
}
- (void)removeairplay{
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRoutesAvailableDidChangeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MPVolumeViewWirelessRouteActiveDidChangeNotification object:nil];
}
- (BOOL)bottomHidden{
    return _bottomView.hidden;
}
- (void)setPlayBtnState:(BOOL)play{
    _playBtn.selected = !play;
}
- (void)changeTheDuration:(float)duration{
    if (_playTimeSlider) {
        _playTimeSlider.maximumValue = duration;
    }
    if (_breakPoint != 0 && _breakPointShowView.hidden &&!_lockBtn.selected) {
        _breakPointShowView.hidden = NO;
        [NSTimer scheduledTimerWithTimeInterval:6 target:self selector:@selector(hiddenBreakPointView) userInfo:nil repeats:NO];
    }
}
- (void)changeFavBtnWithFav:(BOOL)isfav{
    _favBtn.selected = isfav;
}
- (void)setbreakPoint:(NSTimeInterval)breakPoint{
    if (breakPoint<30) {
        return;
    }
    _breakPoint = breakPoint;
    UIButton *jump = [_breakPointShowView viewWithTag:10];
    if (jump) {
        int total = breakPoint;
        int Currentminute = total/60;
        int second = total - Currentminute*60;
        NSMutableAttributedString *string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"上次观看到%d:%02d，点击续播",Currentminute,second]];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor greenColor] range:NSMakeRange(string.length-2, 2)];
        [jump setAttributedTitle:string forState:UIControlStateNormal];
    }
}
@end
