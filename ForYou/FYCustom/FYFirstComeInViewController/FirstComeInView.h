//
//  FirstComeInView.h
//  ForYou
//
//  Created by marcus on 2017/10/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FirstComeInView : UIView

@property(nonatomic, strong)UIImageView * imgView;
@property(nonatomic, strong)UILabel * titleLabel;
@property(nonatomic, strong)UILabel * remindLabel;
@property(nonatomic, strong)UIButton * comeinBtn;

- (void)lastViewAddButton;

@end
