//
//  FYNavigationBar.h
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//  自定义NavigationBar

#import <UIKit/UIKit.h>

@protocol FYNavigationBarDelegate <NSObject>

- (void)navigationBarBackButtonClick;

@end

@interface FYNavigationBar : UIView

@property (nonatomic,weak) id<FYNavigationBarDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;

/**
 右侧Button
 */
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

/**
  获取naigationBar类方法

 @param title nav标题
 @return naigationBar
 */
+ (instancetype)naigationBarWithTitle:(NSString *)title;

/**
 获取naigationBar类方法

 @param title nav标题
 @param color nav颜色
 @return naigationBar
 */
+ (instancetype)naigationBarWithTitle:(NSString *)title backgroundColor:(UIColor *)color;

/**
 更新naigationBar颜色

 @param color 设置颜色
 */
- (void)updateColor:(UIColor *)color;

/**
 设置背景透明度

 @param alpha 透明度(0-1)
 */
- (void)updateAlpha:(CGFloat)alpha;

/**
 更新naigationBar标题

 @param title 设置标题
 */
- (void)updateTitle:(NSString *)title;

/**
 设置返回按钮是否隐藏  默认为NO

 @param hidden 是否隐藏
 */
- (void)setBackButtonHidden:(Boolean)hidden;


/**
 更新title的颜色

 @param titleColor title颜色
 */
-(void)updateTitleColor:(UIColor *)titleColor;

/**
 跟新title的透明度

 @param alpha 透明度 0-1
 */
-(void)updateTitleAlpha:(CGFloat )alpha;


/**
 跟新title的字号大小
 
 @param alpha 透明度 0-1
 */
-(void)updateTitleFont:(CGFloat )font;



@end
