//
//  FYRangeSelectAndInputView.h
//  ForYou
//
//  Created by marcus on 2017/9/25.
//  Copyright © 2017年 ForYou. All rights reserved.
//  范围选择或者输入  View

#import <UIKit/UIKit.h>

@protocol FYRangeSelectAndInputViewDelegate <NSObject>

- (void)rangeSelectAndInputViewWithTitle:(NSString *)title result:(NSString *)result;

@end

@interface FYRangeSelectAndInputView : UIView

- (void)refreshViewWithData:(NSArray *)data title:(NSString *)title hasInput:(BOOL)hasInput selectItemName:(NSString *)selectItemName mustInput:(BOOL)mustInput multiple:(BOOL)multiple;

@property (nonatomic, weak) id<FYRangeSelectAndInputViewDelegate> delegate;

@end
