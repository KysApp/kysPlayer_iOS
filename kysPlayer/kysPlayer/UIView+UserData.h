//
//  UIView+UserData.h
//  MaiXiLP
//
//  Created by yangyanxiang on 15/12/17.
//  Copyright © 2015年 KYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UserData)
@property(nonatomic,retain) NSObject *_userDate;
- (BOOL) setConstraintConstant:(CGFloat)constant forAttribute:(NSLayoutAttribute)attribute;
- (CGFloat) constraintConstantforAttribute:(NSLayoutAttribute)attribute;
- (NSLayoutConstraint*) constraintForAttribute:(NSLayoutAttribute)attribute;
- (void)hideView:(BOOL)hidden byAttribute:(NSLayoutAttribute)attribute;
- (void)hideByHeight:(BOOL)hidden;
- (void)hideByWidth:(BOOL)hidden;
- (CGSize) getSize;
- (void)sizeToSubviews;
@end
