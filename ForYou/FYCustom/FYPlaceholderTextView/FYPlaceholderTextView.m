//
//  FYPlaceholderTextView.m
//  ForYou
//
//  Created by marcus on 2017/8/23.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYPlaceholderTextView.h"
#import "FYColors.h"

@implementation FYPlaceholderTextView

#pragma mark - initialize
- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addObserver];
    }
    return self;
}

- (instancetype)init
{
    if (self = [super init]) {
        [self addObserver];
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addObserver];
}

#pragma mark - getters and setters
- (void)setPlaceholder:(NSString *)placeholder
{
    _placeholder = placeholder;
    self.text = placeholder;
    self.textColor = color_text_3gray;
}

#pragma mark - private method
-(void)addObserver
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didBeginEditing:)
                                                 name:UITextViewTextDidBeginEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(didEndEditing:)
                                                 name:UITextViewTextDidEndEditingNotification
                                               object:self];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(terminate:)
                                                 name:UIApplicationWillTerminateNotification
                                               object:[UIApplication sharedApplication]];
    
}

- (void)terminate:(NSNotification *)notification
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didBeginEditing:(NSNotification *)notification
{
    if ([self.text isEqualToString:self.placeholder]) {
        self.text = @"";
        self.textColor = color_black3;
    }
}

- (void)didEndEditing:(NSNotification *)notification {
    if (self.text.length<1) {
        self.text = self.placeholder;
        self.textColor = color_text_3gray;
    }
}


@end
