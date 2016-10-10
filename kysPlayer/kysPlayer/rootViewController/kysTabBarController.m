//
//  customTabBarController.m
//  CMCCZX
//
//  Created by kys on 16/8/16.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import "kysTabBarController.h"

@implementation kysTabBarController
- (BOOL)shouldAutorotate{
    return [self.selectedViewController shouldAutorotate];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.selectedViewController supportedInterfaceOrientations];
}
@end
