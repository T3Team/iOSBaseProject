//
//  FYTableViewCellModel.h
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//  TableCell 模型

#import "FYBaseModel.h"
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, FYTableCellType) {
    FYTableCellTypeString,   //字符
    FYTableCellTypeNumber,   //数字
    FYTableCellTypePhone,    //电话 手机或固话
    FYTableCellTypeDecimals  //两位小数
};

typedef BOOL(^FYModelValueChangeBlock)(void);

@interface FYTableViewCellModel : FYBaseModel

/**
 标题
 */
@property (nonatomic, strong) NSString *cellTitle;

/**
 cell赋值
 */
@property (nonatomic, strong) NSString *value;

/**
 cell类名
 */
@property (nonatomic, strong) NSString *cellClassName;

/**
 cell高度
 */
@property (nonatomic, assign) CGFloat cellHeight;

/**
 当前的cell
 */
@property (nonatomic, strong) UITableViewCell *cell;

/**
 是否用Xib创建cell
 */
@property (nonatomic, assign) Boolean useXib;


/**
 tag (对于不同的cell 作用不同，为辅助某些功能的值)
 */
@property (nonatomic, assign) NSInteger cellTag;

/**
 是否显示分割线
 */
@property (nonatomic, assign) Boolean showLine;

//用于创建基础的cell，输入/点击单个cell使用
/**
 单位
 */
@property (nonatomic, copy) NSString *unit;

/**
 占位符
 */
@property (nonatomic, copy) NSString *placeholder;

/**
 对应的字段key
 */
@property (nonatomic, copy) NSString *key;

/**
 cell类型 输入类型,文本，数字等
 */
@property (nonatomic, assign) FYTableCellType type;

/**
 是否可以编辑 
 */
@property (nonatomic, assign) Boolean canEdit;

/**
 是否必填 默认为NO
 */
@property (nonatomic, assign) Boolean mustInput;

/**
 长度限制  0时不做限制  小数时，该值为整数位限制，小数位默认两位
 */
@property (nonatomic, assign) NSInteger lengthMax;

/**
 cell 值变化回调 Block
 */
@property (nonatomic, copy) FYModelValueChangeBlock valueChangeBlock;

/**
 图片名称
 */
@property (nonatomic, strong) NSString *imageName;

/**
 tableModel初始化类方法

 @param title cell标题
 @param className cell类名
 @param key 表单对应的字段
 @param cellHeight cell高度
 @param tag tag标识
 @param showLine 是否显示分割线
 @param useXib 是否用Xib
 @param canEdit 是否可以修改
 @param dataModel 数据模型
 @return tableModel
 */
+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className key:(NSString *)key cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit dataModel:(id)dataModel;

/**
 tableModel初始化类方法

 @param title cell标题
 @param className cell类名
 @param unit 单位
 @param placeholder 占位符
 @param key 表单对应的字段
 @param type cell类型 输入类型，选择类型
 @param cellHeight cell高度
 @param showLine 否显示分割线
 @param useXib 是否用Xib
 @param canEdit 是否可编辑
 @param dataModel 数据模型
 @return tableModel
 */
+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className unit:(NSString *)unit placeholder:(NSString *)placeholder key:(NSString *)key type:(FYTableCellType)type cellHeight:(CGFloat)cellHeight showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit dataModel:(id)dataModel;

/**
 tableModel初始化类方法
 
 @param title cell标题
 @param className cell类名
 @param key 表单对应的字段
 @param cellHeight cell高度
 @param tag tag标识
 @param showLine 是否显示分割线
 @param useXib 是否用Xib
 @param imageName 图片名称
 @param canEdit 是否可编辑
 @param dataModel 数据模型
 @return tableModel
 */
+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className key:(NSString *)key cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib imageName:(NSString*)imageName canEdit:(Boolean)canEdit dataModel:(id)dataModel;


/**
 tableModel初始化类方法
 
 @param title cell标题
 @param className cell类名
 @param key 表单对应的字段
 @param cellHeight cell高度
 @param tag tag标识
 @param showLine 是否显示分割线
 @param useXib 是否用Xib
 @param canEdit 是否可以修改
 @param mustInput 是否必须输入
 @param lengthMax 长度限制
 @param dataModel 数据模型
 @return tableModel
 */
+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className key:(NSString *)key cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit mustInput:(Boolean)mustInput lengthMax:(NSInteger)lengthMax dataModel:(id)dataModel;

/**
 tableModel初始化类方法
 
 @param title cell标题
 @param className cell类名
 @param unit 单位
 @param placeholder 占位符
 @param key 表单对应的字段
 @param type cell类型 输入类型，选择类型
 @param cellHeight cell高度
 @param showLine 否显示分割线
 @param useXib 是否用Xib
 @param canEdit 是否可编辑
 @param mustInput 是否必须输入
 @param lengthMax 长度限制
 @param dataModel 数据模型
 @return tableModel
 */
+ (instancetype)cellModelWithTitle:(NSString *)title cellClassName:(NSString*)className unit:(NSString *)unit placeholder:(NSString *)placeholder key:(NSString *)key type:(FYTableCellType)type cellHeight:(CGFloat)cellHeight cellTag:(NSInteger)tag showLine:(Boolean)showLine useXib:(Boolean)useXib canEdit:(Boolean)canEdit mustInput:(Boolean)mustInput lengthMax:(NSInteger)lengthMax dataModel:(id)dataModel;

@end
