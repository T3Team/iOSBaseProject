//
//  FYBaseWebViewController.h
//  ForYou
//
//  Created by marcus on 2017/8/3.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseViewController.h"

@interface FYBaseWebViewController : FYBaseViewController

@property (nonatomic, readonly) UIWebView *webView;

/**
 url 地址 必传
 */
@property (nonatomic, strong) NSString *url;

//以下方法可以根据实际情况 在子类中重写

/**
 *  底部有按钮的情况下，需要重写该方法
 *
 *  @return 返回底部按钮的高度
 */
- (NSInteger)bottomButtonHeight;

/**
 *  子类中需要增加view
 */
- (void)viewAddSubviews;

/**
 *  子类中需要增加view的界面布局代码
 */
- (void)layoutPageSubviews;

/**
 *  在url中加入参数, 某些特殊情况需要可重写该方法 （例如：需要传入登录信息的url可以在此方法中加入登录后的相关信息）
 *
 *  @return 已加入过特殊参数的url
 */
- (NSString *)addSpecialParameters;

/**
 *  界面重载
 */
- (void)reloadWebView;

@end
