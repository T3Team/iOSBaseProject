//
//  FYRangeInputCollectionCell.m
//  ForYou
//
//  Created by marcus on 2017/9/25.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYRangeInputCollectionCell.h"
#import "FYHeader.h"

@interface FYRangeInputCollectionCell()
@property (weak, nonatomic) IBOutlet UIView *lineView;

@end

@implementation FYRangeInputCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.minTextField.layer setCornerRadius:3];
    [self.minTextField.layer setBorderColor:[color_gray_dddddd CGColor]];
    [self.minTextField.layer setBorderWidth:1];
    [self.maxTextField.layer setCornerRadius:3];
    [self.maxTextField.layer setBorderColor:[color_gray_dddddd CGColor]];
    [self.maxTextField.layer setBorderWidth:1];
    [self.minTextField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    [self.maxTextField addTarget:self action:@selector(textFieldValueChanged) forControlEvents:UIControlEventEditingChanged];
    
    
    //改变占位符的颜色并给占位符赋值
    NSAttributedString *attrString = [[NSAttributedString alloc] initWithString:@"最小" attributes:
                                      @{NSForegroundColorAttributeName:color_gray_c5c5c5,
                                        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                        }];
    self.minTextField.attributedPlaceholder = attrString;
    
    NSAttributedString *attrString1 = [[NSAttributedString alloc] initWithString:@"最大" attributes:
                                      @{NSForegroundColorAttributeName:color_gray_c5c5c5,
                                        NSFontAttributeName:[UIFont systemFontOfSize:15.0]
                                        }];
    self.maxTextField.attributedPlaceholder = attrString1;
}

- (void)textFieldValueChanged {
    if (![NSString isEmpty: self.minTextField.text] || ![NSString isEmpty: self.maxTextField.text]) {
        if (self.valueChangeBlock) {
            self.valueChangeBlock();
        }
    }
    [self refreshView];
}

- (void)refreshView {
    if ([NSString isEmpty: self.minTextField.text] && [NSString isEmpty: self.maxTextField.text]) {
        [self.minTextField.layer setBorderColor:[color_gray_dddddd CGColor]];
        [self.maxTextField.layer setBorderColor:[color_gray_dddddd CGColor]];
        self.lineView.backgroundColor = color_black6;
    }else {
        [self.minTextField.layer setBorderColor:[color_red_e8382b CGColor]];
        [self.maxTextField.layer setBorderColor:[color_red_e8382b CGColor]];
        self.lineView.backgroundColor = color_red_e8382b;
    }
}

@end
