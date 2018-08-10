//
//  FYCalendarCell.m
//  FYCalendarView
//
//  Created by ForYou on 2017/8/17.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import "FYCalendarCell.h"
#define color_backview [UIColor redColor]



@implementation FYCalendarCell
- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        
        [self addSubview:self.todayCircle];
        [self addSubview:self.backView];
        [self addSubview:self.todayLabel];
//        [self addSubview:self.selectImage];
        
    }
    
    return self;
}

- (UIView *)todayCircle {
    if (_todayCircle == nil) {
        _todayCircle = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.8 * self.bounds.size.height, 0.8 * self.bounds.size.height)];
        _todayCircle.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _todayCircle.layer.cornerRadius = 0.5 * _todayCircle.frame.size.width;
    }
    return _todayCircle;
}

- (UILabel *)todayLabel {
    if (_todayLabel == nil) {
        _todayLabel = [[UILabel alloc] initWithFrame:self.bounds];
        _todayLabel.textAlignment = NSTextAlignmentCenter;
        _todayLabel.font = [UIFont boldSystemFontOfSize:14.0];
        _todayLabel.backgroundColor = [UIColor clearColor];
    }
    return _todayLabel;
}
- (UIView *)backView {
    if (_backView == nil) {
        _backView = [[UIView alloc] initWithFrame:CGRectMake(0.0, 0.0, 0.8 * self.bounds.size.height, 0.8 * self.bounds.size.height)];
        _backView.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _backView.clipsToBounds= YES;
        _backView.layer.borderWidth = 0.0f;
        _backView. layer.borderColor = color_backview.CGColor;
        _backView.backgroundColor = [UIColor clearColor];
        _backView.layer.cornerRadius = 0.5 * _todayCircle.frame.size.width;
        
    }
    return _backView;
}
-(UIImageView *)selectImage{
    if (_selectImage == nil) {
        _selectImage = [[UIImageView alloc] initWithFrame:CGRectMake(0.0, 0.0,  self.bounds.size.height, self.bounds.size.height)];
        _selectImage.center = CGPointMake(0.5 * self.bounds.size.width, 0.5 * self.bounds.size.height);
        _selectImage.image = [UIImage imageNamed:@"icon_select_calendar"];
        _selectImage.hidden = YES;
    }
    return _selectImage;
}


@end
