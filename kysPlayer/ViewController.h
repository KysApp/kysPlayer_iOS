//
//  ViewController.h
//  kysPlayer
//
//  Created by 陈鑫 on 16/10/8.
//  Copyright © 2016年 C.Xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IJKPlayerView.h"
#import "kysRootViewController.h"
@interface ViewController : kysRootViewController
{
    IJKPlayerView *_playerView;
    CGSize _screensize;
}

@end

