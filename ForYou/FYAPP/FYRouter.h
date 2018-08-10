//
//  FYRouter.h
//  ForYou
//
//  Created by marcus on 2017/9/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

/*******************************/
//原理：通过分析url中的path参数，或者get参数，组成key-value对象
//     然后，利用运行时动态设置属性
//注意点：路径中的参数是必填的，而且只能是基础类型；
//      对象类型通过parameters传递
//      赋值必须通过属性，成员变量不能直接赋值；
/******************************/

@interface FYRouter : NSObject

+ (instancetype _Nullable )sharedRouter;
- (void)pushViewController:(nullable UIViewController *) viewController;

/**
 替换掉用最后一个vc

 @param viewController 新的vc
 */
- (void)replaceLastViewControllerWithVC:(nullable UIViewController *) viewController;

/**
 根据路径得到对应的目标vc的对象

 @param route 目标vc的路径
 @return 路径对应的vc，如果没有酒返回空
 */
- (id _Nullable )viewControllerFromRoute:(nullable NSString *)route;

/**
 push route对应的view controller

 @param route vc的路径。如果有必填参数，route中必须显示
 */
- (void)openRoute:(nullable NSString *)route;

/**
 push route对应的view controller

 @param route vc的路径。如果有必填参数，route中必须显示
 @param parameters 附加参数，例如对象类型，就必须用parameters 传递
 */
- (void)openRoute:(nullable NSString *)route
   withParameters:(nullable NSDictionary<NSString *, id> *)parameters;

/**
 清空用户信息并跳转到首页
 */
- (void)clearUserInfoAndgotoLogin;

/**
 跳转H5

 @param httpUrlString H5链接
 @param customTitle 自定义title
 @return webVC
 */
- (id)openH5Url:(NSString *_Nullable) httpUrlString customTitle:(NSString *)customTitle;


/**
 跳转到指定界面（推送消息、短信等方式）

 @param type 类型
 @param parameters 参数
 */
- (void)openRouteWithType:(NSString *)type parameters:(NSDictionary *)parameters;

- (void)openQiyu;
@end
