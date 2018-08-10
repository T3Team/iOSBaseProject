//
//  FYRemarkTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYRemarkTableCell.h"
#import "FYPlaceholderTextView.h"
#import "FYHeader.h"

@interface FYRemarkTableCell()<UITextViewDelegate>

@property (weak, nonatomic) IBOutlet FYPlaceholderTextView *remarkTextView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@end

@implementation FYRemarkTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.remarkTextView.placeholder = @"100字以内"; 
    self.remarkTextView.delegate = self;
    self.remarkTextView.layer.borderWidth = 0.5;
    self.remarkTextView.layer.borderColor = color_gray_dddddd.CGColor;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.remarkTextView.placeholder = [NSString stringWithFormat:@"%ld字以内",self.cellModel.lengthMax];
    self.remarkTextView.text = [self.dataModel valueForKey:self.cellModel.key];
    if ([NSString isEmpty:self.remarkTextView.text]) {
        self.remarkTextView.placeholder = [NSString stringWithFormat:@"%ld字以内",self.cellModel.lengthMax];
        if ([self.cellModel.cellTitle isEqualToString:@"意见&建议"]) {
           self.remarkTextView.placeholder = @"2-200字";
        }
    }
    if (![NSString isEmpty:self.cellModel.cellTitle] && ![self.cellModel.cellTitle isEqualToString:@"备注"]) {
        self.titleLabel.text = self.cellModel.cellTitle;
        self.titleLabel.textColor = color_black3;
        if (![self.cellModel.cellTitle isEqualToString:@"意见&建议"] && ![NSString isEmpty:[self.dataModel valueForKey:self.cellModel.key]]) {
            self.remarkTextView.textColor = color_black3;
            self.titleLabel.font = [UIFont systemFontOfSize:16];
        }
    }
}

#pragma mark - UITextViewDelegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if (![NSString isEmpty:text])
    {
        NSString * tempString = [textView.text stringByReplacingCharactersInRange:range withString:text];
        if (tempString.length > self.cellModel.lengthMax) {
            [FYProgressHUD topWindonsShowToastStatus:[NSString stringWithFormat:@"输入的%@超出范围",self.cellModel.cellTitle]];
            return NO;
        }
    }
    NSString * tempString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    if (self.valueChangeBlock) {
        self.valueChangeBlock(tempString);
    }
    return YES;
}

- (NSString *)inputContent {
    NSString *result = [self.remarkTextView.text isEqualToString:self.remarkTextView.placeholder]?@"":self.remarkTextView.text;
    [self.dataModel setObject:result forKey:self.cellModel.key];
    return result;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        NSString *result = [self.remarkTextView.text isEqualToString:self.remarkTextView.placeholder]?@"":self.remarkTextView.text;
        if ([NSString isEmpty: result]) {
            result = [NSString stringWithFormat:@"请输入%@",self.cellModel.cellTitle];
        }
    }
    return result;
}

@end
