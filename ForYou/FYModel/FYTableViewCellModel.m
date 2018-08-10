//
//  FYTableViewCellModel.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYTableViewCellModel.h"
#import "FYBaseTableViewCell.h"

@implementation FYTableViewCellModel

+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className key:(NSString *)key cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit dataModel:(id)dataModel{
    FYTableViewCellModel *model = [[self alloc]init];
    model.cellTitle = title;
    model.cellClassName = className;
    model.cellHeight = cellHeight;
    model.cellTag = tag;
    model.showLine = showLine;
    model.key = key;
    model.useXib = useXib;
    model.canEdit = canEdit;
    FYBaseTableViewCell *cell;
    if (model.useXib) {
        cell = [[[NSBundle mainBundle] loadNibNamed:model.cellClassName owner:self options:0] firstObject];
    }else{
        Class targetClass = NSClassFromString(model.cellClassName);
        cell = [[targetClass alloc] init];
        if (!cell) {
            cell = [[FYBaseTableViewCell alloc] init];
        }
    }
    [cell refreshDataWithTableModel:model dataModel:dataModel];
    model.cell = cell;
    return model;
}

+ (instancetype)cellModelWithTitle:(NSString *)title  cellClassName:(NSString*)className unit:(NSString *)unit placeholder:(NSString *)placeholder key:(NSString *)key type:(FYTableCellType)type cellHeight:(CGFloat)cellHeight showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit dataModel:(id)dataModel{
    FYTableViewCellModel *model = [[self alloc]init];
    model.cellTitle = title;
    model.cellClassName = className;
    model.unit = unit;
    model.placeholder = placeholder;
    model.key = key;
    model.type = type;
    model.cellHeight = cellHeight;
    model.canEdit = canEdit;
    model.showLine = showLine;
    model.useXib = useXib;
    FYBaseTableViewCell *cell;
    if (model.useXib) {
        cell = [[[NSBundle mainBundle] loadNibNamed:model.cellClassName owner:self options:0] firstObject];
    }else{
        Class targetClass = NSClassFromString(model.cellClassName);
        cell = [[targetClass alloc] init];
        if (!cell) {
            cell = [[FYBaseTableViewCell alloc] init];
        }
    }
    [cell refreshDataWithTableModel:model dataModel:dataModel];
    model.cell = cell;
    return model;
}

+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className key:(NSString *)key cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib imageName:(NSString*)imageName canEdit:(Boolean)canEdit dataModel:(id)dataModel {
    FYTableViewCellModel *model = [[self alloc]init];
    model.cellTitle = title;
    model.cellClassName = className;
    model.cellHeight = cellHeight;
    model.cellTag = tag;
    model.showLine = showLine;
    model.key = key;
    model.useXib = useXib;
    model.imageName = imageName;
    model.canEdit = canEdit;
    FYBaseTableViewCell *cell;
    if (model.useXib) {
        cell = [[[NSBundle mainBundle] loadNibNamed:model.cellClassName owner:self options:0] firstObject];
    }else{
        Class targetClass = NSClassFromString(model.cellClassName);
        cell = [[targetClass alloc] init];
        if (!cell) {
            cell = [[FYBaseTableViewCell alloc] init];
        }
    }
    [cell refreshDataWithTableModel:model dataModel:dataModel];
    model.cell = cell;
    return model;
}

+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className key:(NSString *)key cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit mustInput:(Boolean)mustInput lengthMax:(NSInteger)lengthMax dataModel:(id)dataModel{
    FYTableViewCellModel *model = [[self alloc]init];
    model.cellTitle = title;
    model.cellClassName = className;
    model.cellHeight = cellHeight;
    model.cellTag = tag;
    model.showLine = showLine;
    model.key = key;
    model.useXib = useXib;
    model.canEdit = canEdit;
    model.mustInput = mustInput;
    model.lengthMax = lengthMax;
    FYBaseTableViewCell *cell;
    if (model.useXib) {
        cell = [[[NSBundle mainBundle] loadNibNamed:model.cellClassName owner:self options:0] firstObject];
    }else{
        Class targetClass = NSClassFromString(model.cellClassName);
        cell = [[targetClass alloc] init];
        if (!cell) {
            cell = [[FYBaseTableViewCell alloc] init];
        }
    }
    [cell refreshDataWithTableModel:model dataModel:dataModel];
    model.cell = cell;
    return model;
}

+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className unit:(NSString *)unit placeholder:(NSString *)placeholder key:(NSString *)key type:(FYTableCellType)type cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit mustInput:(Boolean)mustInput lengthMax:(NSInteger)lengthMax dataModel:(id)dataModel {
    FYTableViewCellModel *model = [[self alloc]init];
    model.cellTitle = title;
    model.cellClassName = className;
    model.unit = unit;
    model.placeholder = placeholder;
    model.key = key;
    model.type = type;
    model.cellHeight = cellHeight;
    model.canEdit = canEdit;
    model.showLine = showLine;
    model.useXib = useXib;
    model.mustInput = mustInput;
    model.lengthMax = lengthMax;
    model.cellTag = tag;
    FYBaseTableViewCell *cell;
    if (model.useXib) {
        cell = [[[NSBundle mainBundle] loadNibNamed:model.cellClassName owner:self options:0] firstObject];
    }else{
        Class targetClass = NSClassFromString(model.cellClassName);
        cell = [[targetClass alloc] init];
        if (!cell) {
            cell = [[FYBaseTableViewCell alloc] init];
        }
    }
    [cell refreshDataWithTableModel:model dataModel:dataModel];
    model.cell = cell;
    return model;
}

@end
