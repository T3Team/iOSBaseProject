//
//  FYDictionaryManager.h
//  ForYou
//
//  Created by marcus on 2017/8/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FYDictionaryManager : NSObject


/**
 数据字典单例

 @return 数据字典单例
 */
+ (instancetype)sharedInstance;


/**
 更新全局数据字典
 */
- (void)updateData;

/**
 通过value取对应的name

 @param value value值
 @param array 查找的数组
 @return 对应的name
 */
+ (NSString *)nameWithValue:(NSNumber *)value data:(NSArray *)data;

/**
 通过name取对应的value

 @param name name值
 @param array 查找的数组
 @return 对应的name
 */
+ (NSNumber *)valueWithName:(NSString *)name data:(NSArray *)data;

/**
 通过title取对应数组  不是全量的需要的自己添加

 @param title 例如 房本年限 可获取 houseAgeList 数组
 @return 数据字典数组
 */
- (NSArray *)arrayWithTitle:(NSString *)title;

/**
 国籍

 @return 国籍 数组
 */
- (NSArray *)nationalityList;

/**
 学历

 @return 学历 数组
 */
- (NSArray *)educationList;

@end
