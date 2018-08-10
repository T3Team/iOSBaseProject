//
//  FYPhoneListView.m
//  ForYou
//
//  Created by marcus on 2017/9/8.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYPhoneListView.h"
#import "FYHeader.h"
#import "FYPopupController.h"
@interface FYPhoneListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic , copy) NSArray *phones;
@property (nonatomic , strong) UITableView *tableView;

@property(nonatomic, strong)UIColor * cellColor;
@end

@implementation FYPhoneListView

+(instancetype)listViewWithPhoneArr:(NSArray *)phones{
    CGRect rc;
    if (phones.count>5) {
        
        rc = CGRectMake(0, 0, ScreenWidth,kDevice_Is_iPhoneX?5*50+50+BottomMargin: 5*50+50);
    }else{
        rc = CGRectMake(0, 0, ScreenWidth,kDevice_Is_iPhoneX ?phones.count*50+50+BottomMargin: phones.count*50+50);
    }
    FYPhoneListView *listView = [[FYPhoneListView alloc] initWithFrame:rc];
    listView.phones = phones;
    listView.backgroundColor = color_white;
    [listView addSubview:listView.tableView];
    return listView;
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,ScreenWidth, _phones.count*50) style:UITableViewStylePlain];
        _tableView.rowHeight= 50;
        _tableView.backgroundColor= color_white;
        _tableView.delegate =self;
        _tableView.dataSource= self;
        UIButton *cancellBtn =[UIButton buttonWithType:UIButtonTypeCustom];
        if (_phones.count>5) {
            _tableView.frame= CGRectMake(0, 0, ScreenWidth, 5*50);
            cancellBtn.frame = CGRectMake(0, 5*50, ScreenWidth, 50);
            _tableView.scrollEnabled=YES;
        }else{
            _tableView.frame= CGRectMake(0, 0, ScreenWidth,_phones.count*50);
            _tableView.scrollEnabled= NO;
            cancellBtn.frame = CGRectMake(0, _phones.count*50, ScreenWidth, 50);
        }
        _tableView.separatorStyle= UITableViewCellSeparatorStyleNone;
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"phonelist"];
        [cancellBtn setTitle:@"取消" forState:UIControlStateNormal];
        cancellBtn.backgroundColor = color_white;
        cancellBtn.titleLabel.font = [UIFont systemFontOfSize:18];
        [cancellBtn setTitleColor:color_black3 forState:UIControlStateNormal];
        [cancellBtn addTarget:self action:@selector(cancell) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:cancellBtn];
        
    }
    return _tableView;
}
-(void)showPhoneList{
    [FYPopupController popupView:self popupStyle:FYPopupStyleBottom backgroundColor:color_black_alpha4 animateDuration:0.3 depthSacle:1 isBackgroundCancel:YES completion:^{
    }];
}

-(void)cancell{
    [FYPopupController dissmissPopupView];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _phones.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"phonelist" forIndexPath:indexPath];
    UIView *lineView = [[UIView alloc]initWithFrame:CGRectMake(0, 49.5, ScreenWidth, 0.5)];
    lineView.backgroundColor = color_line;
    [cell addSubview:lineView];
    cell.textLabel.textAlignment = NSTextAlignmentCenter;
    cell.textLabel.text = _phones[indexPath.row];
    cell.textLabel.textColor = self.cellColor ?: color_black3;
    cell.textLabel.font = [UIFont systemFontOfSize:18];
    return cell;
    
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    [FYPopupController dissmissPopupViewAnimation:YES completion:^{
        if (self.selectBlock) {
            self.selectBlock([NSString stringWithFormat:@"%ld",indexPath.row]);
        }
    }];
}


-(void)setCellContentColor:(UIColor *)cellColor{
    if (cellColor) {
        self.cellColor = cellColor;
        [self.tableView reloadData];
    }
}


@end
