//
//  FYGuideView.h
//  ForYou
//
//  Created by marcus on 2018/2/7.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FYHeader.h"

@interface FYGuideView : UIView


/**
 构造指引view

 @param view 目标控件
 @param title 标题
 @param image 标题上的图片
 @param toImage 目标控件上的图片
 @param isRound 是否是圆
 @param cornerRadius 圆角或者半径
 @param toFrame 目标位置  如果没传目标控件  需要传此位置
 @return 构造对象
 */

+(instancetype)showGuideViewWithView:(UIView *)view title:(NSString *)title image:(UIImage *)image toImage:(UIImage *)toImage isRound:(BOOL)isRound cornerRadius:(CGFloat)cornerRadius toFrame:(CGRect)toFrame;


/**
 知道了回调
 */
@property (nonatomic , copy)FYBlock knownBlock;


-(void) removeAll;
@end
