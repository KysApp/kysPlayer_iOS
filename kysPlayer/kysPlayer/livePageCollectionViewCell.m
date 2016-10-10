//
//  livePageCollectionViewCell.m
//  CMCCZX
//
//  Created by kys on 16/8/15.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import "livePageCollectionViewCell.h"

@implementation livePageCollectionViewCell
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = [UIFont systemFontOfSize:10];
        _nameLabel.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:_nameLabel];
        UIView *lineview = [[UIView alloc] init];
        lineview.translatesAutoresizingMaskIntoConstraints = NO;
        [lineview setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:lineview];
        NSArray *h1 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_nameLabel]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel)];
        NSArray *h2 = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[lineview]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(lineview)];
        NSArray *v = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_nameLabel][lineview(0.5)]|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_nameLabel,lineview)];
        [self addConstraints:h1];
        [self addConstraints:h2];
        [self addConstraints:v];
    }
    return self;
}
-(void)setNameLabelText:(NSString *)str{
    _nameLabel.text = str;
}
- (void)setChoice:(BOOL)choice{
    if (choice) {
        [_nameLabel setTextColor:[UIColor greenColor]];
    }else{
        [_nameLabel setTextColor:[UIColor whiteColor]];
    }
}
@end
