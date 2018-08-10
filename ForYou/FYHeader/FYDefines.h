//
//  FYDefines.h
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//  所有宏定义 配置信息 及 账号信息定义

#ifndef FYDefines_h
#define FYDefines_h

//log format
#if DEBUG
#define FYLog(fmt, ...)                     NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#define FYLog(fmt, ...)
#endif

#define ScreenWidth                         [UIScreen mainScreen].bounds.size.width        //屏幕宽度
#define ScreenHeight                        [UIScreen mainScreen].bounds.size.height       //屏幕高度
#define NavigationHeight                    [FYAppContext sharedInstance].navigationHeight //导航栏高度
#define TabBarHeight                        [FYAppContext sharedInstance].tabBarHeight     //tabBar高度
#define StatusBarHeight                     [FYAppContext sharedInstance].statusBarHeight  //状态栏高度
#define BottomMargin                        [FYAppContext sharedInstance].bottomMargin     //底部留白  iPhoneX 34 其他为0

#define kDevice_Is_iPhoneX       ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO)
//弹出显示框 显示时间
#define kPROGRESS_HUD_DELAY     1.0f

//字体图标文件
#define kFontName               @"iconfont"

//chat
#define kFYChatAppKey           @"zero0#funu"
#define kFYChatUnifiedPassword  @"110110"

#ifdef DEBUG
   #define kFYChatAPNSName      @"APNSDev"
#else
   #define kFYChatAPNSName      @"APNSProduct"
#endif


//网络请求超时时间设置
static NSTimeInterval kFYNetworkingTimeoutSeconds = 20.0f;

//短信验证码时间间隔
static NSInteger kERPinTimeInterval               = 60;

//房源户型图、实景图总张数限制
#define kMaxImagesCount       50

//常量
#define kFYNoNetworkTip @"网络异常中断"

//破图
#define kFYNoNetworkImageListPlaceHolder @"list_default"

#define kPageSize 10

//time
#define kFYDefaultTimeFormat @"yyyy-MM-dd HH:mm:ss"

//单例
// .h文件中的声明
#define SYInstanceH(name)  + (instancetype)shared##name;

// .m文件的实现
#define SYInstanceM(name) static id _instance; \
\
+ (instancetype)allocWithZone:(struct _NSZone *)zone\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[super allocWithZone:zone] init];\
});\
return _instance;\
}\
\
+ (instancetype)shared##name\
{\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
_instance = [[self alloc] init];\
});\
return _instance;\
}\
\
- (id)copyWithZone:(NSZone *)zone\
{\
return _instance;\
}


#endif /* FYDefines_h */
