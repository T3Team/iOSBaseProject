//
//  FirstComeInView.m
//  ForYou
//
//  Created by marcus on 2017/10/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FirstComeInView.h"
#import "FYHeader.h"
#import <ChameleonFramework/Chameleon.h>

@implementation FirstComeInView

-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        
        UIView * backView = [[UIView alloc] initWithFrame:CGRectMake(0, (ScreenHeight-ScreenWidth-80)/2.0, ScreenWidth, ScreenWidth+80)];
        backView.backgroundColor = color_clear;
        [self addSubview:backView];
        
        self.imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenWidth)];
        _imgView.backgroundColor = color_clear;
        [backView addSubview:_imgView];
    
        
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_imgView.frame)+14, ScreenWidth, 30)];
        _titleLabel.font = [UIFont systemFontOfSize:30];
        _titleLabel.textColor = color_black3;
        _titleLabel.text = @"";
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        [backView addSubview:_titleLabel];
        
        self.remindLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_titleLabel.frame)+18, ScreenWidth, 16)];
        _remindLabel.font = [UIFont systemFontOfSize:15];
        _remindLabel.textColor = color_black9;
        _remindLabel.textAlignment = NSTextAlignmentCenter;
        _remindLabel.text = @"";
        [backView addSubview:_remindLabel];
    }
    return self;
}

- (void)lastViewAddButton{
    UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake((ScreenWidth-150)/2.0, self.frame.size.height-75, 150, 45);
    btn.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:btn.bounds andColors:@[color_btn_ff2c52,color_btn_ec4b39]];
    [btn setTitle:@"立即体验" forState:UIControlStateNormal];
    btn.layer.cornerRadius = 22.5f;
    [self addSubview:btn];
    self.comeinBtn = btn;
}




@end
