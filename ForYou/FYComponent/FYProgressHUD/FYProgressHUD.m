//
//  FYProgressHUD.m
//  ForYou
//
//  Created by marcus on 2017/7/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYProgressHUD.h"
#import "MBProgressHUD.h"
#import "FYColors.h"
#import "FYDefines.h"
#import "FLAnimatedImage.h"
#import "FLAnimatedImageView.h"
#import <FrameAccessor/FrameAccessor.h>
#import "UIViewController+FYCategory.h"
#import "FYImages.h"
#import "NSString+FYCategory.h"

@interface FYProgressHUD()

@property (nonatomic, weak) MBProgressHUD *hud;

@end

@implementation FYProgressHUD

+ (FYProgressHUD *)sharedProgressManager
{
    static FYProgressHUD *manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[FYProgressHUD alloc] init];
    });
    return manager;
}

+ (void)showLoading {
    [self showLoadingWithStatus:nil];
}

+ (void)showLoadingEnable:(BOOL)isEnable {
    [self show:nil gifName:@"fy_loading" view:nil userInteractionEnabled:isEnable];
}


+ (void)showLoadingWithStatus:(NSString*)status {
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES; //显示
    [self show:status gifName:@"fy_loading" view:nil];
    
}

+ (void)showImage:(UIImage*)image status:(NSString*)status {
    [self show:status image:image view:nil];
}

+ (void)showImage:(UIImage*)image status:(NSString*)status completionBlock:(FYProgressHUDCompletionBlock)block {
    [self show:status image:image view:nil completionBlock:block];
}

+ (void)hideLoading {
    //    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO; //隐藏
    if ([self sharedProgressManager].hud) {
        [[self sharedProgressManager].hud hide:YES];
    }
}

+ (void)showToastStatus:(NSString *)status {
    if (![NSString isEmpty:status]) {
        [self show:status image:nil view:nil];
    }else {
        [self hideLoading];
    }
}

+ (void)topWindonsShowToastStatus:(NSString *)status {
    [self show:status image:nil view:[[UIApplication sharedApplication].windows objectAtIndex:1]];
}

+ (void)showToastStatus:(NSString *)status completionBlock:(FYProgressHUDCompletionBlock)block {
    [self show:status image:nil view:nil completionBlock:block];
}

+ (void)showSuccessWithStatus:(NSString*)status {
    [self show:status image:[UIImage imageNamed:@"icon_success"] view:nil];
}

+ (void)showSuccessWithStatus:(NSString*)status completionBlock:(FYProgressHUDCompletionBlock)block {
    [self show:status image:[UIImage imageNamed:@"icon_success"] view:nil completionBlock:block];
}

+ (void)showProgress:(float)progress mode:(FYProgressHUDMode)mode {
    [self showProgress:progress mode:mode view:nil status:nil];
}

+ (void)showProgress:(float)progress mode:(FYProgressHUDMode)mode status:(NSString*)status {
    [self showProgress:progress mode:mode view:nil status:status];
}

+ (void)showPointCount:(NSInteger)pointCount toastStatus:(NSString *)status completionBlock:(FYProgressHUDCompletionBlock)block {
    if (pointCount<=0) {
        [self showSuccessWithStatus:status completionBlock:block];
    }else {
        UIView *superView =  [UIViewController currentViewController].view;
        MBProgressHUD *hud;
        if (![self sharedProgressManager].hud || !([self sharedProgressManager].hud.superview==superView) ) {
            if ([self sharedProgressManager].hud) {
                [self sharedProgressManager].hud.completionBlock = nil;
                [[self sharedProgressManager].hud hide:YES];
            }
            [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:superView animated:YES];
        }
        hud = [self sharedProgressManager].hud;
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        view.backgroundColor = color_black_alpha7;
        [view.layer setCornerRadius:5.0];
        UILabel *pointlabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 36, 120, 13)];
        NSString *pointStr = [NSString stringWithFormat:@"+%ld ",pointCount];
        pointlabel.attributedText = [NSString attributeWithstrings:@[pointStr,@"积分"] colorArr:@[color_white,color_white] fonts:@[[UIFont systemFontOfSize:24],[UIFont systemFontOfSize:13]]];
        pointlabel.textAlignment = NSTextAlignmentCenter;
        [view addSubview:pointlabel];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 71, 120, 13)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = status;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = color_white;
        [view addSubview:label];
        hud.customView = view;
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        hud.opacity = 0.0f;
        // kPROGRESS_HUD_DELAY秒之后再消失
        [hud hide:YES afterDelay:kPROGRESS_HUD_DELAY];
        hud.square = YES;
        
        if (block) {
            hud.completionBlock = block;
        }else {
            hud.completionBlock = nil;
        }
    }
}

