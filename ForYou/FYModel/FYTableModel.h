//
//  TableModel.h
//  FangYou
//
//  Created by marcus on 2017/8/15.
//  Copyright © 2017年 FangYou. All rights reserved.
//  管理Cell渲染的Model

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYTableCellType) {
    FYTableCellTypeString,
    FYTableCellTypeNumber
};

@interface FYTableModel : NSObject

/**
 cell标题
 */
@property (nonatomic, copy) NSString *title;
/**
 单位
 */
@property (nonatomic, copy) NSString *unit;
/**
 占位符
 */
@property (nonatomic, copy) NSString *placeholder;
/**
 表单对应的字段
 */
@property (nonatomic, copy) NSString *key;
/**
 cell类型 输入类型,文本，数字等
 */
@property (nonatomic, assign) FYTableCellType type;
/**
 cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;


/**
 tableModel初始化类方法

 @param title cell标题
 @param unit 单位
 @param placeholder 占位符
 @param key 表单对应的字段
 @param type cell类型 输入类型，选择类型
 @param cellHeight cell高度
 @return tableModel
 */
+ (instancetype)tableModelWithTitle:(NSString *)title unit:(NSString *)unit placeholder:(NSString *)placeholder key:(NSString *)key type:(FYTableCellType)type cellHeight:(CGFloat)cellHeight;


@end
