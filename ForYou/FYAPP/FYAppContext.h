//
//  FYAppContext.h
//  ForYou
//
//  Created by marcus on 2017/8/2.
//  Copyright © 2017年 ForYou. All rights reserved.
//  设备、App、网络 等相关信息

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FYAppContext : NSObject


+ (instancetype)sharedInstance;

/**
 设备名称
 */
@property (nonatomic, copy, readonly) NSString *model;

/**
 系统名称
 */
@property (nonatomic, copy, readonly) NSString *os;

/**
 系统版本
 */
@property (nonatomic, copy, readonly) NSString *osVersion;

/**
 Bundle版本
 */
@property (nonatomic, copy, readonly) NSString *appVersion;

/**
 是否有可用网络
 */
@property (nonatomic, readonly) BOOL isReachable;

/**
 网络
 */
@property (nonatomic, copy, readonly) NSString *net;


/**
 状态栏高度
 */
@property (nonatomic, assign) CGFloat statusBarHeight;

/**
 navigationBar 高度 (包含状态栏)
 */
@property (nonatomic, assign) CGFloat navigationHeight;

/**
 tabBar 高度
 */
@property (nonatomic, assign) CGFloat tabBarHeight;


/**
 底部间隙 iPhoneX:34  其他设备:0
 */
@property (nonatomic, assign) CGFloat bottomMargin;

//newVersion 是否比 version 版本高
+ (BOOL)isHighWithVersion:(NSString *)version newVersion:(NSString *)newVersion;
@end
