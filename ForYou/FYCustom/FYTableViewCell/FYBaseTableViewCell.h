//
//  FYBaseTableViewCell.h
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//  cell基类

#import <UIKit/UIKit.h>
#import "FYTableViewCellModel.h"
#import "FYHeader.h"

@interface FYBaseTableViewCell : UITableViewCell

@property (nonatomic, weak) FYTableViewCellModel *cellModel;
@property (nonatomic, weak) id dataModel;

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel;


/**
 获得第一相应

 @param tag 标签
 */
- (void)becomeFirstResponderWithTag:(NSString *)tag;


/**
 比输项是否输入  并获取第一响应

 @param become 没有输入时，是否需要获取第一响应
 @return 必输项提示 返回nil时，说明已输入内容
 */
- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become;

@end
