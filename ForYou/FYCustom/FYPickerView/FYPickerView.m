//
//  FYPickerView.m
//  FYPickerView
//
//  Created by ForYou on 2017/8/14.
//  Copyright © 2017年 ForYou. All rights reserved.
//   

#import "FYPickerView.h"
#import "FYPopupController.h"

#define ScreenWidth                         [UIScreen mainScreen].bounds.size.width
#define ScreenHeight                        [UIScreen mainScreen].bounds.size.height

#define kMaxHouseNumber 88

#define kMaxHouseRoomNumber 9


@interface FYPickerView ()<UIPickerViewDelegate,UIPickerViewDataSource>
@property (nonatomic ,strong) NSMutableArray *selectArr;



@property (nonatomic, strong) UIPickerView *pickerView;

@property (nonatomic, strong) UIView *backGroundView;


@end


@implementation FYPickerView

+(instancetype)pickerWithStyle:(FYPickerViewStyle)style selectArr:(NSArray *)selectArr{
    FYPickerView *pickerView = [[FYPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.selectArr = [[NSMutableArray alloc]initWithArray:selectArr];
    pickerView.style = style;
    [pickerView defaultValues];
    return pickerView;
}

+(instancetype)pickerWithStyle:(FYPickerViewStyle)style selectStr:(NSString *)selectStr{
    FYPickerView *pickerView = [[FYPickerView alloc]init];
    pickerView.backgroundColor = [UIColor whiteColor];
    pickerView.style = style;
    pickerView.selectArr = [pickerView configSelect:selectStr];
    [pickerView defaultValues];
    return pickerView;
}

-(NSMutableArray *)configSelect:(NSString *)selectStr{
    if (_style==FYPickerViewStyleFloor) {
        NSString *str = selectStr;
        str = [str stringByReplacingOccurrencesOfString:@"第" withString:@""];
        str = [str stringByReplacingOccurrencesOfString:@"楼共" withString:@","];
        str = [str stringByReplacingOccurrencesOfString:@"楼" withString:@""];
        NSArray *arr =[str componentsSeparatedByString:@","];
        NSMutableArray *arr1 = [@[[NSNumber numberWithInt:[arr[0] intValue]],[NSNumber numberWithInt:[arr[1] intValue]]] mutableCopy];
        return arr1;
        
    }else if (_style==FYPickerViewStyleRoom){
        NSString *str = selectStr;
        str = [str stringByReplacingOccurrencesOfString:@"室" withString:@","];
        str = [str stringByReplacingOccurrencesOfString:@"厅" withString:@","];
        str = [str stringByReplacingOccurrencesOfString:@"卫" withString:@""];
        NSArray *arr =[str componentsSeparatedByString:@","];
        NSMutableArray *arr1 = [@[[NSNumber numberWithInt:[arr[0] intValue]],[NSNumber numberWithInt:[arr[1] intValue]],[NSNumber numberWithInt:[arr[2] intValue]]] mutableCopy];
        return arr1;
    }
        return nil;
}

-(void)defaultValues{
   
    self.leftBtn = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 30)];
    [self.leftBtn addTarget:self action:@selector(dismissAction) forControlEvents:UIControlEventTouchUpInside];
    [self.leftBtn        setTitle:@"取消" forState:UIControlStateNormal];
    [self.leftBtn        setTitleColor:[UIColor   darkGrayColor] forState:UIControlStateNormal];
    [self  addSubview:self.leftBtn];
    self.rightBtn = [[UIButton alloc]initWithFrame:CGRectMake(ScreenWidth-80, 5, 60, 30)];
    [self.rightBtn addTarget:self action:@selector(sureAction) forControlEvents:UIControlEventTouchUpInside];
    [self.rightBtn         setTitle:@"确定" forState:UIControlStateNormal];
    [self.rightBtn         setTitleColor:[UIColor  darkGrayColor] forState:UIControlStateNormal];
    [self             addSubview: self.rightBtn];
    _pickerView = [[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, ScreenWidth, 200)];
    _pickerView.backgroundColor = [UIColor  whiteColor];
    _pickerView.delegate = self;
    _pickerView.dataSource = self;
    [self addSubview:self.pickerView];
    [self pickerSelect];
}

-(void)pickerSelect{
    if (_style==FYPickerViewStyleFloor) {
        [_pickerView   selectRow:[_selectArr[0] intValue]-1 inComponent:1 animated:NO];
        [_pickerView   selectRow:[_selectArr[1]  intValue]-1  inComponent:4 animated:NO];
    }else if (_style==FYPickerViewStyleRoom){
        [_pickerView   selectRow:[_selectArr[0] intValue]-1 inComponent:0 animated:NO];
        [_pickerView   selectRow:[_selectArr[1]  intValue]  inComponent:2 animated:NO];
        [_pickerView   selectRow:[_selectArr[2] intValue]   inComponent:4 animated:NO];
    }
}

-(void)show{
    self.frame = CGRectMake(0, ScreenHeight-240, ScreenWidth, 240);
     [FYPopupController popupView:self popupStyle:FYPopupStyleBottom];
    
}

#pragma mark - UIButton Touch
-(void)dismissAction{
    [FYPopupController dissmissPopupView];
    
}
-(void)sureAction{
    
    if (self.delegate&& [self.delegate respondsToSelector:@selector(fy_pickerView:selectArr:)]) {
        [self.delegate  fy_pickerView:self selectArr:_selectArr];
    }
    [self dismissAction];
}




