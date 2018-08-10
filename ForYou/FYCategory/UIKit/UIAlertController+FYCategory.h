//
//  UIAlertController+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/21.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UIAlertController 分类

#import <UIKit/UIKit.h>

typedef void (^UIAlertControllerPopoverPresentationControllerBlock) (UIPopoverPresentationController * __nonnull popover);
typedef void (^UIAlertControllerCompletionBlock) (UIAlertController * __nonnull controller, UIAlertAction * __nonnull action, NSInteger buttonIndex);

@interface UIAlertController (FYCategory)


/**
 弹出确认框 (两个按钮横向显示，三个及以上则纵向显示)

 @param viewController 控制器
 @param title 标题
 @param message 内容
 @param cancelButtonTitle 取消按钮title
 @param destructiveButtonTitle 按钮title(红色文字显示)
 @param otherButtonTitles 其他按钮title
 @param tapBlock 点击按钮回调
 @return UIAlertController实例
 */
+ (nonnull instancetype)showAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                           destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;


/**
 sheet弹出框

 @param viewController 控制器
 @param title 标题
 @param message 显示内容
 @param cancelButtonTitle 取消按钮title
 @param destructiveButtonTitle 按钮title(红色文字显示)
 @param otherButtonTitles 其他按钮title
 @param popoverPresentationControllerBlock 显示前回调
 @param tapBlock 点击回调
 @return UIAlertController实例
 */
+ (nonnull instancetype)showActionSheetInViewController:(nonnull UIViewController *)viewController
                                              withTitle:(nullable NSString *)title
                                                message:(nullable NSString *)message
                                      cancelButtonTitle:(nullable NSString *)cancelButtonTitle
                                 destructiveButtonTitle:(nullable NSString *)destructiveButtonTitle
                                      otherButtonTitles:(nullable NSArray *)otherButtonTitles
                     popoverPresentationControllerBlock:(nullable UIAlertControllerPopoverPresentationControllerBlock)popoverPresentationControllerBlock
                                               tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;



/**
 alert弹出框设置button 颜色

 @param viewController 指定弹出的控制器
 @param title 标题
 @param message 内容
 @param leftButtonTitle 左边的title
 @param leftColor 左边的颜色
 @param rightButtonTitle 右边的title
 @param rightColor 右边的颜色
 @param tapBlock 按钮返回方法
 @param otherButtonTitles 另外的btn
 @return 弹出框
 */
+ (nonnull instancetype)showColorAlertInViewController:(nonnull UIViewController *)viewController
                                        withTitle:(nullable NSString *)title
                                          message:(nullable NSString *)message
                                  leftButtonTitle:(nullable NSString *)leftButtonTitle
                                     leftBtnColor:(nullable UIColor *)leftColor
                                 rightButtonTitle:(nullable NSString *)rightButtonTitle
                                       rightColor:(nullable UIColor *)rightColor
                                otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                         tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;


/**
 alert弹出框设置button 颜色
 
 @param viewController 指定弹出的控制器
 @param title 标题
 @param message 内容
 @param leftButtonTitle 左边的title
 @param leftColor 左边的颜色
 @param rightButtonTitle 右边的title
 @param rightColor 右边的颜色
 @param tapBlock 按钮返回方法
 @param otherButtonTitles 另外的btn
 @return 弹出框
 */
+ (nonnull instancetype)showColorSheetInViewController:(nonnull UIViewController *)viewController
                                             withTitle:(nullable NSString *)title
                                               message:(nullable NSString *)message
                                       leftButtonTitle:(nullable NSString *)leftButtonTitle
                                          leftBtnColor:(nullable UIColor *)leftColor
                                      rightButtonTitle:(nullable NSString *)rightButtonTitle
                                            rightColor:(nullable UIColor *)rightColor
                                     otherButtonTitles:(nullable NSArray *)otherButtonTitles
                                              tapBlock:(nullable UIAlertControllerCompletionBlock)tapBlock;


@property (readonly, nonatomic) BOOL visible;
@property (readonly, nonatomic) NSInteger cancelButtonIndex;
@property (readonly, nonatomic) NSInteger firstOtherButtonIndex;
@property (readonly, nonatomic) NSInteger destructiveButtonIndex;

@end
