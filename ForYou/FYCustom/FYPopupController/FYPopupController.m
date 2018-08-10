//
//  FYPopupController.m
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYPopupController.h"

@interface FYPopupController ()

@property (nonatomic, strong) UIView  *presentView;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, assign) NSTimeInterval animateDuration;
@property (nonatomic, assign) FYPopupStyle style;
@property (nonatomic, assign) CGFloat depathSacle;
@property (nonatomic, copy) FYPopupCompletionBlock completion;
@property (nonatomic, strong) UIImage *convertImage;
@property (nonatomic, assign) CGRect beginRect;
@property (nonatomic, assign) CGRect endRect;
@property (nonatomic, assign) BOOL bShowView;  //显示 还是 隐藏 View 的过程
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *coverView;
@property (nonatomic, strong) UIImageView *animationImageView;
@property (nonatomic, assign) BOOL isBackgroundCancel; //点击背景可取消  默认YES

@end

@implementation FYPopupController

#pragma mark - view lifecycle
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initDefaultValues];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: animated];
    [self popupPositon];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    self.bShowView = YES;
    if (self.animateDuration == 0) {
        [self animatePopupWithStyle];
    } else {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self animatePopupWithStyle];
        } completion:^(BOOL finished) {
            
        }];
    }
}

#pragma mark - public methods
+ (void)popupView:(UIView *)view popupStyle:(FYPopupStyle)style {
    [FYPopupController popupView:view popupStyle:style backgroundColor:[UIColor clearColor] animateDuration:0.2 depthSacle:1.0 isBackgroundCancel:YES completion:nil];
}

+ (void)popupView:(UIView *)view popupStyle:(FYPopupStyle)style backgroundColor:(UIColor*)backgroundColor animateDuration:(NSTimeInterval)animateDuration depthSacle:(CGFloat)depthSacle isBackgroundCancel:(BOOL)isBackgroundCancel completion:(FYPopupCompletionBlock)completion {
    FYPopupController *popupController = [[FYPopupController alloc] init];
    popupController.presentView = view;
    popupController.backgroundColor = backgroundColor;
    popupController.animateDuration = animateDuration;
    popupController.style = style;
    popupController.depathSacle = depthSacle;
    popupController.completion = completion;
    popupController.isBackgroundCancel = isBackgroundCancel;
    UIViewController *currentVC = [UIViewController currentViewController];
    UIWindow *windowView = [UIViewController currentWindow];
    popupController.convertImage = [UIView convertView:windowView];
    [currentVC presentViewController:popupController animated:NO completion:nil];
}

+ (void)dissmissPopupView {
    [FYPopupController dissmissPopupViewAnimation:YES completion:nil];
}

+ (void)dissmissPopupViewAnimation:(Boolean)animation  completion:(FYPopupCompletionBlock)completion {
    UIViewController *currentVC = [UIViewController currentViewController];
    if ([currentVC isKindOfClass:[FYPopupController class]]) {
        FYPopupController *tempVC = (FYPopupController *)currentVC;
        tempVC.completion = completion;
        [tempVC dissmissPresentViewAnimation:animation];
    }
}


#pragma mark - private methods
- (void)initDefaultValues {
    self.hideNavigationBar = YES;
    
    self.backgroundView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.backgroundView.backgroundColor = self.backgroundColor;
    self.coverView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
    self.animationImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];
   
    self.convertImage = [UIImage specialScaleImage:self.convertImage scale:self.depathSacle withBackground:self.backgroundColor];
    self.beginRect = CGRectMake(-(ScreenWidth*((1-self.depathSacle)/self.depathSacle)*0.5), -(ScreenHeight*((1-self.depathSacle)/self.depathSacle)*0.5), ScreenWidth/self.depathSacle, ScreenHeight/self.depathSacle);
    self.endRect = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
    self.animationImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.animationImageView.backgroundColor = [UIColor blackColor];
    self.animationImageView.frame = self.beginRect;
    self.animationImageView.image = self.convertImage;
    [self.view addSubview:self.animationImageView];
    [self.view addSubview:self.backgroundView];
    self.coverView.backgroundColor = color_black_alpha4;
    [self.view addSubview:self.coverView];
    [self.view addSubview:self.presentView];
    
    if (self.isBackgroundCancel) {
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
        [self.coverView addGestureRecognizer:tap];
    }
}

- (void)cancelClick {
    [FYPopupController dissmissPopupView];
}

- (void)popupPositon {
    
//此style是所要present的view动画，因此和其他style有很大区别
    if (self.style != FYPopupStyleForeCenter) {
        self.animationImageView.frame = self.beginRect;
        self.coverView.alpha = 0.0;
    }
    CGRect rect = self.presentView.frame;
    switch (self.style) {
        case FYPopupStyleTop:
            rect.origin.y = - (rect.size.height);
            self.presentView.frame = rect;
            break;
        case FYPopupStyleBottom:
            rect.origin.y = ScreenHeight;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleLeft:
            rect.origin.x = -(rect.size.width);
            self.presentView.frame = rect;
            break;
        case FYPopupStyleRight:
            rect.origin.x = ScreenWidth;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleCenter:
            self.presentView.alpha = 0.0;
            rect.origin.x = (ScreenWidth-rect.size.width)/2.0;
            rect.origin.y = (ScreenHeight-rect.size.height)/2.0;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleForeCenter:
            self.presentView.alpha = 0.0;
            self.presentView.transform = CGAffineTransformMakeScale(0.5, 0.5);
            _presentView.center = _presentView.superview.center;
            break;
  
        default:
            break;
    }
}

- (void)animatePopupWithStyle {
    
    if (self.style != FYPopupStyleForeCenter) {
        //此style是所要present的view动画，因此和其他style有很大区别
        self.animationImageView.frame = self.endRect;
        self.coverView.alpha = 1.0;
    }
    CGRect rect = self.presentView.frame;
    switch (self.style) {
        case FYPopupStyleTop:
            rect.origin.y = 0;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleBottom:
            rect.origin.y = ScreenHeight-rect.size.height;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleLeft:
            rect.origin.x = 0;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleRight:
            rect.origin.x = ScreenWidth-rect.size.width;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleCenter:
            self.presentView.alpha = 1.0;
            rect.origin.x = (ScreenWidth-rect.size.width)/2.0;
            rect.origin.y = (ScreenHeight-rect.size.height)/2.0;
            self.presentView.frame = rect;
            break;
        case FYPopupStyleForeCenter:
            self.presentView.alpha = 1.0;
            self.presentView.transform = CGAffineTransformMakeScale(1.0, 1.0);
            _presentView.center = _presentView.superview.center;
            break;
            
        default:
            break;
    }
}

- (void)dissmissPresentViewAnimation:(Boolean)animation {
    self.bShowView = NO;
    if (self.style == FYPopupStyleForeCenter) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            self.presentView.alpha = 0.0;
            self.coverView.alpha = 0.0;
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:false completion:^{
                if (self.completion) {
                    self.completion();
                }
            }];
        }];
        return;
    }

// FYPopupStyleForeCenter style直接消失，不再执行回缩动画
    if (animation) {
        [UIView animateWithDuration:self.animateDuration animations:^{
            [self popupPositon];
        } completion:^(BOOL finished) {
            [self dismissViewControllerAnimated:false completion:^{
                if (self.completion) {
                    self.completion();
                }
            }];
        }];
    }else {
        [self popupPositon];
        [self dismissViewControllerAnimated:false completion:^{
            if (self.completion) {
                self.completion();
            }
        }];
    }
}

@end
