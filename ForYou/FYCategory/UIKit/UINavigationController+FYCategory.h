//
//  UINavigationController+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UINavigationController 分类

#import <UIKit/UIKit.h>

@interface UINavigationController (FYCategory)

/**
 *  获取Nav中是指定类的最顶层控制器
 *
 *  @param targetClass 指定类 Class
 *
 *  @return 指定类的最顶层控制器
 */
- (UIViewController *)getTopViewControllerOfClass:(Class)targetClass;

/**
 *  pop到Nav中指定类的控制器 （Nav中必须包含指定类的控制器,否则无法pop）
 *
 *  @param targetClass 指定类 Class
 *  @param animated    是否需要动画
 *
 *  @return pop后Nav中的控制器数组
 */
- (NSArray<UIViewController*> *)poptoTargetViewControllerOfClass:(Class)targetClass animated:(BOOL)animated;

/**
 *  pop时，略过指定类
 *
 *  @param passClass 指定类 Class
 *  @param animated  是否需要动画
 *
 *  @return pop后Nav中的控制器数组
 */
- (NSArray<UIViewController *> *)popPassViewControllerClass:(Class)passClass animated:(BOOL)animated;

/**
 *  pop时，略过多个指定类
 *
 *  @param passClasses 需要略过的多个指定类 数组
 *  @param animated    是否需要动画
 *
 *  @return pop后Nav中的控制器数组
 */
- (NSArray<UIViewController *> *)popPassViewControllerClasses:(NSArray<Class>*)passClasses animated:(BOOL)animated;

@end
