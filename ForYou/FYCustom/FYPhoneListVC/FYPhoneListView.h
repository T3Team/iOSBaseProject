//
//  FYPhoneListView.h
//  ForYou
//
//  Created by marcus on 2017/9/8.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBlock.h"
@interface FYPhoneListView : UIView


/**
 创建

 @param phones listPhone
 @return 对象
 */
+(instancetype)listViewWithPhoneArr:(NSArray *)phones;

/**
 选择回调   参数 字符串数字
 */
@property (nonatomic , copy) FYParameterStringBlock selectBlock;

/**
 展示
 */
-(void)showPhoneList;


/**
 初始化之后，可以设置cell的title 颜色， 内部会自动刷新
 */
-(void)setCellContentColor:(UIColor *)cellColor;



@end
