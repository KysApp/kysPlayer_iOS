//
//  AppDelegate.m
//  kysPlayer
//
//  Created by 陈鑫 on 16/10/8.
//  Copyright © 2016年 C.Xin. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor whiteColor];
    kysRootViewController *HomeVC = [[kysRootViewController alloc] init];
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeSystem];
    btn.frame = CGRectMake(110, 200, 100, 30);
    [btn setTitle:@"click" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(jump) forControlEvents:UIControlEventTouchUpInside];
    [HomeVC.view addSubview:btn];
    HomeVC.title = @"ceshi";
    _nv = [[kysNavigationController alloc] initWithRootViewController:HomeVC];
    UITabBarController *tab = [[kysTabBarController alloc] init];
    tab.viewControllers = [NSArray arrayWithObjects:_nv,nil];
    UIView *bgView = [[UIView alloc] initWithFrame:tab.tabBar.bounds];
    bgView.backgroundColor = [UIColor whiteColor];
    [tab.tabBar insertSubview:bgView atIndex:0];
    _window.rootViewController = tab;
    [self.window makeKeyAndVisible];

    // Override point for customization after application launch.
    return YES;
}

-(void)jump{
    ViewController *vc = [ViewController new];
    vc.hidesBottomBarWhenPushed = YES;
    [_nv pushViewController:vc animated:YES];
}
- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}


- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


@end
