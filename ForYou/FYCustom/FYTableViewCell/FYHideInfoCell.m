//
//  FYHideInfoCell.m
//  ForYou
//
//  Created by marcus on 2017/10/26.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYHideInfoCell.h"

@interface FYHideInfoCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *showLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIButton *showInfoButton;
@end

@implementation FYHideInfoCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    if ([self.cellModel.cellTitle isEqualToString:@"查看联系人"]) {  //防止title重复，特殊处理
        self.titleLabel.text = @"联系人";
    }else {
        self.titleLabel.text = self.cellModel.cellTitle;
    }
    if (self.cellModel.canEdit) {
        self.showLabel.text = self.cellModel.placeholder;
        self.showInfoButton.hidden = NO;
        self.showLabel.textColor = color_black3;
    }else {
        self.showLabel.text = @"您无权限修改业主信息";
        self.showInfoButton.hidden = YES;
        self.showLabel.textColor = color_black9;
    }
    self.line.hidden = !self.cellModel.showLine;
}

- (IBAction)buttonClick:(UIButton *)sender {
    if (self.showInfoBlock) {
        self.showInfoBlock();
    }
}

@end
