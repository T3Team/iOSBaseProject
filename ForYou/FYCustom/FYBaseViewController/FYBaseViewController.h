//
//  FYBaseViewController.h
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//
//  所有ViewController基类
//
/* ********************使用说明****************************
   1、子类属性配置：hideNavigationBar、fyTitle、hideBackButton 等均应放在viewDidLoad方法中；
   2、子类默认pop到上一个界面，如果需要自定义，重写backButtonAction方法
 
   ********************使用说明****************************  */


#import <UIKit/UIKit.h>
#import "FYNavigationBar.h"
#import "FYHeader.h"
#import "FYDefines.h"

typedef enum : NSUInteger {
    kFYBaseVCNavigationStyleDefalut,
    kFYBaseVCNavigationStyleRed //红色导航 白色返回，白色title，白色状态栏
} FYBaseVCNavigationStyle_t;

@interface FYBaseViewController : UIViewController

/**
 是否隐藏自定义的navigationBar  默认: NO
 */
@property (nonatomic, assign) Boolean hideNavigationBar;

/**
 设置title
 */
@property (nonatomic, strong) NSString *fyTitle;


/**
 是否隐藏返回按钮 默认: NO
 */
@property (nonatomic, assign) Boolean hideBackButton;

/**
 自定义导航条
 */
@property (nonatomic, strong) FYNavigationBar *navigationBar;


/**
 导航条样式
 */
@property (nonatomic, assign) FYBaseVCNavigationStyle_t navigateStyle;


/**
  显示导航条右侧按钮
 
 @param image 按钮图片
 @param title 按钮标题
 @param target target
 @param action action
 */
- (void)showRightButtonWithImage:(UIImage *)image title:(NSString *)title addTarget:(id)target action:(SEL)action;

//以下方法可以根据实际情况 在子类中重写

/**
 第一次即将显示时
 */
- (void)viewWillFirstAppear;

/**
 view第一次显示时加载方法
 */
- (void)viewDidFirstAppear;

/**
 子类可重写该方法，默认为返回上一个界面,重写是不要调用[super backButtonAction]
 */
- (void)backButtonAction;


/**
 刷新界面 子类中需实现刚方法，用于外部刷新界面
 */
- (void)refreshView;

//loading
- (void)fy_showLoading;
- (void)fy_showLoadingIn:(UIView *) view;

- (void)fy_hideLoading;


/**
 中间弹出提示框

 @param msg 提示语
 */
- (void)fy_tipMesage:(NSString *)msg;

/**
 底部弹出提示框
 
 @param msg 提示语
 */
- (void)fy_toastMessge:(NSString *)msg inView:(UIView *) view;

/**
 展示无网络页面

 @param frame 位置
 @param reload 重新加载按钮回调
 */
-(void)showNoneInternetWithFrame:(CGRect)frame reload:(void (^)(void))reload;

/**
 移除无网络页面
 */
-(void)removeNoneInterNetView;

//no data placeholder
@property(nonatomic ,readonly) UIView *noDataPlaceholder;
@property(nonatomic ,readonly) UIImageView *noDataImageView;
@property(nonatomic ,readonly) UILabel *noDatalabel;


/**
 没网络缺省视图
 */
@property (nonatomic , strong) UIView *noneInternetView;

@end
