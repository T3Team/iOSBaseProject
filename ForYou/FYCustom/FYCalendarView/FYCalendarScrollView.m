//
//  FYCalendarScrollView.m
//  FYCalendarView
//
//  Created by ForYou on 2017/8/17.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import "FYCalendarScrollView.h"
#import "FYCalendarCell.h"
#import "FYCalendarMonth.h"
#import "NSDate+FYCategory.h"

@interface FYCalendarScrollView ()<UICollectionViewDataSource, UICollectionViewDelegate>

@property (nonatomic, strong) UICollectionView *collectionViewL;
@property (nonatomic, strong) UICollectionView *collectionViewM;
@property (nonatomic, strong) UICollectionView *collectionViewR;

@property (nonatomic, strong) NSDate *currentMonthDate;

@property (nonatomic, strong) NSMutableArray *monthArray;

//数组内样式 0000-00-00
//@property (nonatomic , strong) NSMutableArray *haveTrainArr;

@end

static NSString *const kCellIdentifier = @"FYCalendarCell";
#define color_white  [UIColor whiteColor]// 背景
#define color_today  [UIColor redColor]//  今天的字体颜色
#define color_black  [UIColor blackColor]//不是今天的字体颜色
#define color_gray  [UIColor grayColor]//不是本月的字体颜色
#define color_select [UIColor blueColor] //选中的color

@implementation FYCalendarScrollView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor clearColor];
        self.showsHorizontalScrollIndicator = NO;
        self.showsVerticalScrollIndicator = NO;
        self.pagingEnabled = YES;
        self.bounces = NO;
        self.delegate = self;
        self.contentSize = CGSizeMake(3 * self.bounds.size.width, self.bounds.size.height);
        [self setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO];
        _selectDate = [NSDate date];
        _currentMonthDate = [NSDate date];
        [self setupCollectionViews];
    }
    return self;
}

- (NSMutableArray *)monthArray {
    
    if (_monthArray == nil) {
        
        _monthArray = [NSMutableArray arrayWithCapacity:4];
        
        NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
        
        [_monthArray addObject:[[FYCalendarMonth alloc] initWithDate:previousMonthDate]];
        [_monthArray addObject:[[FYCalendarMonth alloc] initWithDate:_currentMonthDate]];
        [_monthArray addObject:[[FYCalendarMonth alloc] initWithDate:nextMonthDate]];
        [_monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]]; // 存储左边的月份的前一个月份的天数，用来填充左边月份的首部
        
        // 发通知，更改当前月份标题
        [self notifyToChangeCalendarHeader];
    }
    
    return _monthArray;
}

- (void)setCalendarBasicColor:(UIColor *)calendarBasicColor {
    _calendarBasicColor = calendarBasicColor;
    [_collectionViewL reloadData];
    [_collectionViewM reloadData];
    [_collectionViewR reloadData];
}

- (NSNumber *)previousMonthDaysForPreviousDate:(NSDate *)date {
    return [[NSNumber alloc] initWithInteger:[[date previousMonthDate] totalDaysInMonth]];
}

