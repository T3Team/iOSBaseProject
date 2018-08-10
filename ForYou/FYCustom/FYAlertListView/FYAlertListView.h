//
//  FYAlertListView.h
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//  弹出选择框

#import <UIKit/UIKit.h>

/**
 点击确认按钮的回调
 */
typedef void(^alertListViewConfirmBlock)(NSInteger);

/**
 点击背景的回调
 */
typedef void(^alertListViewCancelBlock)();

@interface FYAlertListView : UIView

@property (nonatomic,copy) alertListViewConfirmBlock confimBlock;
@property (nonatomic,copy) alertListViewCancelBlock cancelBlock;

/**
 弹出选择框
 
 @param title         选择框主标题
 @param titles        每个选项的标题（该值决定选项数）
 @param descriptions  每个选项的描述
 @return              弹出选项框
 */
+ (FYAlertListView *)alertListViewWithTitle:(NSString *)title optionTitles:(NSArray *)titles optionDescription:(NSArray *)descriptions;

/**
 显示弹出选项框
 */
- (void)show;

@end
