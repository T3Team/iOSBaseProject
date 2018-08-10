//
//  FYSelectItemCollectionCell.h
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//  collection选择项 

#import <UIKit/UIKit.h>

@interface FYSelectItemCollectionCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UILabel *label;

- (void)refreshViewWithSelected:(BOOL)bSelected;

@end