-(NSInteger)floorPickerView:(UIPickerView *)pickerView numberofRowInComponent:(NSInteger)component{
    if (_style == FYPickerViewStyleFloor) {
        if (component==0) {
            return  1;
        }else if (component==1){
            return  kMaxHouseNumber;
        }else if (component==2){
            return  1;
        }else if (component==3){
            return 1;
        }else if (component==4){
            return  kMaxHouseNumber;
        }else{
            return 1;
        }

    }else if (_style == FYPickerViewStyleRoom) {
        if (component==0) {
            return  kMaxHouseRoomNumber;
        }else if (component==1){
            return  1;
        }else if (component==2){
            return  kMaxHouseRoomNumber+1;
        }else if (component==3){
            return 1;
        }else if (component==4){
            return  kMaxHouseRoomNumber+1;
        }else{
            return 1;
        }
        
    }
    return 0;
    
}

- (UIView *)fy_pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    if (!view){
        view = [[UIView alloc]init];
    }

    if (_style == FYPickerViewStyleFloor) {
        if (component==0) {
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth/6-10, 30)];
            text.textAlignment = NSTextAlignmentRight;
            text.backgroundColor = [UIColor  clearColor];
            text.text = @"第";
            [view addSubview:text];
            return view;
        }else if (component==1){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/6, 30)];
            text.textAlignment = NSTextAlignmentCenter;
            text.backgroundColor = [UIColor  clearColor];
            text.font = [UIFont systemFontOfSize:18.f];
            text.text =[NSString stringWithFormat:@"%li",row+1];
            [view addSubview:text];
            return view;
        }else if (component==2){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, ScreenWidth/6-10, 30)];
            text.textAlignment = NSTextAlignmentLeft;
            text.backgroundColor = [UIColor  clearColor];
            text.text = @"楼";
            [view addSubview:text];
            return view;
        }else if (component==3){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth/6-10, 30)];
            text.textAlignment = NSTextAlignmentRight;
            text.backgroundColor = [UIColor  clearColor];
            text.text = @"共";
            [view addSubview:text];
            return view;
        }else if (component==4){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, ScreenWidth/6, 30)];
            text.textAlignment = NSTextAlignmentCenter;
            text.backgroundColor = [UIColor  clearColor];
            text.font = [UIFont systemFontOfSize:18.f];
            text.text = [NSString stringWithFormat:@"%li",row+1];
            [view addSubview:text];
            return view;
        }else if (component==5){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, ScreenWidth/6-10, 30)];
            text.textAlignment = NSTextAlignmentLeft;
            text.backgroundColor = [UIColor  clearColor];
            text.text = @"楼";
            [view addSubview:text];
            return view;
        }

        
    }else if (_style == FYPickerViewStyleRoom) {
        if (component==0) {
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth/8, 30)];
            text.textAlignment = NSTextAlignmentCenter;
            text.font = [UIFont systemFontOfSize:18.f];
            text.text = [NSString stringWithFormat:@"%li",row+1];
            [view addSubview:text];
            return view;
        }else if (component==1){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, ScreenWidth/8-10, 30)];
            text.textAlignment = NSTextAlignmentLeft;
            text.text = @"室";
            [view addSubview:text];
            return view;
        }else if (component==2){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, ScreenWidth/8, 30)];
            text.textAlignment = NSTextAlignmentCenter;
            text.font = [UIFont systemFontOfSize:18.f];
            text.text = [NSString stringWithFormat:@"%li",row];
            [view addSubview:text];
            return view;
        }else if (component==3){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(-10, 0, ScreenWidth/8-10, 30)];
            text.textAlignment = NSTextAlignmentLeft;
            text.text = @"厅";
            [view addSubview:text];
            return view;
        }else if (component==4){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(-20, 0, ScreenWidth/8, 30)];
            text.textAlignment = NSTextAlignmentCenter;
            text.font = [UIFont systemFontOfSize:18.f];
            text.text = [NSString stringWithFormat:@"%li",row];
            [view addSubview:text];
            return view;
        }else if (component==5){
            UILabel *text = [[UILabel alloc]initWithFrame:CGRectMake(-20, 0, ScreenWidth/8-10, 30)];
            text.textAlignment = NSTextAlignmentLeft;
            text.text = @"卫";
            [view addSubview:text];
            return view;
        }

    }
    return nil;
}


-(void)fy_pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    if (_style == FYPickerViewStyleFloor) {
        if (component==1) {
            [_selectArr replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:row+1]];
            
        }
        if (component==4) {
            
            [_selectArr replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:row+1]];
        }

    }else if (_style == FYPickerViewStyleRoom){
        if (component==0) {
            
            [_selectArr replaceObjectAtIndex:0 withObject:[NSNumber numberWithInteger:row+1]];
        }
        if (component==2) {
            
            [_selectArr replaceObjectAtIndex:1 withObject:[NSNumber numberWithInteger:row]];
        }
        if (component==4) {
            
            [_selectArr replaceObjectAtIndex:2 withObject:[NSNumber numberWithInteger:row]];
        }
    }
    
    
}



#pragma mark pickerview dataSource
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 6;
}
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    
   return  [self floorPickerView:pickerView numberofRowInComponent:component];
}

- (CGFloat)pickerView:(UIPickerView *)pickerView rowHeightForComponent:(NSInteger)component{
    
    return  30.f;
    
}
- (CGFloat) pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
   return  ScreenWidth/6;
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    
    return [self fy_pickerView:pickerView viewForRow:row forComponent:component reusingView:view];
    
}

-(void)pickerView:(UIPickerView*)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
   
    
    
    
    [self fy_pickerView:pickerView didSelectRow:row inComponent:component];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
