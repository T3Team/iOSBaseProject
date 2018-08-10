//
//  FYCalculatorWebVC.h
//  ForYou
//
//  Created by marcus on 2017/9/13.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseViewController.h"

@interface FYBaseH5WebVC : FYBaseViewController<UIWebViewDelegate>
/**
 url 地址 必传
 */
@property (nonatomic, strong) NSString *url;

/**
 自定义title 该值为空时，获取H5里面的title
 */
@property (nonatomic, strong) NSString *customTitle;

-(void)webViewDidFinishLoad:(UIWebView *)webView;


@end
