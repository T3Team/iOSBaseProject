//
//  FYDefaultPageView.m
//  ForYou
//
//  Created by marcus on 2017/12/12.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYDefaultPageView.h"
#import "FYHeader.h"
@implementation FYDefaultPageView
{
    NSString *_image;
    NSString *_text;
    CGSize _imageSize;
    UILabel *_lb;
}

-(instancetype)initWithFrame:(CGRect)frame imageName:(NSString *)image text:(NSString *)text imageSize:(CGSize)size
{
    self = [super initWithFrame:frame];
    if (self) {
        _image = image;
        _text = text;
        _imageSize = size;
        self.backgroundColor = color_detail_background_f5f5f5;
        [self createView];
    }
    return self;
}

-(void)createView{
    UIImageView *im = [UIImageView new];
    im.image = [UIImage imageNamed:_image];
    [self addSubview:im];
    [im mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.centerY.equalTo(self.mas_centerY).offset(-_imageSize.height);
        make.size.mas_equalTo(_imageSize);
    }];
    _lb =[UILabel new];
    _lb.textColor = color_gray_a8a8a8;
    _lb.font = [UIFont systemFontOfSize:18];
    _lb.textAlignment = NSTextAlignmentCenter;
    _lb.text = _text;
    [self addSubview:_lb];
    [_lb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(im.mas_bottom).offset(17);
    }];
    
    
    
    
}

- (void)updateText:(NSString *)text{
    _lb.text = text;
}


@end
