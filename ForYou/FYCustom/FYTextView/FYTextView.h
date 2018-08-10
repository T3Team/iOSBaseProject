//
//  FYTextView.h
//  NavTestDemo
//
//  Created by marcus on 2017/10/9.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYTextView : UITextView<UITextViewDelegate>
/** 占位文字 */
@property (nonatomic, copy) NSString *placeholder;
/** 占位文字颜色 */
@property (nonatomic, strong) UIColor *placeholderColor;

@property(nonatomic, assign)int limitLength;

@end
