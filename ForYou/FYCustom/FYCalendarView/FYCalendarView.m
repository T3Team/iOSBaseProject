//
//  FYCalendarView.m
//  FYCalendarView
//
//  Created by ForYou on 2017/8/17.
//  Copyright © 2017年 marcus. All rights reserved.
//

#import "FYCalendarView.h"
#import "FYCalendarScrollView.h"
#import "NSDate+FYCategory.h"

@interface FYCalendarView()

@property (nonatomic, strong) UIButton *calendarHeaderButton;
@property (nonatomic, strong) UIView *weekHeaderView;
@property (nonatomic, strong) FYCalendarScrollView *calendarScrollView;

@property (nonatomic, strong) UILabel *titleLb;

@end
#define kDefaultCalendarBasicColor [UIColor colorWithRed:231.0 / 255.0 green:85.0 / 255.0 blue:85.0 / 255.0 alpha:1.0]
@implementation FYCalendarView
- (void)dealloc {
    // 移除监听
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrameOrigin:(CGPoint)origin width:(CGFloat)width {
    
    // 根据宽度计算 calender 主体部分的高度
    CGFloat weekLineHight = 0.6 * (width / 7.0);
    CGFloat monthHeight = 6 * weekLineHight;
    // 星期头部栏高度
    CGFloat weekHeaderHeight = 60;
    
    //    // calendar 头部栏高度
    //    CGFloat calendarHeaderHeight = 0.8 * weekLineHight;
    
    // 最后得到整个 calender 控件的高度
    _calendarHeight = 5 + weekHeaderHeight + monthHeight;
    
    if (self = [super initWithFrame:CGRectMake(origin.x, origin.y, width, _calendarHeight)]) {
        
        self.calendarBasicColor = kDefaultCalendarBasicColor;
        
        _weekHeaderView = [self setupWeekHeadViewWithFrame:CGRectMake(0.0, 0, width, weekHeaderHeight)];
        _calendarScrollView = [self setupCalendarScrollViewWithFrame:CGRectMake(0.0, 5 + weekHeaderHeight, width, monthHeight)];
        
        //        [self addSubview:_calendarHeaderButton];
        [self addSubview:_weekHeaderView];
        [self addSubview:_calendarScrollView];
        
        // 注册 Notification 监听
        [self addNotificationObserver];
        
    }
    
    return self;
    
}
- (UIButton *)setupCalendarHeaderButtonWithFrame:(CGRect)frame {
    
    
    
    
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = frame;
    button.backgroundColor = self.calendarBasicColor;
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.titleLabel.font = [UIFont systemFontOfSize:16.0];
    [button addTarget:self action:@selector(refreshToCurrentMonthAction:) forControlEvents:UIControlEventTouchUpInside];
    
    return button;
}

- (UIView *)setupWeekHeadViewWithFrame:(CGRect)frame {
    CGFloat width = (frame.size.width-20) / 7.0;
    
    UIView *view = [[UIView alloc] initWithFrame:frame];
    view.backgroundColor = self.calendarBasicColor;
    
    _titleLb = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
    _titleLb.text = [NSString stringWithFormat:@"%li - %li",[NSDate date].dateYear,[NSDate date].dateMonth];
    _titleLb.textAlignment = NSTextAlignmentCenter;
    _titleLb.textColor = [UIColor blackColor];
    [view addSubview:_titleLb];
    
    
    
    NSArray *weekArray = @[@"日", @"一", @"二", @"三", @"四", @"五", @"六"];
    for (int i = 0; i < 7; ++i) {
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(i * width+10, 30.0, width, 30)];
        label.backgroundColor = [UIColor clearColor];
        label.text = weekArray[i];
        label.textColor = [UIColor blackColor];
        label.font = [UIFont systemFontOfSize:13.5];
        label.textAlignment = NSTextAlignmentCenter;
        [view addSubview:label];
    }
    return view;
}

- (FYCalendarScrollView *)setupCalendarScrollViewWithFrame:(CGRect)frame {
    FYCalendarScrollView *scrollView = [[FYCalendarScrollView alloc] initWithFrame:frame];
    scrollView.calendarBasicColor = self.calendarBasicColor;
    return scrollView;
}

- (void)setCalendarBasicColor:(UIColor *)calendarBasicColor {
    _calendarBasicColor = calendarBasicColor;
    self.layer.borderColor = calendarBasicColor.CGColor;
    _calendarHeaderButton.backgroundColor = calendarBasicColor;
    _weekHeaderView.backgroundColor = calendarBasicColor;
    _calendarScrollView.calendarBasicColor = calendarBasicColor; // 传递颜色
}

- (void)setDidSelectDayHandler:(DidSelectDayHandler)didSelectDayHandler {
    _didSelectDayHandler = didSelectDayHandler;
    if (_calendarScrollView != nil) {
        _calendarScrollView.didSelectDayHandler = _didSelectDayHandler; // 传递 block
    }
}

- (void)addNotificationObserver {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeCalendarHeaderAction:) name:@"FYCalendar.ChangeCalendarHeaderNotification" object:nil];
}

#pragma mark - Actions

- (void)refreshToCurrentMonthAction:(UIButton *)sender {
    
    NSInteger year = [[NSDate date] dateYear];
    NSInteger month = [[NSDate date] dateMonth];
    
    NSString *title = [NSString stringWithFormat:@"%ld年%ld月", year, month];
    [_calendarHeaderButton setTitle:title forState:UIControlStateNormal];
    [_calendarScrollView refreshToCurrentMonth];
    
}

- (void)changeCalendarHeaderAction:(NSNotification *)sender {
    NSDictionary *dic = sender.userInfo;
    NSNumber *year = dic[@"year"];
    NSNumber *month = dic[@"month"];
    NSString *title = [NSString stringWithFormat:@"%@年%@月", year, month];
    [_calendarHeaderButton setTitle:title forState:UIControlStateNormal];
    
    _titleLb.text = [NSString stringWithFormat:@"%li - %li",[year integerValue],[month integerValue]];
}


//-(void)addDateObjectArr:(NSArray *)arr{
//    [self.calendarScrollView addTrainArrWithArr:arr];
//}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
