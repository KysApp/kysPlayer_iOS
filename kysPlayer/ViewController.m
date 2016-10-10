//
//  ViewController.m
//  kysPlayer
//
//  Created by 陈鑫 on 16/10/8.
//  Copyright © 2016年 C.Xin. All rights reserved.
//

#import "ViewController.h"
@interface ViewController ()

@end

@implementation ViewController
-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden  = NO;
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    self.navigationController.navigationBarHidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    //旋转屏幕监听
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(orientChange:) name:UIDeviceOrientationDidChangeNotification object:nil];
    _screensize = [[UIScreen mainScreen] bounds].size;
    _playerView = [[IJKPlayerView alloc] initWithStyle:videoTypeStateVODPlay];
    [_playerView setBackgroundColor:[UIColor blackColor]];
    _playerView.delegate = self;
    _playerView.frame = CGRectMake(0, 0, 320, 320*9/16);
    [_playerView updateTitle:@"测试视频"];
    [_playerView setpageViewcontent:@[@"1",@"2"]];
    [self.view addSubview:_playerView];
    [_playerView playerChangeWithURL:[NSURL URLWithString:@"http://221.181.6.9/223.87.176.132/youku/656348843545818F4524D5E6C/030008010057F83D70A11830267B1CD17303E5-D219-C0EC-0CF0-E027D8C66FF1.mp4"]];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeFrameWithOrientation:(displayOrientation)Orientation{
    CGFloat smallHeight = _screensize.width*9/16;
    float version = [[[UIDevice currentDevice] systemVersion] floatValue];
    switch (Orientation) {
        case displayOrientationPortrait:
            [_playerView setControlState:controlViewStateSmall];
            _playerView.frame = CGRectMake(0, 0, _screensize.width, smallHeight);
            self.navigationController.interactivePopGestureRecognizer.enabled = YES;
            break;
        case displayOrientationLandscapeLeft:
            if (version < 8.0)
            {
                _playerView.frame = CGRectMake(0, 0, _screensize.height, _screensize.width);
            }else{
                _playerView.frame = CGRectMake(0, 0, _screensize.height, _screensize.width);
            }
            [_playerView setControlState:controlViewStateFullScreenUnlock];
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            break;
        case displayOrientationLandscapeRight:
            if (version < 8.0)
            {
                _playerView.frame = CGRectMake(0, 0, _screensize.height, _screensize.width);
            }else{
                _playerView.frame = CGRectMake(0, 0, _screensize.height, _screensize.width);
            }
            [_playerView setControlState:controlViewStateFullScreenUnlock];
            self.navigationController.interactivePopGestureRecognizer.enabled = NO;
            break;
        default:
            break;
    }
}
- (void)changeViewItem:(NSInteger)index with:(NSInteger)definition{
    [_playerView setCurrentIndex:index];
     [_playerView playerChangeWithURL:[NSURL URLWithString:@"http://61.138.255.194:5000/nn_vod/nn_x64/aWQ9OTQzYmI2ODFmNTBlNDgxMjE2NDI4ODg2ZWViNWNjYzYmdXJsX2MxPTZiNmY3YTZlNjE2YjJmNzQ2NTZjNjU3MDZjNjE3OTJmNzk2MTZlNjc2Nzc1Njk2NjY1Njk2ZDY5NzM2ODY5MmY3OTYxNmU2NzY3NzU2OTY2NjU2OTZkNjk3MzY4NjkzMDMxMmU3NDczMjAwMCZubl9haz0wMTA4NTE4Mjc4Yjc2Y2JjMjUxMDQ2OWM3YTdjODY0Mzg3Jm50dGw9MyZucGlwcz0xOTIuMTY4LjE1LjQ5OjUxMDAmbmNtc2lkPTExMDAyJm5ncz01N2RmN2NjZTAwMDc4NGI5ZTg3MzljZGI1OTE5ZTI4NSZubmQ9Y24uemd5ZC54aW5qaWFuZyZuZnQ9dHMmbm5fdXNlcl9pZD03QTBBNkIzQS1BRjE5LTRCMEMtQTVCNi04MDc5RjE5NUU4NkMmbmR0PXBob25lJm5kdj0yLjAuMC5pT1NfS296bmFrX3JlbGVhc2U,/943bb681f50e481216428886eeb5ccc6.m3u8"]];
}
-(void)backBtnAction{
    [self.navigationController popViewControllerAnimated:YES];
}
-(void)dealloc{
    [_playerView playerChangeWithURL:nil];
    [_playerView removeFromSuperview];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    NSLog(@"videoplayVCdealloc");
}
- (void)orientChange:(NSNotification *)noti{
    if ([_playerView getControlState] == controlViewStateFullScreenlock) {
        return;
    }
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    switch (orientation)
    {
        case UIDeviceOrientationPortrait: {
            [self changeFrameWithOrientation:displayOrientationPortrait];
        }
            break;
        case UIDeviceOrientationLandscapeLeft: {
            [self changeFrameWithOrientation:displayOrientationLandscapeLeft];
        }
            break;
        case UIDeviceOrientationLandscapeRight: {
            [self changeFrameWithOrientation:displayOrientationLandscapeRight];
        }
            break;
        default:
            break;
    }
}
- (BOOL)shouldAutorotate{
    if ([_playerView getControlState] == controlViewStateFullScreenlock) {
        return NO;
    }else{
        return YES;
    }
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskAllButUpsideDown;
}
@end
