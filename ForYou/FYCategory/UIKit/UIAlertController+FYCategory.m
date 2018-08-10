//
//  UIAlertController+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/21.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "UIAlertController+FYCategory.h"
#import "FYHeader.h"
static NSInteger const UIAlertControllerBlocksCancelButtonIndex = 0;
static NSInteger const UIAlertControllerBlocksDestructiveButtonIndex = 1;
static NSInteger const UIAlertControllerBlocksFirstOtherButtonIndex = 2;

@implementation UIAlertController (FYCategory)

+ (instancetype)showInViewController:(UIViewController *)viewController
                           withTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                   cancelButtonTitle:(NSString *)cancelButtonTitle
              destructiveButtonTitle:(NSString *)destructiveButtonTitle
                   otherButtonTitles:(NSArray *)otherButtonTitles
  popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
                            tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:preferredStyle];
    
    __weak UIAlertController *controller = strongController;
    
    
    if (cancelButtonTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:cancelButtonTitle
                                                               style:UIAlertActionStyleCancel
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock) {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        [controller addAction:cancelAction];
    }
    
    if (destructiveButtonTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:destructiveButtonTitle
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action){
                                                                      if (tapBlock) {
                                                                          tapBlock(controller, action, UIAlertControllerBlocksDestructiveButtonIndex);
                                                                      }
                                                                  }];
        [controller addAction:destructiveAction];
    }
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                if (tapBlock) {
                                                                    tapBlock(controller, action, UIAlertControllerBlocksFirstOtherButtonIndex + i);
                                                                }
                                                            }];
        [controller addAction:otherAction];
    }
    
    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(controller.popoverPresentationController);
    }
    
    [viewController presentViewController:controller animated:YES completion:nil];
    
    return controller;
}

+ (instancetype)showAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                        cancelButtonTitle:(NSString *)cancelButtonTitle
                   destructiveButtonTitle:(NSString *)destructiveButtonTitle
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleAlert
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
   popoverPresentationControllerBlock:nil
                             tapBlock:tapBlock];
}

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
                                       tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [self showActionSheetInViewController:viewController
                                       withTitle:title
                                         message:message
                               cancelButtonTitle:cancelButtonTitle
                          destructiveButtonTitle:destructiveButtonTitle
                               otherButtonTitles:otherButtonTitles
              popoverPresentationControllerBlock:nil
                                        tapBlock:tapBlock];
}

+ (instancetype)showActionSheetInViewController:(UIViewController *)viewController
                                      withTitle:(NSString *)title
                                        message:(NSString *)message
                              cancelButtonTitle:(NSString *)cancelButtonTitle
                         destructiveButtonTitle:(NSString *)destructiveButtonTitle
                              otherButtonTitles:(NSArray *)otherButtonTitles
             popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
                                       tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [self showInViewController:viewController
                            withTitle:title
                              message:message
                       preferredStyle:UIAlertControllerStyleActionSheet
                    cancelButtonTitle:cancelButtonTitle
               destructiveButtonTitle:destructiveButtonTitle
                    otherButtonTitles:otherButtonTitles
   popoverPresentationControllerBlock:popoverPresentationControllerBlock
                             tapBlock:tapBlock];
}