/**
 显示信息
 
 @param text 信息内容
 @param image 图标
 @param view 显示的视图
 */
+ (void)show:(NSString *)text image:(UIImage *)image view:(UIView *)view {
    [self show:text image:image view:view completionBlock:nil];
}

/**
 显示信息
 
 @param text 信息内容
 @param image 图标
 @param view 显示的视图
 @param block 显示完成后的回调
 */
+ (void)show:(NSString *)text image:(UIImage *)image view:(UIView *)view completionBlock:(FYProgressHUDCompletionBlock)block {
    if (!view) {
        view =  [UIViewController currentViewController].view;
    }
    MBProgressHUD *hud;
    if (![self sharedProgressManager].hud || !([self sharedProgressManager].hud.superview==view) ) {
        if ([self sharedProgressManager].hud) {
            [self sharedProgressManager].hud.completionBlock = nil;
            [[self sharedProgressManager].hud hide:YES];
        }
        [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud = [self sharedProgressManager].hud;
    if (view) {
        [view bringSubviewToFront:hud];
    }
    if (image) {
        // 设置图片
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        view.backgroundColor = color_black_alpha7;
        [view.layer setCornerRadius:5.0];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        imageView.frame = CGRectMake(35.0, 30.0, 50.0, 35.0);
        imageView.backgroundColor = color_clear;
        [view addSubview:imageView];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 84, 120, 13)];
        label.textAlignment = NSTextAlignmentCenter;
        label.text = text;
        label.font = [UIFont systemFontOfSize:13];
        label.textColor = color_white;
        [view addSubview:label];
        hud.customView = view;
        // 再设置模式
        hud.mode = MBProgressHUDModeCustomView;
        hud.opacity = 0.0f;
        // kPROGRESS_HUD_DELAY秒之后再消失
        [hud hide:YES afterDelay:kPROGRESS_HUD_DELAY];
        hud.square = YES;
    }else {
        hud.labelText = @"";
        hud.detailsLabelText = text;
        hud.detailsLabelFont = hud.labelFont;
        hud.customView = nil;
        hud.mode = MBProgressHUDModeCustomView;
        hud.backgroundColor = color_clear;
        hud.color = color_black_alpha7;
        hud.labelColor = color_white;
        hud.square = NO;
        // kPROGRESS_HUD_DELAY秒之后再消失
        [hud hide:YES afterDelay:kPROGRESS_HUD_DELAY];
    }
    if (block) {
        hud.completionBlock = block;
    }else {
        hud.completionBlock = nil;
    }
}



/**
 *  显示加载动画
 *
 *  @param text    动画对应的提示文字
 *  @param gifName 动画文件
 *  @param view    显示的视图
 */