- (void)setupCollectionViews {
    
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.itemSize = CGSizeMake((self.bounds.size.width-20) / 7.0, (self.bounds.size.width -20)/ 7.0 * 0.6);
    flowLayout.minimumLineSpacing = 0.0;
    flowLayout.minimumInteritemSpacing = 0.0;
    
    CGFloat selfWidth = self.bounds.size.width;
    CGFloat selfHeight = self.bounds.size.height;
    
    _collectionViewL = [[UICollectionView alloc] initWithFrame:CGRectMake(10.0, 0.0, selfWidth-20, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewL.dataSource = self;
    _collectionViewL.delegate = self;
    _collectionViewL.backgroundColor = color_white;
    [_collectionViewL registerClass:[FYCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewL];
    
    _collectionViewM = [[UICollectionView alloc] initWithFrame:CGRectMake(selfWidth+10, 0.0, selfWidth-20, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewM.dataSource = self;
    _collectionViewM.delegate = self;
    _collectionViewM.backgroundColor = color_white;
    [_collectionViewM registerClass:[FYCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewM];
    
    _collectionViewR = [[UICollectionView alloc] initWithFrame:CGRectMake(2 * selfWidth+10, 0.0, selfWidth-20, selfHeight) collectionViewLayout:flowLayout];
    _collectionViewR.dataSource = self;
    _collectionViewR.delegate = self;
    _collectionViewR.backgroundColor = color_white;
    [_collectionViewR registerClass:[FYCalendarCell class] forCellWithReuseIdentifier:kCellIdentifier];
    [self addSubview:_collectionViewR];
    
}

#pragma mark - register notify

- (void)notifyToChangeCalendarHeader {
    
    FYCalendarMonth *currentMonthInfo = self.monthArray[1];
    
    NSMutableDictionary *userInfo = [NSMutableDictionary dictionaryWithCapacity:2];
    
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.year] forKey:@"year"];
    [userInfo setObject:[[NSNumber alloc] initWithInteger:currentMonthInfo.month] forKey:@"month"];
    
    NSNotification *notify = [[NSNotification alloc] initWithName:@"FYCalendar.ChangeCalendarHeaderNotification" object:nil userInfo:userInfo];
    [[NSNotificationCenter defaultCenter] postNotification:notify];
}


- (void)refreshToCurrentMonth {
    
    // 如果现在就在当前月份，则不执行操作
    FYCalendarMonth *currentMonthInfo = self.monthArray[1];
    if ((currentMonthInfo.month == [[NSDate date] dateMonth]) && (currentMonthInfo.year == [[NSDate date] dateYear])) {
        return;
    }
    
    _currentMonthDate = [NSDate date];
    
    NSDate *previousMonthDate = [_currentMonthDate previousMonthDate];
    NSDate *nextMonthDate = [_currentMonthDate nextMonthDate];
    
    [self.monthArray removeAllObjects];
    [self.monthArray addObject:[[FYCalendarMonth alloc] initWithDate:previousMonthDate]];
    [self.monthArray addObject:[[FYCalendarMonth alloc] initWithDate:_currentMonthDate]];
    [self.monthArray addObject:[[FYCalendarMonth alloc] initWithDate:nextMonthDate]];
    [self.monthArray addObject:[self previousMonthDaysForPreviousDate:previousMonthDate]];
    
    // 刷新数据
    [_collectionViewM reloadData];
    [_collectionViewL reloadData];
    [_collectionViewR reloadData];
}


#pragma mark - UICollectionDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 42; // 7 * 6
}


- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    FYCalendarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kCellIdentifier forIndexPath:indexPath];
    if (collectionView == _collectionViewL) {
        FYCalendarMonth *monthInfo = self.monthArray[0];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        if (_selectDate&&[_selectDate dateDay]==indexPath.row - firstWeekday + 1&&(monthInfo.month == [_selectDate dateMonth]) && (monthInfo.year == [_selectDate dateYear])) {
//            cell.selectImage.hidden = NO;
            cell.todayCircle.backgroundColor = color_select;
        }else{
            cell.todayCircle.backgroundColor = color_white;
        }
        
//        NSString *currentDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",monthInfo.year,monthInfo.month, indexPath.row - firstWeekday + 1];
//        if ([_haveTrainArr containsObject:currentDateStr]) {
//            cell.backView.layer.borderWidth=0.5;
//        }else{
//            cell.backView.layer.borderWidth=0;
//        }
        
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = color_black;
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayLabel.textColor = color_today;
//                    cell.todayLabel.text = @"今天";
//                    cell.todayLabel.font = [UIFont systemFontOfSize:12];
                    
                } else {
//                    if (indexPath.row > [[NSDate date] dateDay] + firstWeekday - 1){
//                        //今天之后
//                        cell.todayLabel.textColor = ST_COLOR_MINOR_TEXT_NEW;
//                    }else{
                        //                        今天之前
                        cell.todayCircle.backgroundColor = [UIColor clearColor];
                        //                        cell.backView.backgroundColor= [UIColor blackColor];
                        
//                    }
                }
            } else {
                BOOL istodayafter;
                if(monthInfo.year > [[NSDate date] dateYear]){
                    istodayafter=YES;
                }else if (monthInfo.year < [[NSDate date] dateYear]){
                    istodayafter = NO;
                }else{
                    istodayafter = (monthInfo.month > [[NSDate date] dateMonth])?YES:NO;
                }
                
                if (!istodayafter) {
                    //今天之前
                    //                    cell.backView.backgroundColor= [UIColor blackColor];
                }else{
                    //今天之后
                    //                    cell.backView.backgroundColor= [UIColor clearColor];
                    cell.todayLabel.textColor = color_black;
                }
            }
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            int totalDaysOflastMonth = [self.monthArray[3] intValue];
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = color_gray;
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            //            cell.backView.backgroundColor = [ UIColor clearColor];
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = color_gray;
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            //            cell.backView.backgroundColor = [ UIColor clearColor];
        }
        
        cell.userInteractionEnabled = NO;
        
    }
    else if (collectionView == _collectionViewM) {
        
        FYCalendarMonth *monthInfo = self.monthArray[1];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        if (_selectDate&&[_selectDate dateDay]==indexPath.row - firstWeekday + 1&&(monthInfo.month == [_selectDate dateMonth]) && (monthInfo.year == [_selectDate dateYear])) {
            cell.todayCircle.backgroundColor = color_select;
        }else{
            cell.todayCircle.backgroundColor = color_white;
        }
        
//        NSString *currentDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",monthInfo.year,monthInfo.month, indexPath.row - firstWeekday + 1];
//        if (![_haveTrainArr containsObject:currentDateStr]) {
//            cell.backView.layer.borderWidth=0;
//        }else{
//            cell.backView.layer.borderWidth=0.5f;
//        }
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = color_black;
            
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    cell.todayLabel.textColor = color_today;
//                    cell.todayLabel.text = @"今天";
                    //                    cell.backView.backgroundColor= [UIColor blackColor];
                    cell.userInteractionEnabled = YES;
                } else {
                    if (indexPath.row > [[NSDate date] dateDay] + firstWeekday - 1){
                        cell.todayLabel.textColor = color_black;
                        //                        cell.backView.backgroundColor= [UIColor clearColor];
                        cell.userInteractionEnabled = NO;
                    }else{
                        
                        cell.userInteractionEnabled = YES;
                    }
                }
            } else {
                BOOL istodayafter;
                if(monthInfo.year > [[NSDate date] dateYear]){
                    istodayafter=YES;
                }else if (monthInfo.year < [[NSDate date] dateYear]){
                    istodayafter = NO;
                }else{
                    istodayafter = (monthInfo.month > [[NSDate date] dateMonth])?YES:NO;
                }
                
                
                
                if (!istodayafter) {
                    cell.todayLabel.textColor = color_black;
                    //                    cell.backView.backgroundColor= [UIColor blackColor];
                    cell.userInteractionEnabled = YES;
                }else{
                    cell.todayLabel.textColor = color_black;
                    //                    cell.backView.backgroundColor= [UIColor clearColor];
                    cell.userInteractionEnabled = YES;
                }
                
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            int totalDaysOflastMonth = [self.monthArray[3] intValue];
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            cell.todayLabel.textColor = color_gray;
            //            cell.backView.backgroundColor = [ UIColor clearColor];
            cell.userInteractionEnabled = NO;
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday - totalDays + 1];
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            cell.todayLabel.textColor = color_gray;
            //            cell.backView.backgroundColor = [ UIColor clearColor];
            cell.userInteractionEnabled = NO;
        }
    }
    else if (collectionView == _collectionViewR) {
        
        FYCalendarMonth *monthInfo = self.monthArray[2];
        NSInteger firstWeekday = monthInfo.firstWeekday;
        NSInteger totalDays = monthInfo.totalDays;
        if (_selectDate&&[_selectDate dateDay]==indexPath.row - firstWeekday + 1&&(monthInfo.month == [_selectDate dateMonth]) && (monthInfo.year == [_selectDate dateYear])) {
            cell.todayCircle.backgroundColor = color_select;
        }else{
            cell.todayCircle.backgroundColor = color_white;
        }
        
//        NSString *currentDateStr = [NSString stringWithFormat:@"%ld-%02ld-%02ld",monthInfo.year,monthInfo.month, indexPath.row - firstWeekday + 1];
//        if (![_haveTrainArr containsObject:currentDateStr]) {
//            cell.backView.layer.borderWidth=0;
//        }else{
//            cell.backView.layer.borderWidth=0.5f;
//        }
        
        // 当前月
        if (indexPath.row >= firstWeekday && indexPath.row < firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday + 1];
            cell.todayLabel.textColor = color_black;
            
            
            // 标识今天
            if ((monthInfo.month == [[NSDate date] dateMonth]) && (monthInfo.year == [[NSDate date] dateYear])) {
                if (indexPath.row == [[NSDate date] dateDay] + firstWeekday - 1) {
                    //                    cell.todayCircle.backgroundColor = self.calendarBasicColor;
                    cell.todayLabel.textColor = color_today;
//                    cell.todayLabel.text = @"今天";
                    //                    cell.backView.backgroundColor= [UIColor blackColor];
                    
                } else {
                    if (indexPath.row > [[NSDate date] dateDay] + firstWeekday - 1){
                        cell.todayLabel.textColor = color_black;
                        //                        cell.backView.backgroundColor= [UIColor clearColor];
                    }else{
                        cell.backView.backgroundColor= [UIColor clearColor];
                    }
                }
            } else {
                BOOL istodayafter;
                if(monthInfo.year > [[NSDate date] dateYear]){
                    istodayafter=YES;
                }else if (monthInfo.year < [[NSDate date] dateYear]){
                    istodayafter = NO;
                }else{
                    istodayafter = (monthInfo.month > [[NSDate date] dateMonth])?YES:NO;
                }
                if (!istodayafter) {
                    //                    cell.todayLabel.textColor = [UIColor colorWithWhite:0.85 alpha:1.0];
                    //                    cell.backView.backgroundColor= [UIColor blackColor];
                }else{
//                    cell.todayLabel.textColor = color_black;
                    //                    cell.backView.backgroundColor= [UIColor clearColor];
                }
            }
            
        }
        // 补上前后月的日期，淡色显示
        else if (indexPath.row < firstWeekday) {
            int totalDaysOflastMonth = [self.monthArray[3] intValue];
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", totalDaysOflastMonth - (firstWeekday - indexPath.row) + 1];
            cell.todayLabel.textColor = color_gray;
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            //            cell.backView.backgroundColor = [ UIColor clearColor];
        } else if (indexPath.row >= firstWeekday + totalDays) {
            cell.todayLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row - firstWeekday - totalDays + 1];
            cell.todayLabel.textColor = color_gray;
            cell.todayCircle.backgroundColor = [UIColor clearColor];
            //            cell.backView.backgroundColor = [ UIColor clearColor];
        }
        cell.userInteractionEnabled = NO;
        
    }
    
    return cell;
    
}

