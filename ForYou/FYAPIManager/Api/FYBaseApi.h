//
//  FYBaseApi.h
//  ForYou
//
//  Created by marcus on 2017/9/12.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <YTKNetwork/YTKNetwork.h>
#import "FYHeader.h"

@interface FYBaseApi : YTKRequest

@property (nonatomic, readonly) NSDictionary<NSString *,NSString *> * _Nonnull headerFields;
@property (assign) BOOL needsTokenHeaderField;//default is Yes

@property (nonatomic, assign) BOOL hideLoading;       //隐藏loading  默认NO
@property (nonatomic, assign) BOOL hideErrorMessage;  //隐藏错误信息   默认NO

/**
 网络请求  自动处理 loading、错误信息  使用hideLoading和hideErrorMessage 属性

 @param success 网络请求成功回调
 */
- (void)fyStartWithCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success;


/**
 网络请求 不处理 loading 及 错误信息

 @param success 网络请求成功回调
 @param failure 网络请求失败回调
 */
- (void)fyStartWithCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success
                                    failure:(nullable YTKRequestCompletionBlock)failure;



/**
 网络请求 自己处理错误信息

 @param success 网络请求成功回调
 @param failure 网络请求失败回调
 */
- (void)fy_DetailStartWithCompletionBlockWithSuccess:(nullable YTKRequestCompletionBlock)success
                                             failure:(nullable YTKRequestCompletionBlock)failure;


/**
 校验code

 @param code code
 @return 是否成功
 */
+ (BOOL)verifyCode:(NSInteger)code;
- (BOOL)isVerifided;

- (void)cancel;


@end

@interface FYBaseApi(override)


/**
 默认返回必要的http header
 如果needsTokenHeaderField = NO ,不会添加Authorization头

 @return http header
 */
- (NSDictionary<NSString *,NSString *> *_Nullable)requestHeaderFieldValueDictionary;

@end

@interface FYBaseApi(QueryParameter)

/**
 queryParameter,是用来实现：在非get方法中，query的参数添加
 如果实现了这个方法 用fy_requestUrl 替换requestUrl
 @return query 的参数
 */
- (NSDictionary *_Nullable)queryParameter;


/**
 相对默认的requestUrl方法，这个方法实现后，会自动添加query 参数逻辑
 !注意：requestUrlToBeAddQueryParameter 和 requestUrl 不能同时实现
 @return requestUrl
 */
- (NSString *_Nullable)requestUrlToBeAddQueryParameter;

/**
给指定的urlpath 添加url上的query参数 ；？分割
 URL参数源自-queryParameter 方法的实现
 @param 原始的没有query参数的url
 @return 带有query参数的url
 */
- (NSString *_Nonnull)urlPathByAppendQueryParameterToUrlPath:(NSString *_Nonnull)urlPath;

/**
 子类重写该方法 设置api的版本号

 @return api的版本
 */
- (NSString *)apiVersion;

@end
