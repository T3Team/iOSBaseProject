//
//  FYRootViewController.h
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FYRootViewController : UITabBarController

- (void)showBadgeOnItemIndex:(int)index;
- (void)hideBadgeOnItemIndex:(int)index;
@end
