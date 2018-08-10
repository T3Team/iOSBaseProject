//
//  FYDeleteAlertView.m
//  ForYou
//
//  Created by marcus on 2017/12/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYDeleteAlertView.h"
#import "FYHeader.h"
#import "FYPopupController.h"
@interface FYDeleteAlertView ()
@property (nonatomic , copy) NSString *title;

@end

@implementation FYDeleteAlertView


+(instancetype)alertViewWithTitle:(NSString *)title{
    FYDeleteAlertView *view = [[FYDeleteAlertView alloc]init];
    view.title = title;
    [view createView];
    return view;
}


-(instancetype)init{
    self = [super init];
    if (self) {
        self.backgroundColor = color_white;
        
    }
    return self;
}

-(void)createView{
    UILabel *lb = [UILabel new];
    lb.textAlignment = NSTextAlignmentCenter;
    lb.font = [UIFont systemFontOfSize:13];
    lb.textColor = color_black9;
    lb.text = _title;
    lb.numberOfLines = 0;
    [self addSubview:lb];
    [lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@16);
        make.centerX.equalTo(self);
        make.top.equalTo(@22);
        make.width.equalTo(@(ScreenWidth-32));
    }];
    UIView *line = [UIView new];
    line.backgroundColor =color_line;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(lb.mas_bottom).offset(22);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setTitle:@"删除" forState:UIControlStateNormal];
    [btn setTitleColor:color_red_ea4c40 forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn addTarget:self action:@selector(deleteAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn ];
    [btn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@57);
        
    }];
    UIView *line1 = [UIView new];
    line1.backgroundColor =color_line;
    [self addSubview:line1];
    [line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@0.5);
        make.top.equalTo(btn.mas_bottom).offset(0);
    }];
    
    UIButton *btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn1 setTitle:@"取消" forState:UIControlStateNormal];
    [btn1 setTitleColor:color_black3 forState:UIControlStateNormal];
    btn1.titleLabel.font = [UIFont systemFontOfSize:18];
    [btn1 addTarget:self action:@selector(cancellAction) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn1 ];
    [btn1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line1.mas_bottom);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@57);
    }];
    
    
}
-(void)deleteAction{
    __weak typeof(self) weakSelf = self;
    [FYPopupController dissmissPopupViewAnimation:YES completion:^{
        if (self.deleteBlock) {
            self.deleteBlock();
        }
    }];
}

-(void)cancellAction{
    [FYPopupController dissmissPopupView];
}


-(void)showView{
    CGSize size = [_title boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13]} context:nil].size;
    if (kDevice_Is_iPhoneX) {
         self.frame = CGRectMake(0, 0, ScreenWidth, size.height+1+44+57*2+BottomMargin);
    }else{
        self.frame = CGRectMake(0, 0, ScreenWidth, size.height+1+44+57*2);
    }
   [FYPopupController popupView:self popupStyle:FYPopupStyleBottom];
}








/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
