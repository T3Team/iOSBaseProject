//
//  FYAlertListView.m
//  ForYou
//
//  Created by marcus on 2017/7/27.
//  Copyright © 2017年 ForYou. All rights reserved.
//

#import "FYAlertListView.h"
#import "FYAlertListViewCell.h"
#import "Masonry.h"

static NSString *kFYAlertListViewCellID = @"FYAlertListViewCellID";

@interface FYAlertListView()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, strong) NSMutableArray *titleArray;
@property (nonatomic, strong) NSMutableArray *descriptionsArray;
@property (nonatomic, assign) NSInteger selectIndex;
@property (nonatomic, strong) UIView *convertView;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation FYAlertListView

#pragma mark - public methods
+ (FYAlertListView *)alertListViewWithTitle:(NSString *)title optionTitles:(NSArray *)titles optionDescription:(NSArray *)descriptions {
    NSArray *objs = [[NSBundle mainBundle] loadNibNamed:@"FYAlertListView" owner:nil options:nil];
    FYAlertListView *alertListView = [objs lastObject];
    [alertListView defaultStyle];
    [alertListView reloadViewWithTitle:title optionTitles:titles optionDescriptions:descriptions];
    return alertListView;
    
}

- (void)show {
    UIWindow *window = [[UIApplication sharedApplication] keyWindow]?:[UIApplication sharedApplication].windows[0];
    self.convertView = [[UIView alloc] initWithFrame:window.bounds];
    self.convertView.backgroundColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.5];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(cancelClick)];
    [self.convertView addGestureRecognizer:tap];
    [window addSubview:self.convertView];
    [window addSubview:self];
    
    [self mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@290);
        make.height.equalTo(@300);
        make.centerX.equalTo(window);
        make.centerY.equalTo(window);
    }];
}


#pragma mark - private methods
- (void)reloadViewWithTitle:(NSString *)title optionTitles:(NSArray *)titles optionDescriptions:(NSArray *)descriptions {
    self.titleLabel.text = title;
    self.titleArray = [NSMutableArray arrayWithArray:titles?:@[]];
    self.descriptionsArray = [NSMutableArray arrayWithArray:descriptions?:@[]];
   
    [self.tableView reloadData];
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    if (self.titleArray.count>0) {
        [self.tableView selectRowAtIndexPath:indexPath animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)defaultStyle {
    self.selectIndex = 0;
    [self.tableView registerNib:[UINib nibWithNibName:@"FYAlertListViewCell" bundle:nil] forCellReuseIdentifier:kFYAlertListViewCellID];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.confirmButton.layer setCornerRadius:3];
    [self.layer setCornerRadius:5];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FYAlertListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kFYAlertListViewCellID];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    NSString *title = (self.titleArray&&self.titleArray.count>indexPath.row)?self.titleArray[indexPath.row]:@"";
    NSString *description = (self.descriptionsArray&&self.descriptionsArray.count>indexPath.row)?self.descriptionsArray[indexPath.row]:@"";
    [cell reloadCellWithTitle:title description:description];
    return cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.selectIndex = indexPath.row;
}


#pragma mark - evevt response
- (IBAction)confirmButtonClick:(UIButton *)sender {
    if (self.confimBlock) {
        self.confimBlock(self.selectIndex);
    }
    [self removeFromSuperview];
    [self.convertView removeFromSuperview];
}

- (void)cancelClick {
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
    [self.convertView removeFromSuperview];
}
@end
