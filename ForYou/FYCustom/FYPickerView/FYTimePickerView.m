//
//  FYTimePickerView.m
//  ForYou
//
//  Created by marcus on 2017/10/10.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYTimePickerView.h"
#import "FYHeader.h"
@interface FYTimePickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@property (nonatomic , strong) UILabel *titleLb;
@end


@implementation FYTimePickerView
-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = color_white;
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

-(void)selectTime:(NSString *)str{
    NSArray *arr = [str componentsSeparatedByString:@":"];
    [_pickerView selectRow:[arr[0] integerValue] inComponent:0 animated:YES];
    [_pickerView selectRow:[arr[1] integerValue] inComponent:1 animated:YES];
    
    
}
-(void)updateTitle:(NSString *)title{
    _titleLb.text = title;
}

#pragma mark pickerview dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component==0) {
        return 24;
    }else if (component ==1){
        return 60;
    }
    return 0;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return  35.f;
    
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return  (ScreenWidth-32)/2;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width/2, 35)];
    text.textAlignment = NSTextAlignmentCenter;
    text.backgroundColor = [UIColor  clearColor];
    text.textColor = color_black3;
    [view addSubview:text];
    if (component==0) {
        text.text = [NSString stringWithFormat:@"%02d",(int)row];
    }else{
        text.text = [NSString stringWithFormat:@"%02d",(int)row];
    }
    return  view;
    
}

-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    NSInteger  hour = [pickerView selectedRowInComponent:0];
    NSInteger min = [pickerView selectedRowInComponent:1];
    
    NSString *time = [NSString stringWithFormat:@"%02d:%02d",(int)hour,(int)min];
    if (self.selectTimeBlock) {
        self.selectTimeBlock(time);
    }
}
- (NSString *)currentSelectedTime {
//    int year = (int)[_minDate dateYear] + (int)[self.pickerView selectedRowInComponent:0];
    int hour = (int)[self.pickerView selectedRowInComponent:0];
    int minute = (int)[self.pickerView selectedRowInComponent:1];
    
    return [NSString stringWithFormat:@"%02d:%02d",hour,minute];
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


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
