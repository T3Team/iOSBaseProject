//
//  FYBaseWebViewController.m
//  ForYou
//
//  Created by marcus on 2017/8/3.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseWebViewController.h"
#import "FYHeader.h"

@interface FYBaseWebViewController ()


@end

@implementation FYBaseWebViewController
@synthesize webView = _webView;

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view addSubview:self.webView];
    [self viewAddSubviews];
    [self layoutPageSubviews];
}


#pragma mark - public methods
- (void)viewDidFirstAppear {
    [super viewDidFirstAppear];
    
    [self.webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(self.hideNavigationBar?0:NavigationHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(-[self bottomButtonHeight]);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [self reloadWebView];
}

- (NSInteger)bottomButtonHeight {
    return 0;
}

- (void)viewAddSubviews {
    
}

- (void)layoutPageSubviews {
    
}

- (NSString *)addSpecialParameters {
    NSString * url = [_url copy];
    NSString * token = [FYUserDefaults sharedInstance].accessToken;
    if ([self.url containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&token=%@", self.url, [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        url = [NSString stringWithFormat:@"%@?token=%@", self.url, [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] ];
    }
    return url;
}

- (void)reloadWebView {
    [self loadHtmlData];
}


#pragma mark - private methods
- (void)loadHtmlData {
    NSString *htmlUrl = [self addSpecialParameters];
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:htmlUrl]
                                             cachePolicy:NSURLRequestUseProtocolCachePolicy
                                         timeoutInterval:kFYNetworkingTimeoutSeconds];
    [self.webView loadRequest:request];
}

- (UIWebView *)webView
{
    if (_webView == nil) {
        _webView = [[UIWebView alloc] init];
        [_webView setBackgroundColor:[UIColor clearColor]];
        [_webView setOpaque:NO];
    }
    
    return _webView;
}

@end
