//
//  TableModel.m
//  FangYou
//
//  Created by marcus on 2017/8/15.
//  Copyright © 2017年 FangYou. All rights reserved.
//

#import "FYTableModel.h"

@implementation FYTableModel

+ (instancetype)tableModelWithTitle:(NSString *)title unit:(NSString *)unit placeholder:(NSString *)placeholder key:(NSString *)key type:(FYTableCellType)type cellHeight:(CGFloat)cellHeight {
    FYTableModel *tableModel = [[FYTableModel alloc]init];
    tableModel.title = title;
    tableModel.unit = unit;
    tableModel.placeholder = placeholder;
    tableModel.key = key;
    tableModel.type = type;
    tableModel.cellHeight = cellHeight;
    return tableModel;
}

@end
