//
//  UIScrollView+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/4.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UIScrollView的分类

#import <UIKit/UIKit.h>

@interface UIScrollView (FYCategory)


/**
 添加房友自定义下拉刷新头

 @param block 下拉刷新回调
 */
- (void)addFYGifHeaderWithBlock:(void (^)())block;

/**
 添加房友自定义下拉刷新头

 @param target 目标
 @param action 事件
 */
- (void)addFYGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action;

/**
 添加房友自定义上拉刷新尾

 @param target 目标
 @param action 事件
 */
- (void)addFYGifFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action;


/**
 标准下拉样式

 @param block block description
 */
- (void)addStandardFooterWithRefreshBlock:(void (^)())block;

/**
 新房上啦加载

 @param block 回调
 */
- (void)newHouse_addStandardFooterWithRefreshBlock:(void (^)())block;
@end
