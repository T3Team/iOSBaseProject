//
//  UIView+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UIView 的分类

#import <UIKit/UIKit.h>

@interface UIView (FYCategory)

/**
 分割线

 @return 分割线
 */
+ (UIView *)fy_seprateLine;

/**
 整个View截图

 @param view 需要截图的View
 @return 截图
 */
+ (UIImage *)convertView:(UIView *)view;


/**
 frame的高度
 */
@property (nonatomic, assign) CGFloat fy_height;

/**
 frame的宽度
 */
@property (nonatomic, assign) CGFloat fy_width;

/**
 frame的x坐标
 */
@property (nonatomic, assign) CGFloat fy_y;

/**
 frame的y坐标
 */
@property (nonatomic, assign) CGFloat fy_x;

@end
