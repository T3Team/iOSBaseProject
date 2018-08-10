//
//  FYCalendarMonth.h
//  FYCalendarView
//
//  Created by ForYou on 2017/8/17.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYCalendarMonth : NSObject

/**
  传入的 NSDate 对象，该 NSDate 对象代表当前月的某一日，根据它来获得其他数据
 */
@property (nonatomic, strong) NSDate *monthDate; @property (nonatomic, assign) NSInteger totalDays;

/**
 标示第一天是星期几（0代表周日，1代表周一，以此类推）
 */
@property (nonatomic, assign) NSInteger firstWeekday;

/**
 所属年份
 */
@property (nonatomic, assign) NSInteger year;

/**
 当前月份
 */
@property (nonatomic, assign) NSInteger month;

- (instancetype)initWithDate:(NSDate *)date;
@end
