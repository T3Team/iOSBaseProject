//
//  FYNextTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYNextTableCell.h"

@interface FYNextTableCell()
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@end

@implementation FYNextTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.nextButton.layer setCornerRadius:22.5];
    
    CAGradientLayer *gradient = [CAGradientLayer layer];
    gradient.startPoint = CGPointMake(0, 0);
    gradient.endPoint = CGPointMake(1, 0);
    gradient.frame =CGRectMake(0,0,ScreenWidth-24,45);
    
    gradient.colors = [NSArray arrayWithObjects:(id)color_red_ff2c52.CGColor,(id)color_red_e85343.CGColor,nil];
    
    [self.bottomView.layer insertSublayer:gradient atIndex:0];
    [self.bottomView.layer setCornerRadius:22.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
