//
//  FYIconSelectTableCell.m
//  ForYou
//
//  Created by marcus on 2017/9/28.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYIconSelectTableCell.h"
#import "FYHeader.h"


@interface FYIconSelectTableCell()

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet UIImageView *leftImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelRightConstraint;
@end

@implementation FYIconSelectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
    if (![NSString isEmpty:self.cellModel.imageName]) {
        self.leftImageView.image = [UIImage imageNamed:self.cellModel.imageName];
    }
    if (dataModel && ![NSString isEmpty:self.cellModel.key]) {
        self.valueLabel.text = [self.dataModel valueForKey:self.cellModel.key]?:@"";
    }else {
        self.valueLabel.text = @"";
    }
    self.rightImageView.hidden = !self.cellModel.canEdit;
    self.valueLabelRightConstraint.constant = self.cellModel.canEdit ? 34 : 16;
    self.lineView.hidden = !self.cellModel.showLine;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        NSString *value = [self.dataModel valueForKey:self.cellModel.key]?:@"";
        if ([NSString isEmpty:value]) {
            result = [NSString stringWithFormat:@"请选择%@",self.cellModel.cellTitle];
        }
    }
    return result;
}

@end
