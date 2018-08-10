//
//  FYDatePickerView.m
//  ForYou
//
//  Created by marcus on 2017/9/21.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYDatePickerView.h"
#import "FYHeader.h"
@interface FYDatePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic , strong) UILabel *titleLb;


@end

@implementation FYDatePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        _maxDate = [NSDate getDateWithyyyyMMddStr:@"2120-12-31"];
        _minDate = [NSDate getDateWithyyyyMMddStr:@"1910-01-01"];
        self.backgroundColor =color_white;
        [self createView];
    }
    return self;
}

-(void)createView{
    _pickerView = [[UIPickerView alloc]init];
    _pickerView.backgroundColor = [UIColor  whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    _topView = [[UIView alloc]init];
    _topView.backgroundColor = color_gray_f6f6f6;
    _topView.clipsToBounds = YES;
    [self addSubview:_topView];
    [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(@0);
    }];
    [_pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(kDevice_Is_iPhoneX?-BottomMargin:0);
        make.left.equalTo(self);
        make.right.equalTo(self);
    }];
    _cancelButton = [[UIButton alloc]init];
    [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [_cancelButton setTitleColor:color_blue_00a0e9 forState:UIControlStateNormal];
    _cancelButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_cancelButton addTarget:self action:@selector(clickCancelButton) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_cancelButton];
    _confirmButton = [[UIButton alloc]init];
    [_confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    [_confirmButton setTitleColor:color_blue_00a0e9 forState:UIControlStateNormal];
    _confirmButton.titleLabel.font = [UIFont systemFontOfSize:15];
    [_confirmButton addTarget:self action:@selector(clickConfirmButton) forControlEvents:UIControlEventTouchUpInside];
    [_topView addSubview:_confirmButton];
    [_cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_topView.mas_left);
        make.top.equalTo(_topView.mas_top);
        make.bottom.equalTo(_topView.mas_bottom);
        make.width.equalTo(@60);
    }];
    [_confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(_topView.mas_right);
        make.top.equalTo(_topView.mas_top);
        make.bottom.equalTo(_topView.mas_bottom);
        make.width.equalTo(@60);
    }];
    _titleLb = [UILabel new];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.font = [UIFont systemFontOfSize:15];
    _titleLb.textColor = color_black6;
    [_topView addSubview:_titleLb];
    [_titleLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(_cancelButton.mas_right);
        make.top.equalTo(_topView.mas_top);
        make.bottom.equalTo(_topView.mas_bottom);
        make.right.equalTo(_confirmButton.mas_left);
    }];
}

-(void)updateTitle:(NSString *)title{
    _titleLb.text = title;
}

-(void)selectDate:(NSDate *)date{
    if (!date) {
        date = [NSDate date];
    }
    [_pickerView selectRow:[date dateYear] - [_minDate dateYear] inComponent:0 animated:NO];
    [_pickerView selectRow:[date dateMonth]-1 inComponent:1 animated:NO];
    [_pickerView selectRow:[date dateDay]-1 inComponent:2 animated:NO];
//    [_pickerView reloadComponent:2];
}

-(NSInteger)numberOFCompone{
    NSInteger count = [_maxDate dateYear] - [_minDate dateYear];
    if (count<0) {
        return 0;
    }else{
        return count+1;
    }
}

-(NSInteger)numberOfDay{
    int year = (int)[_minDate dateYear] + (int)[self.pickerView selectedRowInComponent:0];
    int month = (int)[self.pickerView selectedRowInComponent:1]+1;
    NSDate *date = [NSDate getDateWithyyyyMMddStr:[NSString stringWithFormat:@"%04d-%02d-15",year,month]];
    FYLog(@"%d ------------%d",year,month);
    return [date totalDaysInMonth];
}

#pragma mark pickerview dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return [self numberOFCompone];
    }else if (component ==1){
        return 12;
    }else{
        return  [self numberOfDay];
    }
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    return  35.f;
}

- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    return  (ScreenWidth-32)/3;
}

- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/3, 35)];
    text.textAlignment = NSTextAlignmentCenter;
    text.backgroundColor = [UIColor  clearColor];
    text.textColor = color_black3;
    [view addSubview:text];
    if (component==0) {
        text.text = [NSString stringWithFormat:@"%i",(int)[_minDate dateYear] + (int)row];
    }else{
        text.text = [NSString stringWithFormat:@"%i",(int)row+1];
    }
    return  view;
}

-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    int year = (int)[_minDate dateYear] + (int)[self.pickerView selectedRowInComponent:0];
    int month = (int)[self.pickerView selectedRowInComponent:1]+1;
    int day = (int)[self.pickerView selectedRowInComponent:2]+1;
    NSDate *date =[NSDate getDateWithyyyyMMddStr:[NSString stringWithFormat:@"%04d-%02d-%02d",year,month,day]];
    [pickerView reloadComponent:2];
    if([date isEarlierThanDate:_minDate]){
        [self selectDate:_minDate];
    }
    
    if ([_maxDate isEarlierThanDate:date]) {
        [self selectDate:_maxDate];
    }
    if (self.selectDateBlock) {
        self.selectDateBlock(date);
    }
}

- (NSDate *)currentSelectedDate {
    int year = (int)[_minDate dateYear] + (int)[self.pickerView selectedRowInComponent:0];
    int month = (int)[self.pickerView selectedRowInComponent:1]+1;
    int day = (int)[self.pickerView selectedRowInComponent:2]+1;
    NSDate *date = [NSDate getDateWithyyyyMMddStr:[NSString stringWithFormat:@"%04d-%02d-%02d",year,month,day]];
    if([date isEarlierThanDate:_minDate]){
        return _minDate;
    }
    
    if ([_maxDate isEarlierThanDate:date]) {
        return _maxDate;
    }
    return date;
}

- (void)setShowTopConfirmView:(BOOL)showTopConfirmView {
    [_topView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.top.equalTo(self);
        make.height.equalTo(showTopConfirmView?@44:@0);
    }];
    _showTopConfirmView = showTopConfirmView;
}

- (void)clickCancelButton {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)clickConfirmButton {
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

@end
