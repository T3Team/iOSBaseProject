//
//  FYCalculatorWebVC.m
//  ForYou
//
//  Created by marcus on 2017/9/13.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYBaseH5WebVC.h"

@interface FYBaseH5WebVC ()
{
    UIWebView *_webView;
    UIButton *backBtn;
    UIButton *closeBtn;
    
}
@end

@implementation FYBaseH5WebVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    if (![NSString isEmpty:self.customTitle]) {
        self.fyTitle = self.customTitle;
    }
    _webView = [[UIWebView alloc] init];
    _webView.scalesPageToFit = YES;
    _webView.delegate = self;
    [self.view addSubview: _webView];
    [_webView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.mas_top).offset(self.hideNavigationBar?0:NavigationHeight);
        make.bottom.equalTo(self.view.mas_bottom).offset(0);
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
    }];
    [FYProgressHUD showLoading];
    NSString * url = [_url copy];
    NSString * token = [FYUserDefaults sharedInstance].accessToken;
    if ([_url containsString:@"?"]) {
        url = [NSString stringWithFormat:@"%@&token=%@", _url, [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }else{
        url = [NSString stringWithFormat:@"%@?token=%@", _url, [token stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
    NSURLRequest * req = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}

- (void)backButtonAction {
    if ([_webView canGoBack]) {
        [_webView goBack];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}
-(void)closeWebView{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [FYProgressHUD hideLoading];
    if ([NSString isEmpty:self.customTitle]) { //没有设置title时，获取title
        NSString *str =[webView stringByEvaluatingJavaScriptFromString:@"document.title"];
        self.fyTitle= str;
        [self.navigationBar updateTitle:str];
    }
    
    if ([webView canGoBack]&&!closeBtn) {
        closeBtn = [UIButton buttonWithType:UIButtonTypeCustom ];
        [closeBtn setImage:[UIImage imageNamed:@"dkjsq_close_36"] forState:UIControlStateNormal];
        
        [closeBtn addTarget:self action:@selector(closeWebView) forControlEvents:UIControlEventTouchUpInside];
        [self.navigationBar addSubview:closeBtn];
        [closeBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.navigationBar.mas_left).offset(45);
            make.bottom.equalTo(self.navigationBar);
            make.height.equalTo(@45);
            make.width.equalTo(@45);
        }];
    }else{
        
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
