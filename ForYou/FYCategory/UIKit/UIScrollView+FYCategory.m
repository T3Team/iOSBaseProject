//
//  UIScrollView+FYCategory.m
//  ForYou
//
//  Created by marcus on 2017/8/4.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "UIScrollView+FYCategory.h"
#import "MJRefresh.h"

@implementation UIScrollView (FYCategory)


- (void)addFYGifHeaderWithBlock:(void (^)())block {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 0; i <= 23; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pullDownloading%d",i]];
        [headerImages addObject:image];
    }
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingBlock:block];
    gifHeader.stateLabel.hidden = YES;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    [gifHeader setImages:headerImages forState:MJRefreshStateIdle];
    [gifHeader setImages:headerImages forState:MJRefreshStateRefreshing];
    [gifHeader setImages:headerImages forState:MJRefreshStateWillRefresh];
    [gifHeader setImages:headerImages forState:MJRefreshStatePulling];
    self.mj_header = gifHeader;
}

- (void)addFYGifHeaderWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 0; i <= 23; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"pullDownloading%d",i]];
        [headerImages addObject:image];
    }
    MJRefreshGifHeader *gifHeader = [MJRefreshGifHeader headerWithRefreshingTarget:target refreshingAction:action];
    gifHeader.stateLabel.hidden = YES;
    gifHeader.lastUpdatedTimeLabel.hidden = YES;
    [gifHeader setImages:headerImages forState:MJRefreshStateIdle];
    [gifHeader setImages:headerImages forState:MJRefreshStateRefreshing];
    [gifHeader setImages:headerImages forState:MJRefreshStateWillRefresh];
    [gifHeader setImages:headerImages forState:MJRefreshStatePulling];

    self.mj_header = gifHeader;
}

- (void)addFYGifFooterWithRefreshingTarget:(id)target refreshingAction:(SEL)action {
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 13; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"loading%d",i]];
        [headerImages addObject:image];
    }
    MJRefreshAutoGifFooter *gifFooter = [MJRefreshAutoGifFooter footerWithRefreshingTarget:target refreshingAction:action];
    gifFooter.stateLabel.hidden = YES;
    gifFooter.refreshingTitleHidden = YES;
    [gifFooter setImages:headerImages forState:MJRefreshStateIdle];
    [gifFooter setImages:headerImages forState:MJRefreshStateRefreshing];
    [gifFooter setImages:headerImages forState:MJRefreshStateWillRefresh];
    [gifFooter setImages:headerImages forState:MJRefreshStatePulling];
    self.mj_footer = gifFooter;
}

- (void)addStandardFooterWithRefreshBlock:(void (^)())block{
    MJRefreshBackNormalFooter *gifFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
    gifFooter.stateLabel.hidden = NO;
//    gifFooter.refreshingTitleHidden = NO;
    NSString *footerTitle = @"正在加载更多数据...";
    [gifFooter setTitle:footerTitle forState:MJRefreshStateIdle];
    [gifFooter setTitle:footerTitle forState:MJRefreshStatePulling];
    [gifFooter setTitle:footerTitle forState:MJRefreshStateRefreshing];
    
    // Set font
    gifFooter.stateLabel.font = [UIFont systemFontOfSize:14];
    
    //set gifs
    NSMutableArray *headerImages = [NSMutableArray array];
    for (int i = 1; i <= 8; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"footer_loading%d",i]];
        [headerImages addObject:image];
    }
    self.mj_footer = gifFooter;
}

- (void)newHouse_addStandardFooterWithRefreshBlock:(void (^)())block{
    MJRefreshBackNormalFooter *gifFooter = [MJRefreshBackNormalFooter footerWithRefreshingBlock:block];
    gifFooter.stateLabel.hidden = NO;
    //    gifFooter.refreshingTitleHidden = NO;
    gifFooter.arrowView.image = [UIImage imageNamed:@"xf_xljz_28"];
    NSString *footerTitle = @"正在加载更多内容...";
    [gifFooter setTitle:@"取消加载更多内容..." forState:MJRefreshStateIdle];
    [gifFooter setTitle:@"上拉加载更多内容..." forState:MJRefreshStatePulling];
    [gifFooter setTitle:footerTitle forState:MJRefreshStateRefreshing];
    // Set font
    gifFooter.stateLabel.font = [UIFont systemFontOfSize:12];
    self.mj_footer = gifFooter;
}

@end
