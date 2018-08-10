//
//  FYSelectTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYSelectTableCell.h"
#import "FYHeader.h"

@interface FYSelectTableCell()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet UIImageView *rightImageView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *valueLabelRightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *mustInputMark;


@end

@implementation FYSelectTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
    self.valueLabel.text = [self.dataModel valueForKey:self.cellModel.key]?:@"";
    self.lineView.hidden = !self.cellModel.showLine;
    self.mustInputMark.hidden = !self.cellModel.mustInput;
    if (self.cellModel.canEdit) {
        if ([NSString isEmpty:self.valueLabel.text]) {
            self.valueLabel.text = self.cellModel.placeholder;
            self.valueLabel.textColor = color_black9;
        } else {
            self.valueLabel.textColor = color_black3;
        }
    } else {
        self.valueLabel.textColor = color_black9;
    }
    self.rightImageView.hidden = !self.cellModel.canEdit;
    self.valueLabelRightConstraint.constant = self.cellModel.canEdit ? 34 : 16;
    if (self.cellModel.valueChangeBlock) {
        self.cellModel.valueChangeBlock();
    }
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
