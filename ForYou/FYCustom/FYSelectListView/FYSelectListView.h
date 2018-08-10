//
//  FYSelectListView.h
//  ForYou
//
//  Created by marcus on 2017/8/9.
//  Copyright © 2017年 ForYou. All rights reserved.
//  tableView选择器

#import <UIKit/UIKit.h>

@class FYSelectListView;
@protocol FYSelectListViewDelegate <NSObject>

-(void)slectView:(FYSelectListView *)selectView selectArr:(NSArray *)selectArr;

@end




@interface FYSelectListView : UIView

/**
 构造一个选择器

 @param title 标题
 @param dataArr 选项必须是NSString
 @param isMoreOption 是否可以多选
 @return 一个视图
 */
+(FYSelectListView *)selectListViewWithTitle:(NSString *)title dataArr:(NSArray *)dataArr isMoreOption:(BOOL)isMoreOption ;

/**
 展示
 */
-(void) show;

/**
 在自定义的边界里显示

 @param frame 视图的位置
 */
-(void) showFrame:(CGRect)frame;
/**
 选中一些选项

 @param 选中的内容  
 */
-(void) selectedArr:(NSArray *)arr;

@property (nonatomic , weak) id<FYSelectListViewDelegate> delegate;

@end
