//
//  UIViewController+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "UIViewController+FYCategory.h"

@implementation UIViewController (FYCategory)


+ (UIViewController *)findBestViewController:(UIViewController*)vc
{
    if (vc.presentedViewController) {
        
        // Return presented view controller
        return [UIViewController findBestViewController:vc.presentedViewController];
        
    } else if ([vc isKindOfClass:[UISplitViewController class]]) {
        // Return right hand side
        UISplitViewController* svc = (UISplitViewController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.viewControllers.lastObject];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UINavigationController class]]) {
        // Return top view
        UINavigationController* svc = (UINavigationController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.topViewController];
        else
            return vc;
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        
        // Return visible view
        UITabBarController* svc = (UITabBarController*) vc;
        if (svc.viewControllers.count > 0)
            return [UIViewController findBestViewController:svc.selectedViewController];
        else
            return vc;
        
    } else {
        
        // Unknown view controller type, return last child view controller
        return vc;
        
    }
}

+ (UIWindow *)currentWindow {
    UIWindow *topWindow = [[UIApplication sharedApplication] keyWindow]?:[[UIApplication sharedApplication].delegate window];
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        topWindow = [[UIApplication sharedApplication].delegate window];
    }
    if (topWindow.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(topWindow in windows)
        {
            if (topWindow.windowLevel == UIWindowLevelNormal)
                break;
        }
    }
    return topWindow;
}

+ (UIViewController *)currentViewController
{
    UIWindow *topWindow = [self currentWindow];
    UIViewController* viewController = topWindow.rootViewController;
    return [UIViewController findBestViewController:viewController];
}

@end
