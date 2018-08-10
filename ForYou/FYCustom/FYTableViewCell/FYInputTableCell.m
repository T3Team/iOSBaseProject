//
//  FYInputTableCell.m
//  ForYou
//
//  Created by marcus on 2017/8/29.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYInputTableCell.h"
#import "FYHeader.h"
#import <CoreText/CoreText.h>

@interface FYInputTableCell() <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UITextField *inputTextField;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIView *lineView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textFieldRightConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *mustInputMark;

@end

@implementation FYInputTableCell

#pragma mark -life cycle
- (void)awakeFromNib {
    [super awakeFromNib];
    self.inputTextField.delegate = self;
}


- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = self.cellModel.cellTitle;
    NSString *value = [self.dataModel objectForKey:self.cellModel.key];
    self.inputTextField.text = [NSString isEmpty:value]?@"":value;
    self.mustInputMark.hidden = !self.cellModel.mustInput;
    if (!self.cellModel.canEdit) {
        self.inputTextField.textColor = color_black9;
        self.inputTextField.enabled = NO;
        self.inputTextField.placeholder = @"";
    }else {
        self.inputTextField.textColor = color_black3;
        self.inputTextField.enabled = YES;
        //改变占位符的颜色并给占位符赋值
        NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:self.cellModel.placeholder?:@"" attributes:
                                          @{NSForegroundColorAttributeName:color_black9,
                                            NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                            }];
        self.inputTextField.attributedPlaceholder = attrString;
    }

    self.unitLabel.text = self.cellModel.unit?:@"";
    self.textFieldRightConstraint.constant = [NSString isEmpty:self.cellModel.unit]?0:10;
    if (self.cellModel.type == FYTableCellTypeDecimals) {
        self.inputTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }else if (self.cellModel.type == FYTableCellTypeString) {
        self.inputTextField.keyboardType = UIKeyboardTypeDefault;
    }else if (self.cellModel.type == FYTableCellTypePhone) {
        self.inputTextField.keyboardType = UIKeyboardTypePhonePad;
    }else if (self.cellModel.type == FYTableCellTypeNumber) {
        self.inputTextField.keyboardType = UIKeyboardTypePhonePad;
    }
    self.lineView.hidden = !self.cellModel.showLine;
}

#pragma mark -private methods

- (void)becomeFirstResponderWithTag:(NSString *)tag {
    [self.inputTextField becomeFirstResponder];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;

    if (self.cellModel.type == FYTableCellTypeNumber || self.cellModel.type == FYTableCellTypePhone) {
        result =  [NSString validateDecimalsNumber:string];
    }
    
    NSString *text = self.inputTextField.text;
    if (result) {
        if (range.length==0) {
            text = [text stringByAppendingString:string];
        }else {
            text = [text stringByReplacingCharactersInRange:range withString:string];
        }
    }
    
    UITextRange *selectedRange = [textField markedTextRange];
    UITextPosition *position = [textField positionFromPosition:selectedRange.start offset:0];
    if (!(range.length==0 && position)) {  //当前正在高亮时不需要校验长度
        if (!([NSString isEmpty:string] && range.length!=0)) { //正在删除时也不需要校验长度
            if ((self.cellModel.type == FYTableCellTypeString || self.cellModel.type == FYTableCellTypeNumber) && result) {
                if (text.length > self.cellModel.lengthMax) {
                    result = NO;
                }
                if (!result) {
                    [FYProgressHUD topWindonsShowToastStatus:[NSString stringWithFormat:@"输入%@超出范围",self.cellModel.cellTitle]];
                    //此时需要更新下model中的数据
                    NSString *textOld = self.inputTextField.text;
                    if (range.length==0) {
                        textOld = [textOld stringByAppendingString:@""];
                    }else {
                        textOld = [textOld stringByReplacingCharactersInRange:range withString:@""];
                    }
                    
                    if (self.cellModel && self.dataModel) {
                        [self.dataModel setValue:textOld forKey:self.cellModel.key];
                        if (self.cellModel.valueChangeBlock) {
                            self.cellModel.valueChangeBlock();
                        }
                    }
                }
            }
        }
        
        if (self.cellModel.type == FYTableCellTypePhone && result) { //电话位数限制
            result = [NSString inputPhoneVerify:text];
            if (!result) {
                [FYProgressHUD topWindonsShowToastStatus:[NSString stringWithFormat:@"请输入正确的%@",self.cellModel.cellTitle]];
            }
        }
        
        if (self.cellModel.type == FYTableCellTypeDecimals && result) {
            result = [NSString inputDecimalsVerify:self.inputTextField.text string:string rang:range lenthMax:self.cellModel.lengthMax];
            if (!result) {
                [FYProgressHUD topWindonsShowToastStatus:[NSString stringWithFormat:@"输入%@超出范围",self.cellModel.cellTitle]];
            }
        }
        
        if (self.cellModel && self.dataModel && result) {
            [self.dataModel setValue:text forKey:self.cellModel.key];
            if (self.cellModel.valueChangeBlock) {
                self.cellModel.valueChangeBlock();
            }
        }
    }
    
    return result;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        NSString *value = [self.dataModel valueForKey:self.cellModel.key]?:@"";
        if ([NSString isEmpty:value]) {
            result = [NSString stringWithFormat:@"请输入%@",self.cellModel.cellTitle];
            if (become) {
                [self.inputTextField becomeFirstResponder];
            }
        }
    }
    return result;
}

@end
