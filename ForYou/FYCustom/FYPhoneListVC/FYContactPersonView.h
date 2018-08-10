//
//  FYContactPersonView.h
//  ForYou
//
//  Created by marcus on 2017/10/13.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBlock.h"
@interface FYContactPersonView : UIView
/**
 创建
 
 @param phones listPhone
 @param nameArr list name
 @return 对象
 */
+(instancetype)contactPersonViewWithPhoneArr:(NSArray *)phones remark:(NSString *)remark  name:(NSString *)name;

/**
 选择回调   参数 字符串数字
 */
@property (nonatomic , copy) FYParameterStringBlock selectBlock;

/**
 展示
 */
-(void)showPhoneList;
@end