+ (instancetype)showInViewController:(UIViewController *)viewController
                           withTitle:(NSString *)title
                             message:(NSString *)message
                      preferredStyle:(UIAlertControllerStyle)preferredStyle
                     leftButtonTitle:(NSString *)leftTitle
                        leftBtnColor:(UIColor *)leftColor
                    rightButtonTitle:(NSString *)rightButtonTitle
                          rightColor:(UIColor *)rightColor
                   otherButtonTitles:(NSArray *)otherButtonTitles
  popoverPresentationControllerBlock:(void(^)(UIPopoverPresentationController *popover))popoverPresentationControllerBlock
                            tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    UIAlertController *strongController = [self alertControllerWithTitle:title
                                                                 message:message
                                                          preferredStyle:preferredStyle];
    if (message) {
        NSMutableAttributedString *messageAttribute = [[NSMutableAttributedString alloc]initWithString:message];
        [messageAttribute addAttribute:NSForegroundColorAttributeName value:color_black3  range:NSMakeRange(0,message.length)];
        [messageAttribute addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:17]range:NSMakeRange(0,message.length)];
        [strongController setValue:messageAttribute forKey:@"attributedMessage"];
    }
    
    
    __weak UIAlertController *controller = strongController;
    
    for (NSUInteger i = 0; i < otherButtonTitles.count; i++) {
        NSString *otherButtonTitle = otherButtonTitles[i];
        
        UIAlertAction *otherAction = [UIAlertAction actionWithTitle:otherButtonTitle
                                                              style:UIAlertActionStyleDefault
                                                            handler:^(UIAlertAction *action){
                                                                if (tapBlock) {
                                                                    tapBlock(controller, action, UIAlertControllerBlocksFirstOtherButtonIndex + i);
                                                                }
                                                            }];
        [controller addAction:otherAction];
    }
    
    if (leftTitle) {
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:leftTitle
                                                               style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction *action){
                                                                 if (tapBlock) {
                                                                     tapBlock(controller, action, UIAlertControllerBlocksCancelButtonIndex);
                                                                 }
                                                             }];
        if ([FYAppContext isHighWithVersion:@"8.4" newVersion:[FYAppContext sharedInstance].osVersion]) { //8.4以上系统
            [cancelAction setValue:leftColor forKey:@"_titleTextColor"];
        }
        [controller addAction:cancelAction];
    }
    
    if (rightButtonTitle) {
        UIAlertAction *destructiveAction = [UIAlertAction actionWithTitle:rightButtonTitle
                                                                    style:UIAlertActionStyleDestructive
                                                                  handler:^(UIAlertAction *action){
                                                                      if (tapBlock) {
                                                                          tapBlock(controller, action, UIAlertControllerBlocksDestructiveButtonIndex);
                                                                      }
                                                                  }];
        if ([FYAppContext isHighWithVersion:@"8.4" newVersion:[FYAppContext sharedInstance].osVersion]) { //8.4以上系统
          [destructiveAction setValue:rightColor forKey:@"_titleTextColor"];
        }
        [controller addAction:destructiveAction];
    }
    
    if (popoverPresentationControllerBlock) {
        popoverPresentationControllerBlock(controller.popoverPresentationController);
    }
    
    [viewController presentViewController:controller animated:YES completion:nil];
    
    return controller;
}



+ (instancetype)showColorAlertInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                          leftButtonTitle:(NSString *)leftButtonTitle
                             leftBtnColor:(UIColor *)leftColor
                         rightButtonTitle:(NSString *)rightButtonTitle
                               rightColor:(UIColor *)rightColor
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [UIAlertController showInViewController:viewController
                                         withTitle:title
                                           message:message
                                    preferredStyle:UIAlertControllerStyleAlert
                                   leftButtonTitle:leftButtonTitle
                                      leftBtnColor:leftColor
                                  rightButtonTitle:rightButtonTitle
                                        rightColor:rightColor
                                 otherButtonTitles:otherButtonTitles
                popoverPresentationControllerBlock:nil
                                          tapBlock:tapBlock ];
}

+ (instancetype)showColorSheetInViewController:(UIViewController *)viewController
                                withTitle:(NSString *)title
                                  message:(NSString *)message
                          leftButtonTitle:(NSString *)leftButtonTitle
                             leftBtnColor:(UIColor *)leftColor
                         rightButtonTitle:(NSString *)rightButtonTitle
                               rightColor:(UIColor *)rightColor
                        otherButtonTitles:(NSArray *)otherButtonTitles
                                 tapBlock:(UIAlertControllerCompletionBlock)tapBlock
{
    return [UIAlertController showInViewController:viewController
                                         withTitle:title
                                           message:message
                                    preferredStyle:UIAlertControllerStyleActionSheet
                                   leftButtonTitle:leftButtonTitle
                                      leftBtnColor:leftColor
                                  rightButtonTitle:rightButtonTitle
                                        rightColor:rightColor
                                 otherButtonTitles:otherButtonTitles
                popoverPresentationControllerBlock:nil
                                          tapBlock:tapBlock ];
}








#pragma mark -

- (BOOL)visible
{
    return self.view.superview != nil;
}

- (NSInteger)cancelButtonIndex
{
    return UIAlertControllerBlocksCancelButtonIndex;
}

- (NSInteger)firstOtherButtonIndex
{
    return UIAlertControllerBlocksFirstOtherButtonIndex;
}

- (NSInteger)destructiveButtonIndex
{
    return UIAlertControllerBlocksDestructiveButtonIndex;
}



@end
