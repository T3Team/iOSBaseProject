//
//  FYRootViewController.m
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYRootViewController.h"
#import "FYHeader.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "FYBaseViewController.h"
#import "FYHomeVC.h"

@interface FYRootViewController ()<UITabBarControllerDelegate>

@end

@implementation FYRootViewController

#pragma mark - view lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self respondsToSelector:@selector(setFd_prefersNavigationBarHidden:)])
    {
        self.fd_prefersNavigationBarHidden = YES;
    }
    [self loadTabBarSubViews];
}

#pragma mark - private method
/**
  设置tabbar上的ViewController
 */
- (void)loadTabBarSubViews {
    
    FYHomeVC *homeVC = [[FYHomeVC alloc] init];
    homeVC.hideNavigationBar = YES;
    FYBaseViewController *vc2 = [[FYBaseViewController alloc] init];
    vc2.view.backgroundColor = [UIColor grayColor];
    vc2.hideNavigationBar = YES;
    FYBaseViewController *vc3 = [[FYBaseViewController alloc] init];
    vc3.view.backgroundColor = [UIColor grayColor];
    vc3.hideNavigationBar = YES;

    self.viewControllers = @[homeVC,vc2,vc3];
    
    UITabBarItem *tabBarItem0 = [self.tabBar.items objectAtIndex:0];
    UITabBarItem *tabBarItem1 = [self.tabBar.items objectAtIndex:1];
    UITabBarItem *tabBarItem2 = [self.tabBar.items objectAtIndex:2];


    [self tabBarItem:tabBarItem0 title:NSLocalizedString(@"Workbench", nil) image:[icon_tab_workbench imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[icon_tab_workbenchSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
        [self tabBarItem:tabBarItem1 title:@"统计" image:[icon_tab_estateList imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[icon_tab_estateListSelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    [self tabBarItem:tabBarItem2 title:NSLocalizedString(@"My", nil) image:[icon_tab_my imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] selectedImage:[icon_tab_mySelect imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal]];
    
    self.tabBar.backgroundColor = color_white;
    self.tabBar.tintColor = color_red_ea4c40;
    [[UITabBar appearance] setBarTintColor:color_white];
    [UITabBar appearance].translucent = NO;
    [self dropShadowWithOffset:CGSizeMake(0, -1)
                        radius:2
                         color:[UIColor blackColor]
                       opacity:0.08];
    
    self.selectedIndex = 0;
}

/**
 *  设置tabBarItem相关属性
 *
 *  @param tabBarItem    需要设置的tabBarItem
 *  @param title         tabBarItem 标题
 *  @param image         tabBarItem 默认图
 *  @param selectedImage tabBarItem 选中图
 */
- (void)tabBarItem:(UITabBarItem *)tabBarItem title:(NSString *)title image:(UIImage *)image selectedImage:(UIImage *)selectedImage {
    tabBarItem.title = title;
    tabBarItem.image = image;
    tabBarItem.selectedImage = selectedImage;
}

- (void)dropShadowWithOffset:(CGSize)offset
                      radius:(CGFloat)radius
                       color:(UIColor *)color
                     opacity:(CGFloat)opacity {
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, self.tabBar.bounds);
    self.tabBar.layer.shadowPath = path;
    CGPathCloseSubpath(path);
    CGPathRelease(path);
    
    self.tabBar.layer.shadowColor = color.CGColor;
    self.tabBar.layer.shadowOffset = offset;
    self.tabBar.layer.shadowRadius = radius;
    self.tabBar.layer.shadowOpacity = opacity;
    
    self.tabBar.clipsToBounds = NO;
}


- (void)showBadgeOnItemIndex:(int)index{
    
    //移除之前的小红点
    [self removeBadgeOnItemIndex:index];
    
    //新建小红点
    UIView *badgeView = [[UIView alloc]init];
    badgeView.tag = 888 + index;
    badgeView.layer.cornerRadius = 4;
    badgeView.backgroundColor = color_red_ea4c40;
    CGRect tabFrame = self.tabBar.frame;
    
    //确定小红点的位置
    NSInteger TabbarItemNums = self.tabBar.items.count;
    float percentX = (index +0.6) / TabbarItemNums;
    CGFloat x = ceilf(percentX * tabFrame.size.width);
    CGFloat y = ceilf(0.1 * tabFrame.size.height);
    badgeView.frame = CGRectMake(x, y, 8, 8);
    [self.tabBar addSubview:badgeView];
    
}

- (void)hideBadgeOnItemIndex:(int)index{
    
    //移除小红点
    [self removeBadgeOnItemIndex:index];
    
}

- (void)removeBadgeOnItemIndex:(int)index{
    
    //按照tag值进行移除
    for (UIView *subView in self.tabBar.subviews) {
        
        if (subView.tag == 888+index) {
            
            [subView removeFromSuperview];
            
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:kBadgeMessageMyPoint object:nil];
}




@end
