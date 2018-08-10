//
//  UITextField+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/21.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (FYCategory)


/**
 限定textField的输入字数

 @param length 限制的输入内容长度
 */
- (void)limitTextLength:(int)length;


@end
