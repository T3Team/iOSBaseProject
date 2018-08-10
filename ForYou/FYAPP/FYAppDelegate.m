//
//  FYAppDelegate.m
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAppDelegate.h"
#import "FYRootViewController.h"
#import "FYHeader.h"
#import <IQKeyboardManager/IQKeyboardManager.h>
#import "FYDefines.h"
#import "FYAppContext.h"
#import "FYAlertListView.h"
#import "FYFirstComeInViewController.h"


@interface FYAppDelegate()

@property(nonatomic, strong)NSString * deviceTokenNew;

@end

@implementation FYAppDelegate

#pragma mark -  lifecycle
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    NSDictionary * dic = [launchOptions mutableCopy];
    void (^gotoRootVC)() = ^{
        FYAppContext *appContext = [FYAppContext sharedInstance];
        appContext.navigationHeight = kDevice_Is_iPhoneX ? 88.0 : 64.0;
        appContext.statusBarHeight = kDevice_Is_iPhoneX ? 44.0 : 20.0;
        appContext.tabBarHeight = kDevice_Is_iPhoneX ? 83.0 : 49.0;
        appContext.bottomMargin = kDevice_Is_iPhoneX ? 34.0 : 0.0;
        if ([FYAppContext isHighWithVersion:[FYUserDefaults sharedInstance].showComeInVersion newVersion:[FYAppContext sharedInstance].appVersion]) {
            //第一次启动
            __weak typeof(self) weakSelf = self;
            FYFirstComeInViewController*vc = [[FYFirstComeInViewController alloc]init];
            vc.finishBlock = ^() {
//                if ([NSString isEmpty:[FYUserDefaults sharedInstance].accessToken]){
//                    [[FYRouter sharedRouter] clearUserInfoAndgotoLogin];
//                    [weakSelf configuration:launchOptions];
//                }else {
                    [weakSelf defaultRootAndConfiguration:launchOptions];
//                }
            };
           UINavigationController * nav = [[UINavigationController alloc] initWithRootViewController:vc];
            [nav setNavigationBarHidden:YES animated:NO];
            self.window.rootViewController = nav;
            [FYUserDefaults sharedInstance].showComeInVersion = [FYAppContext sharedInstance].appVersion;
        }else {
            [self defaultRootAndConfiguration:dic];
        }
        
        [self.window makeKeyAndVisible];
        [self setupFrameworksWithApplication:application options:launchOptions];
    };
    
//    选择测试服务器
//    [self setDebugDomain:gotoRootVC];
    gotoRootVC();
    return YES;
}

- (void)defaultRootAndConfiguration:(NSDictionary *)launchOptions {
    UITabBarController *rootVC = [[FYRootViewController alloc] init];
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:rootVC];
    [nav setNavigationBarHidden:YES animated:NO];
    self.window.rootViewController = nav;
    [self configuration:launchOptions];
    [self updateDictionaryAndPermission];
}


- (void)applicationWillResignActive:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeMessageMyPoint object:nil];
}


- (void)applicationDidEnterBackground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kEnterBackground object:nil];
}


- (void)applicationWillEnterForeground:(UIApplication *)application {
    [[NSNotificationCenter defaultCenter] postNotificationName:kEnterForeground object:nil];
    [self updateDictionaryAndPermission];
}


- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}


- (void)applicationWillTerminate:(UIApplication *)application {
    
}
    
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url options:(NSDictionary<UIApplicationOpenURLOptionsKey,id> *)options{

    NSString *messageStr = [[url absoluteString] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if ([messageStr containsString:@"ForYou://"]) {
        NSMutableDictionary *dic = [NSDictionary getURLParameters:messageStr];
        NSString *parametersStr = [dic objectForKey:@"app"];
        if (parametersStr && ![NSString isEmpty:parametersStr]) {
            NSDictionary * pushDic = [NSDictionary dictionaryWithJsonString:parametersStr];
            NSString *messageType = [pushDic objectForKey:@"messageType"];
            NSDictionary *parameters = [pushDic objectForKey:@"parameters"];
            [[FYRouter sharedRouter] openRouteWithType:messageType parameters:parameters];
        }
    }

    return YES;
}
    
- (BOOL)application:(UIApplication *)app openURL:(NSURL *)url sourceApplication:(nullable NSString *)sourceApplication annotation:(nonnull id)annotation{
    return YES;
}

#pragma mark - private methods
/**
 Debug模式下配置测试环境
 
 @param block 配置环境后的回调
 */
- (void)setDebugDomain:(void(^)(void))block {
#ifdef DEBUG
    FYAPIConfiguration *apiConfiguration = [FYAPIConfiguration currentConfiguration];
    //默认为测试环境
    apiConfiguration.baseUrl = @"http://172.1.1.1";
    apiConfiguration.h5Url = @"http://172.1.1.1";
    UIViewController *vc = [[UIViewController alloc]init];
    self.window.rootViewController = vc;
    [self.window makeKeyAndVisible];
    NSArray *titles = @[@"测试环境",@"生产环境"];
    NSArray *descriptions = @[@"http://172.1.1.1",@"https://baidu.com"];

    FYAlertListView *alertListView =
    [FYAlertListView alertListViewWithTitle:NSLocalizedString(@"SelectServerConfiguration",nil) optionTitles: titles optionDescription:descriptions];
    [alertListView setConfimBlock:^(NSInteger index){
        switch (index) {
            case 0:
                apiConfiguration.baseUrl = @"http://10.122.136.4:58080";
                apiConfiguration.h5Url = @"http://10.122.136.4:51001/";
                break;
            case 1:
                apiConfiguration.baseUrl = @"https://baidu.com";
                apiConfiguration.h5Url = @"https://baidu.com/";
                break;

            default:
                break;
        }
        block();
    }];
    [alertListView setCancelBlock:^(){
        block();
    }];
    [alertListView show];
#else
    block();
#endif
}

/**
 优先级最高的全局配置或初始化
 */
- (void)configuration:(NSDictionary *)launchOptions{
  
}

//更新权限及数据字典 等全局信息
- (void)updateDictionaryAndPermission {
 
}

/**
 三方库配置及初始化
 */
- (void)setupFrameworksWithApplication:(UIApplication *)application options:(NSDictionary *)launchOptions {
//  IQKeyboardManager 初始化
    IQKeyboardManager *keyboardManager = [IQKeyboardManager sharedManager];
    keyboardManager.shouldShowToolbarPlaceholder= NO;
}

#pragma mark --- UMSDKDelegate
- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken
{
    FYLog(@"注册推送成功");

}


- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(nonnull NSError *)error{
    FYLog(@"注册推送失败");
}


//iOS10以下使用这个方法接收通知
- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo
{

}


@end
