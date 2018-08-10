//
//  UIViewController+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UIViewController 分类

#import <UIKit/UIKit.h>

@interface UIViewController (FYCategory)


/**
 当前最顶部的控制器

 @return 当前最顶部的控制器
 */
+ (UIViewController *)currentViewController;


/**
 当前最顶部的window

 @return window
 */
+ (UIWindow *)currentWindow;

@end
