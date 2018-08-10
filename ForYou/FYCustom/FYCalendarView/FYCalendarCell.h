//
//  FYCalendarCell.h
//  FYCalendarView
//
//  Created by ForYou on 2017/8/17.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYCalendarCell : UICollectionViewCell
@property (nonatomic, strong) UIView *todayCircle; //!< 标示'今天'
@property (nonatomic, strong) UILabel *todayLabel; //!< 标示日期（几号）

@property (nonatomic ,strong) UIView *backView;//今天之前的背景

@property (nonatomic , strong) UIImageView *selectImage; //选中时的图片



@end
