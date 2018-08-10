//
//  FYInputRangeTableCell.m
//  ForYou
//
//  Created by marcus on 2017/9/20.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYInputRangeTableCell.h"
#import <CoreText/CoreText.h>

@interface FYInputRangeTableCell()<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *unitLabel;
@property (weak, nonatomic) IBOutlet UIView *line;
@property (weak, nonatomic) IBOutlet UIImageView *mustInputMark;

@end

@implementation FYInputRangeTableCell

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)refreshDataWithTableModel:(FYTableViewCellModel *)cellModel dataModel:(id)dataModel  {
    [super refreshDataWithTableModel:cellModel dataModel:dataModel];
    self.titleLabel.text = cellModel.cellTitle;
    self.line.hidden = !cellModel.showLine;
    self.unitLabel.text = cellModel.unit;
    self.mustInputMark.hidden = !self.cellModel.mustInput;
    self.startTextField.text = [self minValueWithData:[self.dataModel objectForKey:self.cellModel.key]]?:@"";
    self.endTextField.text = [self maxValueWithData:[self.dataModel objectForKey:self.cellModel.key]]?:@"";
    self.startTextField.delegate = self;
    self.endTextField.delegate = self;
    if ([self.cellModel.cellTitle isEqualToString:@"户型"]) {
        self.startTextField.keyboardType = UIKeyboardTypeNumberPad;
        self.endTextField.keyboardType = UIKeyboardTypeNumberPad;
    }else {
        self.startTextField.keyboardType = UIKeyboardTypeDecimalPad;
        self.endTextField.keyboardType = UIKeyboardTypeDecimalPad;
    }
}

/**
 获得第一相应
 
 @param tag 标签
 */
- (void)becomeFirstResponderWithTag:(NSString *)tag {
    if (tag == 0) {
        [self.startTextField becomeFirstResponder];
    }else {
        [self.endTextField becomeFirstResponder];
    }
}

- (NSString *)minValueWithData:(NSString *)data {
    NSString *minValue = nil;
    NSArray *array = [data componentsSeparatedByString:@"-"];
    if (array && array.count>0) {
        NSString * temp = array[0];
        if (![NSString isEmpty:temp]) {
            minValue = temp;
        }
    }
    return minValue;
}

- (NSString *)maxValueWithData:(NSString *)data {
    NSString *maxValue = nil;
    NSArray *array = [data componentsSeparatedByString:@"-"];
    if (array && array.count>1) {
        NSString * temp = array[1];
        if (![NSString isEmpty:temp]) {
            maxValue = temp;
        }
    }
    return maxValue;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    BOOL result = YES;
    
    result =  [NSString inputDecimalsVerify:textField.text string:string rang:range lenthMax:0];
    
    NSString *text = textField.text;
    if (result) {
        if (![string isEqualToString:@""]) {
            text = [text stringByAppendingString:string];
        }
        else {
            text = [text stringByReplacingCharactersInRange:range withString:string];
        }
    }
    
    if (result && ![NSString isEmpty:text]) {
        CGFloat tempText = [text floatValue];
        if ([self.cellModel.cellTitle isEqualToString:@"户型"]) {
            if (tempText>=100) {
                result = NO;
            }
        }else if([self.cellModel.cellTitle isEqualToString:@"面积"]) {
            if (tempText>=10000000000) {
                result = NO;
            }
        }else if([self.cellModel.cellTitle isEqualToString:@"预算"]) {
            if (tempText>=100000 && [self.cellModel.unit isEqualToString:@"万元"]) {
                result = NO;
            }else if(tempText>=100000000){
                result = NO;
            }
        }
    }
    
    if (self.cellModel && self.dataModel && result) {
        NSString *startText = self.startTextField.text?:@" ";
        NSString *endText = self.endTextField.text?:@" ";
        if (textField == self.startTextField) {
            startText = text?:@" ";
        }else {
            endText = text?:@" ";
        }
        [self.dataModel setValue:[NSString stringWithFormat:@"%@-%@",startText,endText] forKey:self.cellModel.key];
        if (self.cellModel.valueChangeBlock) {
            self.cellModel.valueChangeBlock();
        }
    }
    return result;
}

- (NSString *)checkMustInputBecomeFirstResponder:(BOOL)become {
    NSString *result = nil;
    if (self.cellModel.mustInput) {
        NSString *minValue = [self minValueWithData:[self.dataModel objectForKey:self.cellModel.key]]?:@"";
        NSString *maxValue = [self maxValueWithData:[self.dataModel objectForKey:self.cellModel.key]]?:@"";
        if ([NSString isEmpty:minValue] && [NSString isEmpty:maxValue]) {
            result = [NSString stringWithFormat:@"请输入%@",self.cellModel.cellTitle];
            if (become) {
                if ([NSString isEmpty:minValue]) {
                    [self.startTextField becomeFirstResponder];
                }else {
                    [self.endTextField becomeFirstResponder];
                }
            }
        }
    }
    return result;
}

@end
