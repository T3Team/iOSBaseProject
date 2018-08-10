//
//  NSDictionary+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (FYCategory)

- (NSDictionary *)dictionaryWithCleanNSNullValue;

/**
 *  把格式化的JSON格式的字符串转换成字典
 *
 *  @param jsonString jsonString JSON格式的字符串
 *
 *  @return 返回字典
 */
+ (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString;


/**
 解析url String中的参数

 @param urlStr 待解析的url String
 @return 参数字典
 */
+ (NSMutableDictionary *)getURLParameters:(NSString *)urlStr;

@end
