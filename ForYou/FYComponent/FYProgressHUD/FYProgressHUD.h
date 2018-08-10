//
//  FYProgressHUD.h
//  ForYou
//
//  Created by marcus on 2017/7/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//  基于MBProgressHUD，封装 提示框显示 类

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import <MBProgressHUD/MBProgressHUD.h>

typedef void (^FYProgressHUDCompletionBlock)();

typedef NS_ENUM(NSInteger, FYProgressHUDMode) {
    /** 饼状加载进度图*/
    FYProgressHUDModePieChart,
    /** 横向加载进度图 */
    FYProgressHUDModeHorizontalBar,
    /** 环形加载进度图 */
    FYProgressHUDModeRingShaped,
};

@interface FYProgressHUD : NSObject

/**
 *  显示正在加载动画,不提示任何状态
 */
+ (void)showLoading;

/**
 显示正在加载动画,不提示任何状态
 
 @param isEnable YES 不能做操作  NO能操作
 */
+ (void)showLoadingEnable:(BOOL)isEnable;

/**
 *  显示正在加载动画,提示状态
 *
 *  @param status 提示文字
 */
+ (void)showLoadingWithStatus:(NSString*)status;

/**
 *  隐藏正在加载动画
 */
+ (void)hideLoading;

/**
 提示信息 无图标仅有提示文字（类似安卓的toast）
 
 @param status 提示内容
 */
+ (void)showToastStatus:(NSString *)status;


/**
 最上层windon显示 提示框 防止键盘遮挡问题
 
 @param status 提示内容
 */
+ (void)topWindonsShowToastStatus:(NSString *)status;


/**
 获得积分提示框
 
 @param pointCount 积分数
 @param status 提示内容
 @param block 提示后回调
 */
+ (void)showPointCount:(NSInteger)pointCount toastStatus:(NSString *)status completionBlock:(FYProgressHUDCompletionBlock)block;


/**
 提示信息 无图标仅有提示文字（类似安卓的toast）
 
 @param status 提示内容
 @param completion 提示后回调
 */
+ (void)showToastStatus:(NSString *)status completionBlock:(FYProgressHUDCompletionBlock)block;

/**
 显示图片及状态提示
 
 @param image 需要显示的图片
 @param status 需要显示的状态
 */
+ (void)showImage:(UIImage*)image status:(NSString*)status;


/**
 显示图片及状态提示
 
 @param image 需要显示的图片
 @param status 需要显示的状态
 @param block 提示后回调
 */
+ (void)showImage:(UIImage*)image status:(NSString*)status completionBlock:(FYProgressHUDCompletionBlock)block;

/**
 提示成功信息
 
 @param status 提示文字
 */
+ (void)showSuccessWithStatus:(NSString*)status;

/**
 提示成功信息
 
 @param status 提示文字
 @param block 提示后回调
 */
+ (void)showSuccessWithStatus:(NSString*)status completionBlock:(FYProgressHUDCompletionBlock)block;

/**
 *  显示加载进度
 *
 *  @param progress 加载进度值 （0-1）
 *  @param mode     加载进度显示模式
 */
+ (void)showProgress:(float)progress mode:(FYProgressHUDMode)mode;

/**
 *  显示加载进度(提示信息)
 *
 *  @param progress 加载进度值 （0-1）
 *  @param mode     加载进度显示模式
 *  @param status   提示信息
 */
+ (void)showProgress:(float)progress mode:(FYProgressHUDMode)mode status:(NSString*)status;

/**
 *  显示加载动画
 *
 *  @param text    动画对应的提示文字
 *  @param gifName 动画文件
 *  @param view    显示的视图
 */
+ (void)show:(NSString *)text gifName:(NSString *)gifName view:(UIView *)view;

/**
 *  显示信息
 *
 *  @param text 信息内容
 *  @param image 图标
 *  @param view 显示的视图
 */
+ (void)show:(NSString *)text image:(UIImage *)image view:(UIView *)view;


/**
 底部弹出提示，3秒持续
 
 @param msg 提示语
 */
+ (void)toastMessgeLightly:(NSString *) msg inView:(UIView *)view Yoffset:(CGFloat) offset;

//debug 模式下 显示错误详情
+ (void)showErrorInfoMessage:(NSError *)error errorCode:(NSInteger)errorCode;

/**
 根据容器view ，构建一个fy样式的loading
 
 @param 显示的视图
 @return 反回一个fy 样式的loading
 */
+ (MBProgressHUD *)fy_loadingHudForView:(UIView *) view;

@end
