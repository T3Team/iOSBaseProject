//
//  FYAlertListCellTableViewCell.m
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAlertListViewCell.h"
#import "FYHeader.h"

@interface FYAlertListViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@end

@implementation FYAlertListViewCell

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    self.selectImage.image = selected?image_radioButton_selected:image_radioButton_normal;
}

#pragma mark - public methods
- (void)reloadCellWithTitle:(NSString *)title description:(NSString *)description {
    self.titleLabel.text = title;
    self.descriptionLabel.text = description;
}

@end
