//
//  EJUBaseViewController.m
//  FangYou
//
//  Created by 陈震 on 2017/7/18.
//  Copyright © 2017年 陈震. All rights reserved.
//

#import "EJUBaseViewController.h"
#import "MBProgressHUD.h"

static NSInteger kEJUBaseHudTag = 13170;

@interface EJUBaseViewController ()

@end

@implementation EJUBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark
- (void)eju_hideLoading{
    MBProgressHUD *hud = [self.view viewWithTag:kEJUBaseHudTag];
    [hud hide:YES];
}

- (void)eju_showLoading{
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    hud.tag = kEJUBaseHudTag;
    hud.mode = MBProgressHUDModeAnnularDeterminate;
    hud.labelText = @"Loading";
    [hud show:YES];
}

- (void)eju_showMessage:(NSString *)message{
    MBProgressHUD *hud = [self.view viewWithTag:kEJUBaseHudTag];
    if (!hud) {
        hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        hud.tag = kEJUBaseHudTag;
    }
    hud.mode = MBProgressHUDModeText;
    hud.labelText = message;
    [hud show:YES];
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
