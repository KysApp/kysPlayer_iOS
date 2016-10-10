//
//  customNavigationController.m
//  CMCCZX
//
//  Created by kys on 16/8/16.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import "kysNavigationController.h"

@implementation kysNavigationController
- (BOOL)shouldAutorotate{
    return [self.visibleViewController shouldAutorotate];
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return [self.visibleViewController supportedInterfaceOrientations];
}
@end
