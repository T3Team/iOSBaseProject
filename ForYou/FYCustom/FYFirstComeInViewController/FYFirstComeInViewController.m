//
//  FYFirstComeInViewController.m
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYFirstComeInViewController.h"
#import "FYHeader.h"
#import "FirstComeInView.h"

@interface FYFirstComeInViewController ()<UIScrollViewDelegate>
@property(nonatomic,strong)UIScrollView*scrollView;
@property(nonatomic,strong)UIPageControl*pageControl;

@end

@implementation FYFirstComeInViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.navigationBar.hidden = YES;
    self.view.backgroundColor = [UIColor whiteColor];
    [self   creatSubviews];
}

- (void)creatSubviews{
    UIView * backView = [[UIView alloc] initWithFrame:self.view.bounds];
    backView.backgroundColor = color_white;
    [self.view addSubview:backView];
    
    NSArray * imageArray = @[icon_first_2, icon_first_1, icon_first_3, icon_first_4];
    NSArray * titleArray = @[@"引导页1", @"引导页2", @"引导页3", @"引导页4"];
    NSArray * remindArray = @[@"引导页引导页引导页", @"引导页引导页引导页", @"引导页引导页引导页", @"引导页引导页引导页"];
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.tag = 250;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = [UIColor whiteColor];
    _scrollView.delegate = self;
    _scrollView.contentSize = CGSizeMake(ScreenWidth*(imageArray.count),ScreenHeight);
    [self.view addSubview:_scrollView];

    for (int i = 0; i < imageArray.count; i++) {
        FirstComeInView * firstView = [[FirstComeInView alloc] initWithFrame:CGRectMake(i*ScreenWidth, 0, ScreenWidth, ScreenHeight)];
        firstView.backgroundColor =color_clear;
        firstView.imgView.image = [imageArray objectAtIndex:i];
        firstView.titleLabel.text = [titleArray objectAtIndex:i];
        firstView.remindLabel.text = [remindArray objectAtIndex:i];
        if (i == imageArray.count - 1) {
            [firstView lastViewAddButton];
            [firstView.comeinBtn addTarget:self action:@selector(dismissOnTheWindow) forControlEvents:UIControlEventTouchUpInside];
        }
        [_scrollView addSubview:firstView];
    }
    _scrollView.pagingEnabled = YES;
    
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake(50, CGRectGetMaxY(_scrollView.frame)-65, ScreenWidth-100, 20)];
    _pageControl.numberOfPages = imageArray.count;
    _pageControl.pageIndicatorTintColor = color_gray_E7E7E7;
    _pageControl.currentPageIndicatorTintColor = color_red_FC6463;
    
    [self.view addSubview:_pageControl];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    int page = (scrollView.contentOffset.x+(scrollView.frame.size.width*2/3.0)) / scrollView.frame.size.width;
    
    if (page > 2) {
        self.pageControl.hidden = YES;
    }else{
        self.pageControl.hidden = NO;
    }
    
    _pageControl.currentPage = page;
    
    if (!self.finishBlock) {
        scrollView.bounces = (scrollView.contentOffset.x <= 0) ? YES : NO;
        
        if (scrollView.contentOffset.x < -25) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
    }
}

- (void)dismissOnTheWindow{
    if (self.finishBlock) {
        self.finishBlock();
    }else {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

