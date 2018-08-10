//
//  FYRouter.m
//  ForYou
//
//  Created by marcus on 2017/9/1.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYRouter.h"
#import <MJExtension/MJExtension.h>
#import "FYUserDefaults.h"
#import "FYBaseViewController.h"
#import "FYBaseH5WebVC.h"

static FYRouter *instance = nil;

@interface FYRouter()

@property(nonatomic ,strong) NSDictionary *routeAndVC;
@property(nonatomic ,strong) NSMutableDictionary *urlAndVC;

@property(nonatomic ,copy) NSString *route;

@end

@implementation FYRouter

- (NSDictionary *)routeAndVC{
    if (nil == _routeAndVC) {
        _routeAndVC =
        @{
          /**********************房源相关跳转*****************************/
//          @"/estate/followUpList" : [FYFollowUpListController class],//跟进列表
          
          };
    }
    return _routeAndVC;
}

+ (instancetype)sharedRouter{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self class] new];
    });
    return instance;
}

- (instancetype)init{
    if (self = [super init]) {
        self.urlAndVC = [NSMutableDictionary new];
    }
    return self;
}

#pragma mark private
- (void)_fulfillParameters:(NSDictionary *)parameters toObj:(id) obj{
    for (NSString *key  in parameters.allKeys) {
        NSString *selectorName = [NSString stringWithFormat:@"set%@:",key.mj_firstCharUpper];
        SEL setSelecter = NSSelectorFromString(selectorName);
        if ([obj respondsToSelector:setSelecter]) {
            id value = [parameters objectForKey:key];
            [obj setValue:value forKey:key];
        }
    }
}

#pragma mark public

- (void)pushViewController:(UIViewController *)viewController{
    UINavigationController *nav = [UIViewController currentViewController].navigationController;
    if ((nav==nil) || (![nav isKindOfClass:[UINavigationController class]])) {
        nav = (UINavigationController *)[[UIApplication sharedApplication].delegate window].rootViewController;
    }
    
    //err tip
    NSString *title = @"";
    title = [NSString stringWithFormat:@"温馨提示：%@",self.route];
    if (nav == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络开小差:lack of nav" message:title delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    if(viewController == nil) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络开小差:lack of viewConroller" message:title delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    if (![nav isKindOfClass:[UINavigationController class]]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"网络开小差:lack of nav(type error）" message:title delegate:nil cancelButtonTitle:@"ok" otherButtonTitles:nil];
        [alert show];
    }
    
    if ([nav isKindOfClass:[UINavigationController class]]) {
        [nav pushViewController:viewController animated:YES];
    }
}

- (void)replaceLastViewControllerWithVC:(nullable UIViewController *) viewController{
    if (nil == viewController) {
        return;
    }
    UIViewController *curtrentVC = [FYBaseViewController currentViewController];
    UINavigationController *nav = curtrentVC.navigationController;
    NSMutableArray *vcs = [[NSMutableArray alloc] initWithArray:nav.viewControllers];
    [vcs replaceObjectAtIndex:vcs.count - 1 withObject:viewController];
    [nav setViewControllers:vcs animated:YES];
}

- (void)openRoute:(NSString *)route{
    [self openRoute:route withParameters:nil];
}

- (void)openRoute:(NSString *)route withParameters:(NSDictionary<NSString *,id> *)parameters{
    self.route = route;
    UIViewController *vc = [self.routeAndVC[route] new];
    if (parameters) {
        [self _fulfillParameters:parameters toObj:vc];
    }
    [self pushViewController:vc];
}

- (void)clearUserInfoAndgotoLogin {
//    [FYUserDefaults clearUserInfo];
    UIViewController *curtrentVC = [FYBaseViewController currentViewController];
//    if (![curtrentVC isKindOfClass:[FYLoginViewController class]]) {
//        FYLoginViewController *loginVC = [FYLoginViewController new];
//        loginVC.successBlock = ^() {
//            UITabBarController *rootVC = [FYUserDefaults sharedInstance].isNewHouseAccount?[[FYNHARootVC alloc] init]:[[FYRootViewController alloc] init];
//            UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow]?:[[UIApplication sharedApplication].delegate window];
//            UINavigationController *navOld = (UINavigationController*)topWindow.rootViewController;
//            navOld.viewControllers = @[rootVC];
//        };
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:loginVC];
//        nav.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
//        [curtrentVC presentViewController:nav animated:YES completion:nil];
//    }
}

- (id)openH5Url:(NSString *)httpUrlString customTitle:(NSString *)customTitle{
    FYBaseH5WebVC *webVC = [[FYBaseH5WebVC alloc] init];
    webVC.url = httpUrlString;
    webVC.customTitle = customTitle;
    [self pushViewController:webVC];
    return webVC;
}

- (id _Nullable )viewControllerFromRoute:(nullable NSString *)route{
    Class class = [self.routeAndVC objectForKey:route];
    UIViewController *dstVC = nil;
    if (class) {
        dstVC = [class new];
    }
    return dstVC;
}

/**
 跳转到指定界面（推送消息、短信等方式）
 
 @param type 类型
 @param parameters 参数
 */
- (void)openRouteWithType:(NSString *)type parameters:(NSDictionary *)parameters {
   
}



@end
