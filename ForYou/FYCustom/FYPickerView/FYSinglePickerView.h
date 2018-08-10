//
//  FYSinglePickerView.h
//  ForYou
//
//  Created by marcus on 2017/9/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//  单选pickerView

#import <UIKit/UIKit.h>
#import "FYHeader.h"

@interface FYSinglePickerView : UIView

/**
 所有数据
 */
@property (nonatomic, strong) NSArray<NSDictionary*> *dataArray;

/**
 当前选中内容
 */
@property (nonatomic, strong) NSDictionary *currentSelected;

/**
 点击取消按钮回调
 */
@property (nonatomic, copy) FYBlock cancelBlock;


/**
 点击确认按钮回调
 */
@property (nonatomic, copy) FYBlock confirmBlock;

@end
