//
//  FYSelectListView.m
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSelectListView.h"
#import "Masonry.h"
#import "FYSelectListCell.h"
#import "FYPopupController.h"


#define kTitleHeight 25
#define kRowHeight 40

static NSString *kFYSelectListCellIdentifier = @"FYSelectListCell";

@interface FYSelectListView ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic ,strong) UITableView *tableView;
@property (nonatomic ,strong) UIView *backGroundView;
@property (nonatomic ,copy) NSArray<NSString *> *dataArr;
@property (nonatomic ,copy) NSString *title;
//是否可以多选项
@property (nonatomic ,assign) BOOL isMoreOption;

//当可以多选的时候 数组放着选中的内容
@property (nonatomic, strong) NSMutableArray *selectArr;

@end



@implementation FYSelectListView
+(FYSelectListView *)selectListViewWithTitle:(NSString *)title dataArr:(NSArray *)dataArr isMoreOption:(BOOL)isMoreOption {
    FYSelectListView *listView = [[FYSelectListView alloc] init];
    listView.backgroundColor = [UIColor whiteColor];
    listView.clipsToBounds = YES;
    listView.layer.cornerRadius=5;
    listView.dataArr = dataArr;
    listView.title = title;
    listView.isMoreOption = isMoreOption;
    [listView constructDefaultView];
    return listView;
    
}

-(void) show{
    CGFloat height = kRowHeight * _dataArr.count + kTitleHeight + 30;
    if (height>400) {
        height=400;
    }else{
        self.tableView.scrollEnabled = NO;
    }
    self.frame = CGRectMake(0, 0, 290, height);
    [FYPopupController popupView:self popupStyle:FYPopupStyleCenter];
    
//    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
//    _backGroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
//    _backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
//    [keyWindow addSubview:_backGroundView];
//    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
//    [_backGroundView addGestureRecognizer:tap];
//    [keyWindow addSubview:self];
//    if (height>400) {
//        height=400;
//    }else{
//        self.tableView.scrollEnabled = NO;
//    }
//    [self mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.width.equalTo(@290);
//        make.height.mas_equalTo(height);
//        make.centerX.equalTo(keyWindow);
//        make.centerY.equalTo(keyWindow);
//    }];
}
-(void) showFrame:(CGRect)frame{
    UIWindow *keyWindow = [[UIApplication sharedApplication].delegate window];
    _backGroundView = [[UIView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    _backGroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    [keyWindow addSubview:_backGroundView];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissView)];
    [_backGroundView addGestureRecognizer:tap];
    [keyWindow addSubview:self];
    self.frame= frame;
}




-(void) selectedArr:(NSArray *)arr{
    [self.selectArr addObjectsFromArray:arr];
    [self.tableView reloadData];
}


-(void) constructDefaultView{
    self.selectArr = [[NSMutableArray alloc] init];
    
    UILabel *titleLabel = [[UILabel alloc]init];
    titleLabel.text= self.title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    [self addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(10);
        make.right.mas_equalTo(-10);
        make.top.mas_equalTo(10);
        make.size.height.mas_equalTo(kTitleHeight);
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor =color_line;
    [self addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(9.5);
       make.size.height.mas_equalTo(0.5);
    }];
    
    self.tableView = [[UITableView alloc]initWithFrame:self.bounds style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self .tableView registerClass:[FYSelectListCell class] forCellReuseIdentifier:kFYSelectListCellIdentifier];
    self.tableView.rowHeight = kRowHeight;
    [self addSubview:self.tableView ];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(5);
        make.right.mas_equalTo(-5);
        make.top.equalTo(titleLabel.mas_bottom).with.offset(10);
        make.bottom.mas_equalTo(-10);
    }];
    
    if (_isMoreOption) {
        UIButton *sureBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        sureBtn.titleLabel.font = [UIFont systemFontOfSize:12];
        [sureBtn setTitle:@"确定" forState:UIControlStateNormal];
        [sureBtn setTitleColor:[UIColor cyanColor] forState:UIControlStateNormal];
        [sureBtn addTarget:self action:@selector(determine) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:sureBtn];
        [sureBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.size.width.mas_equalTo(50);
            make.right.mas_equalTo(-10);
            make.top.mas_equalTo(10);
            make.size.height.mas_equalTo(25);
        }];
    }else{
        
    }
}

-(void) determine{
    if ([_delegate respondsToSelector:@selector(slectView:selectArr:)]) {
        [_delegate slectView:self selectArr:_selectArr];
    }
    [self dismissView];
}

-(void) dismissView{
    [FYPopupController dissmissPopupView];
//    [_backGroundView removeFromSuperview];
//    _backGroundView = nil;
//    [self removeFromSuperview];
}


#pragma mark - UITableViewDatasource

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.dataArr.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FYSelectListCell *cell = [tableView dequeueReusableCellWithIdentifier:kFYSelectListCellIdentifier forIndexPath:indexPath];
    NSString *str= _dataArr[indexPath.row];
    cell.contentStr = str;
    cell.isSelectOption = [_selectArr containsObject:str];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str= _dataArr[indexPath.row];
    if (_isMoreOption) {
        if ([_selectArr containsObject:str]) {
            [_selectArr removeObject:str];
        }else{
            [_selectArr addObject:str];
        }
        [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        
    }else{
        [_selectArr addObject:str];
        if ([_delegate respondsToSelector:@selector(slectView:selectArr:)]) {
            [_delegate slectView:self selectArr:_selectArr];
        }
        [self dismissView];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
