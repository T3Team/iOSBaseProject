//
//  FYDefaultPageView.h
//  ForYou
//
//  Created by marcus on 2017/12/12.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYDefaultPageView : UIView

/**
 缺省页模板

 @param frame 位置
 @param image 图片
 @param text 文字
 @param size 图片大小
 @return 缺省页
 */
-(instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)image text:(NSString *)text imageSize:(CGSize)size;

- (void)updateText:(NSString *)text;


@end
