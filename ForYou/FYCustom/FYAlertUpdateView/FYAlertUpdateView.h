//
//  FYAlertUpdateView.h
//  ForYou
//
//  Created by marcus on 2017/10/12.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FYBlock.h"
typedef NS_ENUM(NSUInteger, FYUpdateType) {
    FYUpdateTypeOption = 0,
    FYUpdateTypeForce = 1
};

@interface FYAlertUpdateView : UIView

/**
 版本升级提示

 @param frame 位置  可以不设置
 @param type 类型 强制还是可选
 @param version 版本
 @param content 内容
 @return 版本更新
 */
+(instancetype)updateViewWithFrame:(CGRect)frame type:(FYUpdateType)type version:(NSString *)version content:(NSString *)content;


/**
 展示
 */
-(void) show;

@end
