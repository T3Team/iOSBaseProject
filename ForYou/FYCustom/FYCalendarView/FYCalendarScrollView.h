//
//  FYCalendarScrollView.h
//  FYCalendarView
//
//  Created by ForYou on 2017/8/17.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef void (^DidSelectDayHandler)(NSInteger, NSInteger, NSInteger);
@interface FYCalendarScrollView : UIScrollView

@property (nonatomic, strong) UIColor *calendarBasicColor; // 基本颜色
@property (nonatomic, copy) DidSelectDayHandler didSelectDayHandler; // 日期点击回调

- (void)refreshToCurrentMonth; // 刷新 calendar 回到当前日期月份

@property (nonatomic ,strong) NSDate *selectDate;

//-(void)addTrainArrWithArr:(NSArray *)arr;


@end
