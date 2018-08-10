//
//  FYPickerView.h
//  FYPickerView
//
//  Created by ForYou on 2017/8/14.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 类型选择

 - FYPickerViewStyleFloor: 楼层选择器
 - FYPickerViewStyleRoom: 户型选择器
 */
typedef NS_ENUM(NSUInteger, FYPickerViewStyle) {
    FYPickerViewStyleFloor,
    FYPickerViewStyleRoom,
};
@class FYPickerView;

@protocol FYPickerViewDelegate <NSObject>

/**
 按确认键返回选中的值

 @param pickerView 选择器
 @param selectArr 选择的楼层或者户型  格式 @[@1,@2,@3]
 */
-(void)fy_pickerView:(FYPickerView *)pickerView selectArr:(NSArray*)selectArr;
@end


@interface FYPickerView : UIView

@property(nonatomic,strong) UIButton *leftBtn;
@property(nonatomic,strong) UIButton *rightBtn;

/**
 构造一个PickerView

 @param style 样式
 @param selectArr 选择的楼层或者户型  格式 @[@1,@2,@3]
 @return pickerView
 */
+(instancetype)pickerWithStyle:(FYPickerViewStyle)style selectArr:(NSArray *)selectArr;


/**
 根据字符串构造PickerView

 @param style 样式
 @param selectStr 选择的楼层 格式例如 第1楼共10楼
 @return pickerView
 */
+(instancetype)pickerWithStyle:(FYPickerViewStyle)style selectStr:(NSString *)selectStr;
-(void)show;

/**
 样式
 */
@property (nonatomic , assign) FYPickerViewStyle style;

@property (nonatomic ,weak) id<FYPickerViewDelegate> delegate;

@end
