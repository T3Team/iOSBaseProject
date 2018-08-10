//
//  FYCallContactPersonCell.m
//  ForYou
//
//  Created by marcus on 2017/10/13.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYCallContactPersonCell.h"
#import "FYHeader.h"
@interface FYCallContactPersonCell ()



@end

@implementation FYCallContactPersonCell
- (IBAction)callPhoneNum:(UIButton *)sender {
    
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",self.phoneLb.text]]];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    _callBtn.imageView.contentMode =UIViewContentModeScaleAspectFit;
    _callBtn.imageEdgeInsets = UIEdgeInsetsMake(11, 0, 11, 0);
    [self.callBtn setImage:[UIImage imageNamed:@"bbxq_dh_30"] forState:UIControlStateNormal];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
