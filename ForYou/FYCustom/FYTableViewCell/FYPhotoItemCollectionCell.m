//
//  FYPhotoItemCollectionCell.m
//  ForYou
//
//  Created by marcus on 2017/8/31.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYPhotoItemCollectionCell.h"
#import "FYHeader.h"

@interface FYPhotoItemCollectionCell()

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@end

@implementation FYPhotoItemCollectionCell

- (void)awakeFromNib {
    [super awakeFromNib];
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
        if (!imageModel.isHideImageTag) {
            self.tagLabel.hidden = NO;
            self.tagLabel.text = ![NSString isEmpty:imageModel.imageTagName]?imageModel.imageTagName:@"无标签";
        }else {
            self.tagLabel.hidden = YES;
        }
        
    } else {
        [self.imageView setImage:image_add_photo];
        self.tagLabel.hidden = YES;
    }
    
}


@end
