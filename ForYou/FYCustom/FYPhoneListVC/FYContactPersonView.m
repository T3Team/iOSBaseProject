//
//  FYContactPersonView.m
//  ForYou
//
//  Created by marcus on 2017/10/13.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYContactPersonView.h"
#import "FYHeader.h"
#import "FYPopupController.h"
#import "FYCallContactPersonCell.h"
@interface FYContactPersonView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , copy) NSArray *phones;
@property (nonatomic , copy) NSString *remark;
@property (nonatomic , strong) UITableView *tableView;
@property (nonatomic , copy) NSString *name;

@end
@implementation FYContactPersonView
+(instancetype)contactPersonViewWithPhoneArr:(NSArray *)phones remark:(NSString *)remark name:(NSString *)name{
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    paraStyle.lineSpacing = 7; //设置行间距
    NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
    attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
    attrs[NSParagraphStyleAttributeName] = paraStyle;
    if ([NSString isEmpty:remark]) {
        remark =@" ";
    }
    CGSize size = [remark boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
    CGFloat textHeight = size.height;
    CGRect rc;
    if (phones.count>5) {
        
        rc = CGRectMake(0, 0, ScreenWidth,5*44+229+textHeight);
    }else{
        rc = CGRectMake(0, 0, ScreenWidth, phones.count*44+55+229+textHeight);
    }
    FYContactPersonView *listView = [[FYContactPersonView alloc] initWithFrame:rc];
    listView.phones = phones;
    listView.backgroundColor = color_white;
    listView.remark = remark;
    listView.name = name;
    listView.tableView.backgroundColor = color_white;
    return listView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, _phones.count*57) style:UITableViewStylePlain];
        _tableView.backgroundColor= color_white;
        _tableView.delegate =self;
        _tableView.dataSource= self;
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [_tableView registerNib:[UINib nibWithNibName:@"FYCallContactPersonCell" bundle:nil] forCellReuseIdentifier:@"FYCallContactPersonCell"];
        [self addSubview:_tableView];
        if (_phones.count>5) {
            _tableView.frame= CGRectMake(0, 0, ScreenWidth, 5*44+55);
            _tableView.scrollEnabled=YES;
        } else{
            _tableView.frame= CGRectMake(0, 0, ScreenWidth,_phones.count*44+55);
            _tableView.scrollEnabled= NO;
        }
        UILabel *lb = [UILabel new];
        lb.text = @"备注";
        lb.textColor = color_black6;
        lb.font = [UIFont systemFontOfSize:13];
        [self addSubview:lb];
        [lb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(_tableView.mas_bottom).offset(16);
            make.left.equalTo(@16);
            make.width.equalTo(@100);
            make.height.equalTo(@12.5);
        }];
        NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
        paraStyle.lineSpacing = 7; //设置行间距
        NSMutableDictionary *attrs = [NSMutableDictionary dictionary];
        attrs[NSFontAttributeName] = [UIFont systemFontOfSize:13];
        attrs[NSParagraphStyleAttributeName] = paraStyle;
        CGSize size = [self.remark boundingRectWithSize:CGSizeMake(ScreenWidth-32, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin  attributes:attrs context:nil].size;
        CGFloat textHeight = size.height;
        
        UILabel *remarkLb = [UILabel new];
        remarkLb.attributedText = [[NSAttributedString alloc] initWithString:_remark attributes:attrs];
        remarkLb.textColor = color_black3;
        remarkLb.numberOfLines = 0;
        [self addSubview:remarkLb];
        [remarkLb mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(lb.mas_bottom).offset(9);
            make.left.equalTo(@16);
            make.right.equalTo(@-16);
            make.height.equalTo(@(textHeight));
        }];
        
        UIButton *cancellBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        [cancellBtn setImage:[UIImage imageNamed:@"lxye_close_80"] forState:UIControlStateNormal];
//        [cancellBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancellBtn.backgroundColor = color_white;
        cancellBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancellBtn setTitleColor:color_black3 forState:UIControlStateNormal];
        [cancellBtn addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancellBtn];
        [cancellBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(remarkLb.mas_bottom).offset(95);
            make.centerX.equalTo(self);
            make.width.equalTo(@40);
            make.height.equalTo(@40);
        }];
    }
    return _tableView;
}
-(void)showPhoneList{
    [FYPopupController popupView:self popupStyle:FYPopupStyleBottom];
}

-(void)cancell{
    [FYPopupController dissmissPopupView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _phones.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row ==0) {
        return 55;
    }
    return 44;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYCallContactPersonCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FYCallContactPersonCell" forIndexPath:indexPath];
    cell.callBtn.hidden =YES;
    if (indexPath.row ==0) {
        cell.nameLb .text = self.name;
        cell.phoneLb.text = @"";
    }else{
        cell.nameLb.text = @"";
        cell.phoneLb.text = self.phones[indexPath.row-1];
    }
    return cell;    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if (indexPath.row ==0 ) {
        return;
    }
    NSString *url = [NSString stringWithFormat:@"tel:%@",self.phones[indexPath.row-1]];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
    [FYPopupController dissmissPopupView];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