#pragma mark - UICollectionViewDeleagate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelectDayHandler != nil) {
        
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSDateComponents *components = [calendar components:(NSCalendarUnitYear | NSCalendarUnitMonth) fromDate:_currentMonthDate];
        NSDate *currentDate = [calendar dateFromComponents:components];
        
        FYCalendarCell *cell = (FYCalendarCell *)[collectionView cellForItemAtIndexPath:indexPath];
        
        NSInteger year = [currentDate dateYear];
        NSInteger month = [currentDate dateMonth];
        NSInteger day = [cell.todayLabel.text integerValue];
        if (!day) {
            day = [[NSDate date] dateDay];
        }
        
        self.selectDate = [NSDate getDateWithyyyyMMddStr:[NSString stringWithFormat:@"%ld-%02ld-%02ld",year,month,day]];
        self.didSelectDayHandler(year, month, day); // 执行回调
        [_collectionViewM reloadData];
    }
}

#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    if (scrollView != self) {
        return;
    }
    
    // 向右滑动
    if (scrollView.contentOffset.x < self.bounds.size.width) {
        
        _currentMonthDate = [_currentMonthDate previousMonthDate];
        NSDate *previousDate = [_currentMonthDate previousMonthDate];
        
        // 数组中最左边的月份现在作为中间的月份，中间的作为右边的月份，新的左边的需要重新获取
        FYCalendarMonth *currentMothInfo = self.monthArray[0];
        FYCalendarMonth *nextMonthInfo = self.monthArray[1];
        
        
        FYCalendarMonth *olderNextMonthInfo = self.monthArray[2];
        
        // 复用FYCalendarMonth 对象
        olderNextMonthInfo.totalDays = [previousDate totalDaysInMonth];
        olderNextMonthInfo.firstWeekday = [previousDate firstWeekDayInMonth];
        olderNextMonthInfo.year = [previousDate dateYear];
        olderNextMonthInfo.month = [previousDate dateMonth];
        FYCalendarMonth *previousMonthInfo = olderNextMonthInfo;
        
        NSNumber *prePreviousMonthDays = [self previousMonthDaysForPreviousDate:[_currentMonthDate previousMonthDate]];
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    // 向左滑动
    else if (scrollView.contentOffset.x > self.bounds.size.width) {
        _currentMonthDate = [_currentMonthDate nextMonthDate];
        NSDate *nextDate = [_currentMonthDate nextMonthDate];
        // 数组中最右边的月份现在作为中间的月份，中间的作为左边的月份，新的右边的需要重新获取
        FYCalendarMonth *previousMonthInfo = self.monthArray[1];
        FYCalendarMonth *currentMothInfo = self.monthArray[2];
        FYCalendarMonth *olderPreviousMonthInfo = self.monthArray[0];
        
        NSNumber *prePreviousMonthDays = [[NSNumber alloc] initWithInteger:olderPreviousMonthInfo.totalDays]; // 先保存 olderPreviousMonthInfo 的月天数
        
        // 复用 GFCalendarMonth 对象
        olderPreviousMonthInfo.totalDays = [nextDate totalDaysInMonth];
        olderPreviousMonthInfo.firstWeekday = [nextDate firstWeekDayInMonth];
        olderPreviousMonthInfo.year = [nextDate dateYear];
        olderPreviousMonthInfo.month = [nextDate dateMonth];
        FYCalendarMonth *nextMonthInfo = olderPreviousMonthInfo;
        
        
        [self.monthArray removeAllObjects];
        [self.monthArray addObject:previousMonthInfo];
        [self.monthArray addObject:currentMothInfo];
        [self.monthArray addObject:nextMonthInfo];
        [self.monthArray addObject:prePreviousMonthDays];
        
    }
    
    [_collectionViewM reloadData]; // 中间的 collectionView 先刷新数据
    [scrollView setContentOffset:CGPointMake(self.bounds.size.width, 0.0) animated:NO]; // 然后变换位置
    [_collectionViewL reloadData]; // 最后两边的 collectionView 也刷新数据
    [_collectionViewR reloadData];
    
    // 发通知，更改当前月份标题
    [self notifyToChangeCalendarHeader];
    
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
