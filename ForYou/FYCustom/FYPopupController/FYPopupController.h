//
//  FYPopupController.h
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseViewController.h"
#import "FYHeader.h"

typedef void (^FYPopupCompletionBlock)(void);

@interface FYPopupController : FYBaseViewController


/**
 简单调用方式

 @param view 需要弹出的View (最终大小由该View的frame确定)  必须传
 @param style 弹出样式
 */
+ (void)popupView:(UIView *)view popupStyle:(FYPopupStyle)style;


/**
 专业调用方式

 @param view 需要弹出的View (最终大小由该View的frame确定)  必须传
 @param style 弹出样式
 @param backgroundColor 背景色  默认：透明
 @param animateDuration 动画时间  0：则没有动画  默认：0.5
 @param depthSacle 景深缩放比例 0 - 1.0 默认：1.0 不缩放
 @param completion 退出后执行的操作 默认：nil
 */
+ (void)popupView:(UIView *)view popupStyle:(FYPopupStyle)style backgroundColor:(UIColor*)backgroundColor animateDuration:(NSTimeInterval)animateDuration depthSacle:(CGFloat)depthSacle isBackgroundCancel:(BOOL)isBackgroundCancel completion:(FYPopupCompletionBlock)completion;


/**
 popupView隐藏
 */
+ (void)dissmissPopupView;


/**
 popupView隐藏

 @param animation 是否需要隐藏
 @param completion 退出后执行的操作 默认：nil
 */
+ (void)dissmissPopupViewAnimation:(Boolean)animation  completion:(FYPopupCompletionBlock)completion;

@end
