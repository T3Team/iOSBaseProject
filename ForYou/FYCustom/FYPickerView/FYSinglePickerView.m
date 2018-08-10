//
//  FYSinglePickerView.m
//  ForYou
//
//  Created by marcus on 2017/9/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSinglePickerView.h"

@interface FYSinglePickerView() <UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic, strong) UIPickerView *pickerView;
@property (nonatomic, strong) UIView *topView;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *confirmButton;
@end

@implementation FYSinglePickerView

-(instancetype)initWithFrame:(CGRect)frame{
    self= [super initWithFrame:frame];
    if (self) {
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
        make.height.equalTo(@44);
    }];
    [_pickerView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_topView.mas_bottom);
        make.bottom.equalTo(self);
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
}

#pragma mark pickerview dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.dataArray.count;
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return  35.f;
    
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
    return  ScreenWidth-32;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }
    UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, 35)];
    text.textAlignment = NSTextAlignmentCenter;
    text.backgroundColor = [UIColor  clearColor];
    text.textColor = color_black3;
    [view addSubview:text];
    if (component==0) {
        text.text = [self.dataArray[row] objectForKey:@"name"];
    }
    return  view;
    
}

- (void)clickCancelButton {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)clickConfirmButton {
    NSInteger currentIndex = [self.pickerView selectedRowInComponent:0];
    _currentSelected = self.dataArray[currentIndex];
    if (self.confirmBlock) {
        self.confirmBlock();
    }
}

- (void)setCurrentSelected:(NSDictionary *)currentSelected {
    if (currentSelected && [self.dataArray containsObject:currentSelected]) {
        NSInteger index = [self.dataArray indexOfObject:currentSelected];
        [self.pickerView selectRow:index inComponent:0 animated:NO];
        _currentSelected = currentSelected;
    }
}

- (void)setDataArray:(NSArray<NSDictionary *> *)dataArray {
    _dataArray = dataArray;
    [self.pickerView reloadAllComponents];
}

@end
