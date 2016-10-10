//
//  PageViewCollectionViewCell.m
//  Kozinake
//
//  Created by kys on 16/2/25.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import "PageViewCollectionViewCell.h"

@implementation PageViewCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _name = [[UILabel alloc] init];
        _name.translatesAutoresizingMaskIntoConstraints = NO;
        _name.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:_name];
        NSArray *h = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_name]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_name]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_name)];
        [self.contentView addConstraints:h];
        [self.contentView addConstraints:v];
        self.contentView.layer.borderWidth = 1;
        self.contentView.layer.cornerRadius = 5;
    }
    return self;
}
@end
