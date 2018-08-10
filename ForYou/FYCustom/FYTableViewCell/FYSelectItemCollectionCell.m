//
//  FYSelectItemCollectionCell.m
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSelectItemCollectionCell.h"
#import "FYHeader.h"

@interface FYSelectItemCollectionCell()

@end

@implementation FYSelectItemCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.label.layer setCornerRadius:3];
    [self.label.layer setBorderColor:[color_gray_dddddd CGColor]];
    [self.label.layer setBorderWidth:1];
}

- (void)refreshViewWithSelected:(BOOL)bSelected {
    if (!bSelected) {
        [self.label.layer setBorderColor:[color_gray_dddddd CGColor]];
        self.label.textColor = color_black_666666;
    } else {
        [self.label.layer setBorderColor:[color_red_e8382b CGColor]];
        self.label.textColor = color_red_ea4c40;
    }
}

@end
