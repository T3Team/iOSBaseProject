//
//  FYCycleScrollViewCell.h
//  ForYou
//
//  Created by marcus on 2017/8/11.
//  Copyright © 2017年 ForYou. All rights reserved.
//



#import <UIKit/UIKit.h>

@interface FYCycleScrollViewCell : UICollectionViewCell

@property (weak, nonatomic) UIImageView *imageView;
@property (copy, nonatomic) NSString *title;

@property (nonatomic, strong) UIColor *titleLabelTextColor;
@property (nonatomic, strong) UIFont *titleLabelTextFont;
@property (nonatomic, strong) UIColor *titleLabelBackgroundColor;
@property (nonatomic, assign) CGFloat titleLabelHeight;
@property (nonatomic, assign) NSTextAlignment titleLabelTextAlignment;

@property (nonatomic, assign) BOOL hasConfigured;

/** 只展示文字轮播 */
@property (nonatomic, assign) BOOL onlyDisplayText;

/**
 横向两侧留边
 */
@property (nonatomic,assign) CGFloat horizontalMargins;

@end
