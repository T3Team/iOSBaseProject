//
//  FYPlistManager.h
//  ForYou
//
//  Created by marcus on 2017/8/7.
//  Copyright © 2017年 ForYou. All rights reserved.
//  plist 文件管理

#import <Foundation/Foundation.h>

@interface FYPlistManager : NSObject


/*
 以下涉及的filename都不需要带.plist的后缀, 如果文件名是@"abc.plist",那么传入的参数就是 @"abc"
 所有的plist文件都是在NSLibraryDirectory目录下。
 */

/**
 判断plist文件是否存在

 @param plistFileName 文件名
 @return 文件是否存在
 */
+ (BOOL)isExistWithFileNameInLibrary:(NSString *)plistFileName;


/**
 如果文件不存在的话就新建一个，如果文件已经存在的话，就会删掉已经有的文件重新创建一个
 data只能传NSArray或者NSDictionary
 */

/**
 保存data为plist文件

 @param data 待保存数据（NSArray/NSDictionary）
 @param fileName 文件名
 @return 是否保存成功
 */
+ (BOOL)saveData:(id)data withFileName:(NSString *)fileName;

/**
 保存String为plist文件

 @param string 待保存内容
 @param fileName 文件名
 @return 是否保存成功
 */
+ (BOOL)saveString:(NSString *)string withFileName:(NSString *)fileName;

/** 如果文件不存在的话返回YES */

/**
 删除某个plist文件

 @param fileName 文件名
 @return 是否删除成功
 */
+ (BOOL)deletePlistFile:(NSString *)fileName;

/**
 从plist文件中加载数据

 @param fileName 文件名
 @return 数据内容（NSArray/NSDictionary）
 */
+ (id)loadDataWithFileName:(NSString *)fileName;
/**
 从plist文件中加载字符串

 @param fileName 文件名
 @return 字符串内容
 */
+ (NSString *)loadStringWithFileName:(NSString *)fileName;

@end
