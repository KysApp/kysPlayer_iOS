//
//  livePageCollectionViewCell.h
//  CMCCZX
//
//  Created by kys on 16/8/15.
//  Copyright © 2016年 KYS. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface livePageCollectionViewCell : UICollectionViewCell
{
    UILabel *_nameLabel;
}
-(void)setNameLabelText:(NSString *)str;
- (void)setChoice:(BOOL)choice;
@end
