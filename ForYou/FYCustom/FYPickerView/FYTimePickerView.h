//
//  FYTimePickerView.h
//  ForYou
//
//  Created by marcus on 2017/10/10.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYHeader.h"
@interface FYTimePickerView : UIView

-(void)selectTime:(NSString *)str;

@property (nonatomic , copy) FYParameterStringBlock selectTimeBlock;

/**
 当前选中日期
 
 @return 选中日期
 */
- (NSString *)currentSelectedTime;

/**
 显示 上边的取消/确认 view  默认为NO 不显示
 */
@property (nonatomic, assign) BOOL showTopConfirmView;

/**
 点击取消按钮回调
 */
@property (nonatomic, copy) FYBlock cancelBlock;



-(void)updateTitle:(NSString *)title;
/**
 点击确认按钮回调
 */
@property (nonatomic, copy) FYBlock confirmBlock;

@end
