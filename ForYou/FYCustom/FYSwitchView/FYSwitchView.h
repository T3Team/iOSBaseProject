//
//  FYSwitchView.h
//  ForYou
//
//  Created by marcus on 2017/11/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FYSwitchProtocol<NSObject>
-(void)switchViewDidSelectIndex:(NSInteger)index;

-(BOOL)switchViewNeedChangeColorWithSelectIndex:(NSInteger)index;

@end

@interface FYSwitchView : UIView

@property(nonatomic, weak)id<FYSwitchProtocol>delegate;

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titles normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor font:(NSInteger)font;

//仅仅是修改选中的顺序的 UI 效果，不牵扯到业务逻辑
- (void)modifyColorForSelectIndex:(NSInteger)index;

@end
