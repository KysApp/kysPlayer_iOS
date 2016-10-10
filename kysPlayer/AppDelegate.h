//
//  AppDelegate.h
//  kysPlayer
//
//  Created by 陈鑫 on 16/10/8.
//  Copyright © 2016年 C.Xin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "kysTabBarController.h"
#import "kysNavigationController.h"
#import "ViewController.h"
@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    kysNavigationController *_nv;
}

@property (strong, nonatomic) UIWindow *window;


@end

