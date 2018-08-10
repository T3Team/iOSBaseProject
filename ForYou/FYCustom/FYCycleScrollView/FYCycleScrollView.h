//
//  FYCycleScrollView.h
//  ForYou
//
//  Created by marcus on 2017/8/11.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>


/**
 pageControl样式

 - FYCycleScrollViewPageControlStyleLabel: 显示页码
 - FYCycleScrollViewPageControlStyleOrigin: 显示原点
 */
typedef NS_ENUM (NSUInteger, FYCycleScrollViewPageControlStyle){
    FYCycleScrollViewPageControlStyleLabel,
    FYCycleScrollViewPageControlStyleOrigin
};

@class FYCycleScrollView;

@protocol FYCycleScrollViewDelegate <NSObject>

@optional

/**
  点击图片回调

 @param cycleScrollView 轮播图
 @param index 当前点击页码
 */
- (void)cycleScrollView:(FYCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index;

/**
 图片滚动回调

 @param cycleScrollView 轮播图
 @param index 当前页码
 */
- (void)cycleScrollView:(FYCycleScrollView *)cycleScrollView didScrollToIndex:(NSInteger)index;


@end


@interface FYCycleScrollView : UIView


/**
 初始化轮播图方法

 @param frame 设置frame
 @param delegate 设置代理
 @param placeholderImage 默认图
 @return 轮播图View
 */
+ (instancetype)cycleScrollViewWithFrame:(CGRect)frame delegate:(id<FYCycleScrollViewDelegate>)delegate placeholderImage:(UIImage *)placeholderImage;


/*******************  设置图片来源 *******************/

/**
 网络图片 url string 数组
 */
@property (nonatomic, strong) NSArray *imageURLStringsGroup;

/**
 每张图片对应要显示的文字数组
 */
@property (nonatomic, strong) NSArray *titlesGroup;

/**
 本地图片数组
 */
@property (nonatomic, strong) NSArray *localizationImageNamesGroup;


/*******************  界面控制 *******************/

/**
 自动滚动间隔时间,默认2s
 */
@property (nonatomic, assign) CGFloat autoScrollTimeInterval;

/**
 是否无限循环,默认Yes
 */
@property (nonatomic,assign) BOOL infiniteLoop;

/**
 是否自动滚动,默认Yes
 */
@property (nonatomic,assign) BOOL autoScroll;


/**
 横向两侧留边
 */
@property (nonatomic,assign) CGFloat horizontalMargins;

/**
 只展示文字轮播
 */
@property (nonatomic, assign) BOOL onlyDisplayText;

/**
 是否在只有一张图时隐藏pagecontrol，默认为YES
 */
@property(nonatomic) BOOL hidesForSinglePage;

/**
 pageControl样式
 */
@property (nonatomic,assign) FYCycleScrollViewPageControlStyle pageControlStyle;


/**
 图片滚动方向，默认为水平滚动
 */
@property (nonatomic, assign) UICollectionViewScrollDirection scrollDirection;

/**
 轮播图片的ContentMode，默认为 UIViewContentModeScaleToFill
 */
@property (nonatomic, assign) UIViewContentMode bannerImageViewContentMode;


/**
 隐藏PageControl，默认为NO
 */
@property (nonatomic, assign) BOOL hidePageControl;


/**
 设置初始显示的index
 */
@property (nonatomic, assign) NSInteger startIndex;

/**
 滚动到指定页
 
 @param targetIndex 滚动到指定页
 @param animated 是否需要动画
 */
- (void)scrollToIndex:(int)targetIndex animated:(BOOL)animated;

@end
