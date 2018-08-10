//
//  FYSelectListCell.m
//  ForYou
//
//  Created by marcus on 2017/8/10.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSelectListCell.h"
#import "Masonry.h"
#import "FYImages.h"
#define kLeftDistance 15
@implementation FYSelectListCell
{
    UIImageView *selectIm;
    UILabel *contentLb;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self){
        [self constructCell];
    }
    return self;
}

-(void)constructCell {
    CGFloat imH = 14;
    selectIm = [[UIImageView alloc]init];
    [self.contentView addSubview:selectIm];
    [selectIm mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.width.mas_equalTo(imH);
        make.size.height.mas_equalTo(imH);
        make.centerY.equalTo(self.contentView);
        make.left.mas_equalTo(kLeftDistance);
    }];
    selectIm.image  = image_radioButton_normal;
    
    contentLb = [[UILabel alloc]init];
    contentLb.textColor = [UIColor blackColor];
    contentLb.font = [UIFont systemFontOfSize:14];
    [self.contentView addSubview:contentLb];
    [contentLb mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.contentView);
        make.size.width.mas_equalTo(200);
        make.size.height.mas_equalTo(self.frame.size.height);
        make.left.mas_equalTo(kLeftDistance+imH+5);
    }];
}

-(void)setContentStr:(NSString *)contentStr{
    if (_contentStr!= contentStr) {
        _contentStr = contentStr;
    }
    contentLb.text = _contentStr;
}

-(void)setIsSelectOption:(BOOL)isSelectOption{
    if (_isSelectOption!= isSelectOption) {
        _isSelectOption = isSelectOption;
    }
    if (_isSelectOption) {
        selectIm.image  = image_radioButton_selected;
    }else{
        selectIm.image  = image_radioButton_normal;
    }
}









- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
