//
//  FYSwitchView.m
//  ForYou
//
//  Created by marcus on 2017/11/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSwitchView.h"
#import "FYHeader.h"
@interface FYSwitchView ()
@property(nonatomic, strong)NSMutableArray * allButtonsArray;
@property(nonatomic, strong)UIView * line;
@property(nonatomic, assign)NSInteger selectIndex;

@end


@implementation FYSwitchView

-(instancetype)initWithFrame:(CGRect)frame titleArray:(NSArray *)titles normalColor:(UIColor *)normalColor selectedColor:(UIColor *)selectedColor font:(NSInteger)font{
    
    self = [super initWithFrame:frame];
    if (self) {
        self.allButtonsArray = [NSMutableArray array];
        for (int i = 0; i < titles.count; i++) {
            UIButton * getButton = [UIButton buttonWithType:UIButtonTypeCustom];
            getButton.tag = 200+i;
            getButton.backgroundColor = color_clear;
            getButton.titleLabel.font = [UIFont systemFontOfSize:font];
            [getButton setTitle:[titles objectAtIndex:i] forState:UIControlStateNormal];
            [getButton setTitleColor:normalColor forState:UIControlStateNormal];
            [getButton setTitleColor:selectedColor forState:UIControlStateSelected];
            getButton.selected = NO;
            float width = frame.size.width/titles.count;
            
            getButton.frame = CGRectMake(width*i, 0, width, frame.size.height-2);
            [getButton addTarget:self action:@selector(switchButtonAction:) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview:getButton];
            [self.allButtonsArray addObject:getButton];
            
            if (i == 0) {
                getButton.selected = YES;
                self.selectIndex = 0;
            }
        
        }
  
        NSString * maxLengStr = [titles firstObject];
        for (int i = 0; i < titles.count; i++) {
            NSString * str = [titles objectAtIndex:i];
            if (maxLengStr.length < str.length) {
                maxLengStr = str;
            }
        }
        
        UIView * bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-0.5, frame.size.width, 0.5)];
        bottomLine.backgroundColor = color_line_e5e5e5;
        [self addSubview:bottomLine];
        
        
        
        float width = [maxLengStr stringLengthWithFont:[UIFont systemFontOfSize:font]];
        
        UIView * line = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-1.5, width+8, 1.5)];
        line.backgroundColor = color_red_ea4c40;
        [self addSubview:line];
        self.line = line;
        float center = frame.size.width/titles.count/2.0f;
        CGRect rect = line.frame;
        rect.origin.x = center-rect.size.width/2.0f;
        line.frame = rect;
    }
    return self;
}

- (void)switchButtonAction:(UIButton *)btn{

    NSInteger index = btn.tag-200;
    
    if ([self.delegate respondsToSelector:@selector(switchViewNeedChangeColorWithSelectIndex:)]) {
        BOOL change = [self.delegate switchViewNeedChangeColorWithSelectIndex:index];
        if (change) {
            [self modifyColorForSelectIndex:index];
        }
        return;
    }

    if ([self.delegate respondsToSelector:@selector(switchViewDidSelectIndex:)]) {
        [self.delegate switchViewDidSelectIndex:index];
    }
    [self modifyColorForSelectIndex:index];
}

- (void)modifyColorForSelectIndex:(NSInteger)index{
    
    [self.allButtonsArray enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        ((UIButton *)obj).selected = NO;
    }];
    
    UIButton * oldBtn = [self viewWithTag:200+self.selectIndex];
    oldBtn.selected = NO;
    

    UIButton * newBtn = [self viewWithTag:200+index];
    newBtn.selected = YES;
    self.selectIndex = index;

    float center = self.frame.size.width/_allButtonsArray.count/2.0f;
    float newCenter = center*(2*index+1);
    [UIView animateWithDuration:0.2 animations:^{
        
        CGRect rect = self.line.frame;
        rect.origin.x = newCenter-rect.size.width/2.0f;
        self.line.frame = rect;
        self.userInteractionEnabled = NO;
    } completion:^(BOOL finished) {
        self.userInteractionEnabled  = YES;
    }];
}




@end
