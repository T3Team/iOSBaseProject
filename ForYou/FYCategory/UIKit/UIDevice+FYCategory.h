//
//  UIDevice+FYCategory.h
//  ForYou
//
//  Created by marcus on 2017/8/2.
//  Copyright © 2017年 ForYou. All rights reserved.
//  UIDevice 分类

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSUInteger, UIDeviceFamily) {
    UIDeviceFamilyiPhone,
    UIDeviceFamilyiPod,
    UIDeviceFamilyiPad,
    UIDeviceFamilyAppleTV,
    UIDeviceFamilyUnknown,
};

@interface UIDevice (FYCategory)


/**
 内部生产代号

 @return 内部名称
 */
- (NSString *)modelIdentifier;


/**
 商品名称

 @return 商品名称
 */
- (NSString *)modelName;


/**
 设备类别

 @return 设备类别
 */
- (UIDeviceFamily)deviceFamily;


/**
 //changes only on system reset, this is the best replacement to the good old udid (persistent to device)
 @return deviceID
 */
- (NSString *)deviceID;

- (BOOL)isIphoneXSeries;

@end
