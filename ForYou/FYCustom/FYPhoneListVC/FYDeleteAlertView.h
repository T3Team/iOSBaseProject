//
//  FYDeleteAlertView.h
//  ForYou
//
//  Created by marcus on 2017/12/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYHeader.h"
@interface FYDeleteAlertView : UIView

/**
 删除
 */
@property (nonatomic ,copy) FYBlock deleteBlock;

/**
 构造方法

 @param title 内容
 @return 对象
 */
+(instancetype)alertViewWithTitle:(NSString *)title;

/**
 展示
 */
-(void)showView;
@end
