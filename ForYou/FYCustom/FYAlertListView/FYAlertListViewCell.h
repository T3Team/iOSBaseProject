//
//  FYAlertListCellTableViewCell.h
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYAlertListViewCell : UITableViewCell

/**
 cell赋值

 @param title 选项标题
 @param description 选项描述
 */
- (void)reloadCellWithTitle:(NSString *)title description:(NSString *)description;

@end
