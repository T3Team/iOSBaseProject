//
//  FYAlertUpdateView.m
//  ForYou
//
//  Created by marcus on 2017/10/12.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAlertUpdateView.h"
#import "FYHeader.h"
#import <ChameleonFramework/Chameleon.h>
@interface FYAlertUpdateView ()
@property (nonatomic ,assign) FYUpdateType type;
@property (nonatomic , copy) NSString *version;
@property (nonatomic , copy) NSString *content;
@end

@implementation FYAlertUpdateView
{
    UIView *backGroundView;
    UIButton *updateBtn;
}
+(instancetype)updateViewWithFrame:(CGRect)frame type:(FYUpdateType)type version:(NSString *)version content:(NSString *)content{
    FYAlertUpdateView *alertUpdateView = [[FYAlertUpdateView alloc] initWithFrame:frame];
    alertUpdateView.type = type;
    alertUpdateView.version = version;
    alertUpdateView.content = content;
    [alertUpdateView createdefaultStyle];
    return alertUpdateView;
}

-(void) createdefaultStyle {
    self.backgroundColor = color_white;
    self.clipsToBounds = YES;
    self.layer.cornerRadius = 5;
    UIImageView *im = [[UIImageView alloc] init];
    im.image = [UIImage imageNamed:@"icon_app_update"];
    [self addSubview:im];
    if (self.type == FYUpdateTypeOption) {
        UIButton *closebtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [closebtn setImage:[UIImage imageNamed:@"icon_close_gray"] forState:UIControlStateNormal];
        [closebtn addTarget:self action:@selector(closeUpdate) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:closebtn];
        [closebtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self);
            make.top.equalTo(self);
            make.width.equalTo(@44);
            make.height.equalTo(@44);
        }];
    }
    
    
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.equalTo(@110);
        make.height.equalTo(@94);
        make.top.equalTo(@25);
    }];
    
    UILabel *lb = [UILabel new];
    lb.textColor = color_red_ea4c40;
    lb.font = [UIFont systemFontOfSize:18];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.text = [NSString stringWithFormat:@"发现新版本V%@",self.version];
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(im.mas_bottom).offset(10);
        make.height.equalTo(@17);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 7; //设置行间距
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attrs[NSParagraphStyleAttributeName] = paraStyle;
    CGSize size = [self.content boundingRectWithSize:CGSizeMake(ScreenWidth-95-39, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
    CGFloat textHeight =0;
    if (size.height<95) {
        textHeight = size.height;
    }else{
        textHeight= 95;
    }
    UITextView *textView = [[UITextView alloc]init];
    
    textView.textColor = color_black3;
    textView.editable= NO;
    textView.attributedText = [[NSAttributedString alloc] initWithString:_content attributes:attrs];
    textView.text = self.content;
    [self addSubview:textView];
    [textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@19.5);
        make.right.equalTo(@-19.5);
        make.height.equalTo(@(textHeight));
        make.top.equalTo(lb.mas_bottom).offset(23);
    }];
    
    updateBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [updateBtn setTitle:@"立即更新" forState:UIControlStateNormal];
    updateBtn.backgroundColor = [UIColor colorWithGradientStyle:UIGradientStyleLeftToRight withFrame:CGRectMake(0, 0, ScreenWidth - 95-39, 40) andColors:@[color_btn_ff2c52,color_btn_ec4b39]];
    [updateBtn setTitleColor:color_white forState:UIControlStateNormal];
    updateBtn.titleLabel.font = [UIFont systemFontOfSize:18];
    [updateBtn addTarget:self action:@selector(updateVersion) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:updateBtn];
    updateBtn.layer.cornerRadius = 20;
    [updateBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(textView.mas_bottom).offset(26);
        make.left.equalTo(@19.5);
        make.right.equalTo(@-19.5);
        make.height.equalTo(@40);
    }];
}

-(void) show {
    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    backGroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    [keyWindow addSubview:backGroundView];
    
    [keyWindow addSubview:self];
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 10; //设置行间距
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:14];
    attrs[NSParagraphStyleAttributeName] = paraStyle;
    CGSize size = [self.content boundingRectWithSize:CGSizeMake(ScreenWidth-95-39, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
    CGFloat textHeight =0;
    if (size.height<92) {
        textHeight = size.height;
    }else{
        textHeight= 92;
    }
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@47.5);
        make.right.equalTo(@-47.5);
        make.centerY.equalTo(keyWindow);
        make.bottom.equalTo(updateBtn.mas_bottom).offset(17);
        //        make.height.equalTo(@(252+textHeight));
    }];
    
}

-(void) updateVersion {
    FYLog(@"立即更新");
//     [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@""]];
}

-(void)closeUpdate {
    
    [backGroundView removeFromSuperview];
    [self removeFromSuperview];
    
}

@end
