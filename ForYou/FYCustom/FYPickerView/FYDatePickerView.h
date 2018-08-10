//
//  FYDatePickerView.h
//  ForYou
//
//  Created by marcus on 2017/9/21.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYHeader.h"

typedef void(^SelectDateBlock)(NSDate *date);


@interface FYDatePickerView : UIView

@property (nonatomic , strong) NSDate *minDate;

@property (nonatomic, strong) NSDate *maxDate;

@property (nonatomic , copy)SelectDateBlock selectDateBlock;

-(void)selectDate:(NSDate *)date;


/**
 当前选中日期

 @return 选中日期
 */
- (NSDate *)currentSelectedDate;

/**
 显示 上边的取消/确认 view  默认为NO 不显示
 */
@property (nonatomic, assign) BOOL showTopConfirmView;

/**
 点击取消按钮回调
 */
@property (nonatomic, copy) FYBlock cancelBlock;


/**
 点击确认按钮回调
 */
@property (nonatomic, copy) FYBlock confirmBlock;


/**
 设置title

 @param title title
 */
-(void)updateTitle:(NSString *)title;

@end
