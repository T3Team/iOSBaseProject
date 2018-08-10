//
//  FYAPIConfiguration.h
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//  请求域名 及 API请求全局配置信息

#import <Foundation/Foundation.h>

@interface FYAPIConfiguration : NSObject

/**
 url请求域名 （实际请求：baseUrl + 拼接url） 网络数据请求域名
 */
@property (nonatomic,strong) NSString *baseUrl;


/**
 H5 界面  域名
 */
@property (nonatomic,strong) NSString *h5Url;

/**
 获取请求域名及配置信息单例

 @return 请求域名及配置信息单例
 */
+ (instancetype)currentConfiguration;

@end
