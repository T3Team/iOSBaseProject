//
//  FYPhotoItemCanDeleteCollectionCell.m
//  ForYou
//
//  Created by marcus on 2018/1/10.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYPhotoItemCanDeleteCollectionCell.h"
#import "FYHeader.h"

@interface FYPhotoItemCanDeleteCollectionCell()
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIButton *deleteButton;
@end

@implementation FYPhotoItemCanDeleteCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.canEdit = YES;
}


- (void)refreshViewWithData:(FYImageModel*)imageModel {
    if (!self.isAdd) {
        NSString *imagePath = @"";
        if (![NSString isEmpty:imageModel.localPath]) {
            imagePath = imageModel.localPath;
        }else {
            if (![NSString isEmpty:imageModel.urlString]) {
                imagePath = imageModel.urlString;
            }
        }
        
        if ([imagePath containsString:@"http"]) {
            [self.imageView sd_setImageWithURL:[NSURL URLWithString:imagePath] placeholderImage:image_list_default];
        } else {
            UIImage *image = [UIImage imageNamed:imagePath];
            if (!image) {
                [UIImage imageWithContentsOfFile:imagePath];
            }
            self.imageView.image = image;
        }
        self.deleteButton.hidden = !self.canEdit;
    } else {
        [self.imageView setImage:icon_add_big];
        self.deleteButton.hidden = YES;
    }
}

- (IBAction)deleteButtonClick:(UIButton *)sender {
    if (self.deleteImageBlock) {
        self.deleteImageBlock(self.index);
    }
}

@end
