//
//  FYNavigationBar.m
//  ForYou
//
//  Created by marcus on 2017/7/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYNavigationBar.h"
#import "FYHeader.h"

@interface FYNavigationBar()
@property (weak, nonatomic) IBOutlet UIView *statusView;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *backButton;

@end

@implementation FYNavigationBar

+ (instancetype)naigationBarWithTitle:(NSString *)title {
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"FYNavigationBar" owner:nil options:nil];
    FYNavigationBar *navigationBar = [objs lastObject];
    navigationBar.titleLabel.text = title;
    return navigationBar;
}

+ (instancetype)naigationBarWithTitle:(NSString *)title backgroundColor:(UIColor *)color {
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"FYNavigationBar" owner:nil options:nil];
    FYNavigationBar *navigationBar = [objs lastObject];
    navigationBar.titleLabel.text = title;
    [navigationBar updateColor:color];
    return navigationBar;
}

- (void)updateColor:(UIColor *)color {
    self.backgroundColor = color;
    self.lineView.backgroundColor = color;
    
}

- (void)updateAlpha:(CGFloat)alpha {
    self.alpha = alpha;
}

- (void)updateTitle:(NSString *)title {
    self.titleLabel.text = title;
}

-(void)updateTitleColor:(UIColor *)titleColor{
    self.titleLabel.textColor= titleColor;
}
-(void)updateTitleAlpha:(CGFloat )alpha{
    self.titleLabel.alpha= alpha;
}

-(void)updateTitleFont:(CGFloat )font{
    self.titleLabel.font = [UIFont systemFontOfSize:font];
}

- (IBAction)backButtonClick:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(navigationBarBackButtonClick)]) {
        [self.delegate navigationBarBackButtonClick];
    }
}

- (void)setBackButtonHidden:(Boolean)hidden {
    self.backButton.hidden = hidden;
    self.leftImageView.hidden = hidden;
}


@end
