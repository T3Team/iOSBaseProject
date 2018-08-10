//
//  UIImage+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/2.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UIImage 分类

#import <UIKit/UIKit.h>

@interface UIImage (FYCategory)

/**
 字体图标

 @param text 图标名称
 @param size 图标尺寸
 @param color 图标颜色
 @return 字体图标UIImage
 */
+ (UIImage *)iconFontWithText:(NSString *)text size:(NSInteger)size color:(UIColor *)color;

/**
 生成纯色图片

 @param color 颜色
 @param size 尺寸
 @param radius 圆角
 @return 生成后的图片
 */
+ (UIImage *)imageFromColor:(UIColor *)color forSize:(CGSize)size withCornerRadius:(CGFloat)radius;

/**
 * 图片压缩到指定大小
 * @param targetSize 目标图片的大小
 * @param sourceImage 源图片
 * @return 目标图片
 */
+ (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize withSourceImage:(UIImage *)sourceImage;


/**
 对某个图片进行放大（原图尺寸不变，背景用background填充，并放大为 1/scale倍）

 @param image 待处理图片
 @param scale 放大倍率
 @param background 背景色
 @return 处理后的图片
 */
+ (UIImage *)specialScaleImage:(UIImage *)image scale:(CGFloat)scale withBackground:(UIColor *) background;


/**
 颜色变成图片

 @param color
 @return 图片
 */
+ (UIImage *)fy_imageWithColor:(UIColor *)color;

+ (UIImage *)qrImageForString:(NSString *)string imageSize:(CGFloat)Imagesize logoImage:(UIImage*)logoImage logoImageSize:(CGFloat)waterImagesize;
@end
