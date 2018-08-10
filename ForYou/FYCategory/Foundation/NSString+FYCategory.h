//
//  NSString+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/**
 * NSStringCheckPhoneNumberLevelAccurate,  // 精确匹配手机号
 * NSStringCheckPhoneNumberLevelRough,     // 粗略匹配手机号，满足 1xxxxxxxxxxxx即可
 * NSStringCheckPhoneNumberLevelLandline,  // 匹配固定电话，
 */
typedef enum : NSUInteger {
    NSStringCheckPhoneNumberLevelAccurate,
    NSStringCheckPhoneNumberLevelRough,
    NSStringCheckPhoneNumberLevelLandline,
} NSStringCheckPhoneNumberLevel;

@interface NSString (FYCategory)


/**
 楼层级别
 
 @param floorCount 总楼层
 @param currentFloor 当前楼层
 @return 楼层级别
 */
+(NSString *)floorLevelWithFloorCount:(int)floorCount currentFloor:(int)currentFloor;




/**
 判断字符串是否为空

 @param string 字符串
 @return 是否为空
 */
+ (BOOL)isEmpty:(NSString *)string;


/**
 字符串去掉首尾空格

 @param string 待处理字符串
 @return 处理后的字符串
 */
+ (NSString *)trim:(NSString *)string;


/**
 *  验证电话号码
 *
 *  @param level 匹配规则
 *
 *  @return 是否符合要求
 */
- (BOOL)isValidatePhoneNumberWithLevel:(NSStringCheckPhoneNumberLevel)level;

/**
 *  对字符串进行MD5加密
 *
 *  @return MD5加密后的字符串
 */
- (NSString *)encryptUseMD5;

/**
 *  将字符串转为16进制整数
 *
 *  @return 转换后的16进制整数
 */
- (NSInteger)hexIntegerValue;

/**
 *  DES 加密
 *
 *  @param key 加密解密的key
 *
 *  @return 经过DES加密后字符串
 */
- (NSString *)encryptUseDESWithKey:(NSString *)key;

/**
 *  DES 解密
 *
 *  @param key 加密解密的key
 *
 *  @return 解密后的字符串
 */
- (NSString *)decryptUseDESWithKey:(NSString *)key;

/**
 *  文本数据转成16进制字符串
 *
 *  @param data 待转换的文本数据
 *
 *  @return 16进制的字符串
 */
+ (NSString *)convertDataToHexStr:(NSData *)data;

/**
 *  16进制字符串转为文本数据
 *
 *  @param str 16进制的字符串
 *
 *  @return 待转换的文本数据
 */
+ (NSData *)convertHexStrToData:(NSString *)str;

/**
 计算字符串的像素长度

 @param str 字符串
 @param font 字体
 @return 长度
 */
- (CGFloat)stringLengthWithFont:(UIFont *)font;


/**
 计算字符串的高度

 @param font 字体
 @param maxWidth 最大宽度
 @return 文字高度
 */
- (CGFloat)heightWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth;

/**
 计算字符串在某个范围内的size

 @param font 字体
 @param scopeSize 控制范围
 @return 实际尺寸
 */
- (CGSize)sizeWithFont:(UIFont *)font inScopeOfSize:(CGSize)scopeSize;


/**
 MD5加密

 @return MD5加密后的字符串
 */
- (NSString *)MD5;


/**
   属性字体

 @param strArr 要变的字体数组   与fonts  、colorArr 一致
 @param colorArr 颜色
 @param fonts 字体大小
 @return 返回一个拼接好的属性字体
 */
+(NSMutableAttributedString *)attributeWithstrings:(NSArray *)strArr colorArr:(NSArray *)colorArr fonts:(NSArray *)fonts;


/**
 校验是否为数字

 @param number 带校验字符
 @return 校验结果
 */
+ (BOOL)validateNumber:(NSString*)number;

/**
 校验是否为数字和小数点
 
 @param number 带校验字符
 @return 校验结果
 */
+ (BOOL)validateDecimalsNumber:(NSString*)number;


/**
 拨打电话功能

 @param phone 电话号码
 */
+ (void)callPhone:(NSString *)phone;


/**
 发短信
 @param phone 电话号码
 */
+ (void)smsPhone:(NSString *)phone;

/**
 电话号码校验  0 或者 1 开头  0开头11、12位 1开头11位

 @param phone 需校验的电话
 @return 是否为电话号码
 */
+ (BOOL)phoneVerify:(NSString *)phone;


/**
 电话号码校验 1开头11位
 
 @param phone 需校验的电话
 @return 是否为电话号码
 */
+ (BOOL)phoneOnlyMobileVerify:(NSString *)phone;


/**
 输入电话号码校验  0 或者 1 开头  0开头11、12位以下 1开头11位以下
 
 @param phone 需校验的电话
 @return 是否可输入
 */
+ (BOOL)inputPhoneVerify:(NSString *)phone;

/**
 两位小数限制

 @param text 已有字符串
 @param string 待增加字符串
 @param string 整数位数限制
 @return 是否允许输入
 */
+ (BOOL)inputDecimalsVerify:(NSString *)text string:(NSString *)string rang:(NSRange)range lenthMax:(NSInteger)lenthMax;


/**
 返回压缩图片url
 
 @param url 原图片url字符串
 @return width height  压缩大小
 */
+ (NSString *)urlWithCompressWidth:(NSInteger)width height:(NSInteger)height origralUrlString:(NSString *)url;


/**
 截取字符串前部分的有效数字部分

 @param str 带截取的字符串
 @return 有效数字部分
 */
+ (NSString *)frontDecimalsWithString:(NSString*)str;

@end
