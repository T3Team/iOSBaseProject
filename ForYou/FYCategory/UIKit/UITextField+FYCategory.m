//
//  UITextField+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/21.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "UITextField+FYCategory.h"
#import <Objc/runtime.h>

@implementation UITextField (FYCategory)
static NSString *kLimitTextLengthKey = @"kLimitTextLengthKey";

- (void)limitTextLength:(int)length

{
    objc_setAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey), [NSNumber numberWithInt:length], OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    
    [self addTarget:self action:@selector(textFieldTextLengthLimit:) forControlEvents:UIControlEventEditingChanged];
    
}

- (void)textFieldTextLengthLimit:(UITextField *)textField{
    NSNumber *maxLengthNumber = objc_getAssociatedObject(self, (__bridge const void *)(kLimitTextLengthKey));
    int maxLen = [maxLengthNumber intValue];
    
    NSString *toBeString = textField.text;
    NSArray *currentar = [UITextInputMode activeInputModes];
    UITextInputMode *current = [currentar firstObject];
    
    //下面的方法是iOS7被废弃的，注释
    //    NSString *lang = [[UITextInputMode currentInputMode] primaryLanguage]; // 键盘输入模式
    
    if ([current.primaryLanguage isEqualToString:@"zh-Hans"]) { // 简体中文输入，包括简体拼音，健体五笔，简体手写
        UITextRange *selectedRange = [textField markedTextRange];
        //获取高亮部分
        UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        if (!position) {
            if (toBeString.length > maxLen) {
                textField.text = [toBeString substringToIndex:maxLen];
            }
        }
        // 有高亮选择的字符串，则暂不对文字进行统计和限制
        else{
            
        }
    }
    // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
    else{
        if (toBeString.length > maxLen) {
            textField.text = [toBeString substringToIndex:maxLen];
        }
    }
    NSLog(@"%@",textField.text);
}
    
@end
