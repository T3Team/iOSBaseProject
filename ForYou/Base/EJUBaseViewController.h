//
//  EJUBaseViewController.h
//  FangYou
//
//  Created by 陈震 on 2017/7/18.
//  Copyright © 2017年 陈震. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EJUBaseViewController : UIViewController

- (void)eju_showLoading;
- (void)eju_hideLoading;
- (void)eju_showMessage:(NSString *) message;

@end