+ (void)show:(NSString *)text gifName:(NSString *)gifName view:(UIView *)view {
    if (!view) {
        view =  [UIViewController currentViewController].view;
    }
    MBProgressHUD *hud;
    if (![self sharedProgressManager].hud || !([self sharedProgressManager].hud.superview==view) ) {
        if ([self sharedProgressManager].hud) {
            [self sharedProgressManager].hud.completionBlock = nil;
            [[self sharedProgressManager].hud hide:YES];
        }
        [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud = [self sharedProgressManager].hud;
    if (view) {
        [view bringSubviewToFront:hud];
    }
    // 快速显示一个提示信息
    hud.backgroundColor = [UIColor clearColor];
    hud.userInteractionEnabled = NO;
    hud.labelText = text;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image_refresh_background;
    backgroundImageView.frame = CGRectMake(0.0,0.0,90.0,90.0);
    // 设置加载动画
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
    [backgroundImageView addSubview:imageView];
    
    hud.customView = backgroundImageView;
    hud.color = [UIColor clearColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.completionBlock = nil;
}

+ (void)showProgress:(float)progress mode:(FYProgressHUDMode)mode view:(UIView *)view status:(NSString*)status{
    dispatch_async(dispatch_get_main_queue(), ^{
        UIView *tempView = [[UIApplication sharedApplication].windows lastObject];
        MBProgressHUD *hud;
        if (![self sharedProgressManager].hud) {
            [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:tempView animated:YES];
        }
        hud = [self sharedProgressManager].hud;
        MBProgressHUDMode hudMode;
        switch (mode) {
            case FYProgressHUDModePieChart:
                hudMode = MBProgressHUDModeDeterminate;
                break;
            case FYProgressHUDModeHorizontalBar:
                hudMode = MBProgressHUDModeDeterminateHorizontalBar;
                break;
            case FYProgressHUDModeRingShaped:
                hudMode = MBProgressHUDModeAnnularDeterminate;
                break;
            default:
                break;
        }
        hud.mode = hudMode;
        hud.progress = progress;
        hud.color = color_black_alpha1;
        hud.labelColor = color_black3;
        hud.activityIndicatorColor = color_black6;
        if (status && status.length>0) {
            hud.labelText = status;
        }
    });
}

+ (void)toastMessgeLightly:(NSString *)msg inView:(UIView *)view Yoffset:(CGFloat)offset{
    // 快速显示一个提示信息
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 30)];
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.backgroundColor = [UIColor colorWithWhite:.0 alpha:.7];
    tipLabel.layer.cornerRadius = 15;
    tipLabel.clipsToBounds = YES;
    tipLabel.font = [UIFont systemFontOfSize:14];
    tipLabel.text = msg;
    [tipLabel sizeToFit];
    tipLabel.width += 40;
    tipLabel.height = 30;
    tipLabel.centerY = (view.centerY + offset);
    tipLabel.centerX = view.width * .5;
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.userInteractionEnabled = NO;
    hud.mode = MBProgressHUDModeCustomView;
    hud.color = [UIColor clearColor];
    hud.customView = [UIView new];
    hud.minSize = tipLabel.frame.size;
    [hud addSubview:tipLabel];
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    // 1秒之后再消失
    [hud hide:YES afterDelay:3];
    [view bringSubviewToFront:hud];
}

+ (MBProgressHUD *)fy_loadingHudForView:(UIView *)view{
    if (!view) {
        view = [[UIViewController currentViewController] view];
        if (!view) {
            view = [[UIApplication sharedApplication].windows lastObject];
        }
    }
    
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    // 快速显示一个提示信息
    hud.backgroundColor = [UIColor clearColor];
    hud.userInteractionEnabled = NO;
    hud.labelText = @"";
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image_refresh_background;
    backgroundImageView.frame = CGRectMake(0.0,0.0,90.0,90.0);
    // 设置加载动画
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:@"fy_loading" ofType:@"gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
    [backgroundImageView addSubview:imageView];
    
    hud.customView = backgroundImageView;
    hud.color = [UIColor clearColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    return hud;
}

+ (void)showErrorInfoMessage:(NSError *)error errorCode:(NSInteger)errorCode {
#ifdef DEBUG
    UIView *view =  [UIViewController currentViewController].view;
    if ([self sharedProgressManager].hud) {
        [[self sharedProgressManager].hud hide:YES];
    }
    MBProgressHUD *hud = [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud = [self sharedProgressManager].hud;
    
    hud.labelText = [NSString stringWithFormat:@"%ld",errorCode];
    hud.detailsLabelText = [NSString stringWithFormat:@"%@",error];
    hud.backgroundColor = color_clear;
    hud.color = color_black_alpha7;
    hud.labelColor = color_white;
    hud.square = NO;
    // kPROGRESS_HUD_DELAY秒之后再消失
    [hud hide:YES afterDelay:kPROGRESS_HUD_DELAY*5];
    hud.completionBlock = nil;
#else
    [FYProgressHUD showToastStatus:@"当前网络异常!"];
#endif
}


/**
 *  显示加载动画
 *
 *  @param text    动画对应的提示文字
 *  @param gifName 动画文件
 *  @param isEnable  YES 不能操作   NO 能操作
 *  @param view    显示的视图
 */
+ (void)show:(NSString *)text gifName:(NSString *)gifName view:(UIView *)view  userInteractionEnabled:(BOOL)isEnable{
    if (!view) {
        view =  [UIViewController currentViewController].view;
    }
    MBProgressHUD *hud;
    if (![self sharedProgressManager].hud || !([self sharedProgressManager].hud.superview==view) ) {
        [self sharedProgressManager].hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    }
    hud = [self sharedProgressManager].hud;
    // 快速显示一个提示信息
    hud.backgroundColor = [UIColor clearColor];
    hud.userInteractionEnabled = isEnable;
    hud.labelText = text;
    
    UIImageView *backgroundImageView = [[UIImageView alloc] init];
    backgroundImageView.image = image_refresh_background;
    backgroundImageView.frame = CGRectMake(0.0,0.0,90.0,90.0);
    // 设置加载动画
    FLAnimatedImage *image = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile: [[NSBundle mainBundle] pathForResource:gifName ofType:@"gif"]]];
    FLAnimatedImageView *imageView = [[FLAnimatedImageView alloc] init];
    imageView.animatedImage = image;
    imageView.frame = CGRectMake(10.0, 10.0, 70.0, 70.0);
    [backgroundImageView addSubview:imageView];
    
    hud.customView = backgroundImageView;
    hud.color = [UIColor clearColor];
    // 再设置模式
    hud.mode = MBProgressHUDModeCustomView;
    // 隐藏时候从父控件中移除
    hud.removeFromSuperViewOnHide = YES;
    hud.completionBlock = nil;
}





@end
