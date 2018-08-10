//
//  FYGuideView.m
//  ForYou
//
//  Created by marcus on 2018/2/7.
//  Copyright © 2018年 ForYou. All rights reserved.
//

#import "FYGuideView.h"
#import "FYHeader.h"
@interface FYGuideView ()

@property (nonatomic , strong) UIView *toView;

@property (nonatomic , copy) NSString *title;

@property (nonatomic , strong) UIImage *image;

@property (nonatomic , strong) UIImage *toImage;
@property (nonatomic , assign) BOOL isRound;
@property (nonatomic , assign) CGFloat cornerRadius;

@property (nonatomic , assign) CGRect toFrame;
@property (nonatomic, strong) UIImageView *toImageView;

@end


@implementation FYGuideView
{
    CGRect toViewFrame;
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
+(instancetype)showGuideViewWithView:(UIView *)view title:(NSString *)title image:(UIImage *)image toImage:(UIImage *)toImage isRound:(BOOL)isRound cornerRadius:(CGFloat)cornerRadius toFrame:(CGRect)toFrame{
    FYGuideView *guideView = [[FYGuideView alloc]init];
    guideView.toView = view;
    guideView.title = title;
    guideView.image = image;
    guideView.toImage = toImage;
    guideView.isRound = isRound;
    guideView.cornerRadius = cornerRadius;
    guideView.toFrame = toFrame;
    [guideView calculatorFrame];
    [guideView showView];

    return guideView;
}

-(void)calculatorFrame{
    if (_toView) {
        toViewFrame = [self.toView convertRect:_toView.bounds toView:[UIViewController currentViewController].view];
    }else{
        toViewFrame = self.toFrame;
    }
    //文字的最大宽度
    CGFloat maxwidth = ScreenWidth -32 - 79-32;
    //label的宽高
    CGFloat  width =  [self.title stringLengthWithFont:[UIFont systemFontOfSize:15]];
    CGFloat height = [self.title heightWithFont:[UIFont systemFontOfSize:15] maxWidth:maxwidth];
    if (width >maxwidth) {
        width = maxwidth;
    }
    
//    计算背景View的frame
    CGFloat orginX = 0;
    CGFloat orginY = 0;
    CGFloat widthView = width +79 +32;
    CGFloat HeightView = height +36;
    UIBezierPath *path = [[UIBezierPath alloc] init];
    if (toViewFrame.origin.y>300) {
        orginY = toViewFrame.origin.y - 27- height - 36+1;
        //path移动到开始画图的位置
        [path moveToPoint:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2, toViewFrame.origin.y-15)];
        //从开始位置画一条直线到（rect.origin.x + rect.size.width， rect.origin.y）
        [path addLineToPoint:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2-10, toViewFrame.origin.y-27)];
        
        [path addLineToPoint:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2+10, toViewFrame.origin.y-27)];
        //关闭path
        [path closePath];
    }else{
        orginY = toViewFrame.origin.y +toViewFrame.size.height +27-1;
        //path移动到开始画图的位置
        [path moveToPoint:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2, toViewFrame.origin.y+toViewFrame.size.height +15)];
        
        //从开始位置画一条直线到（rect.origin.x + rect.size.width， rect.origin.y）
        
        [path addLineToPoint:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2-10, toViewFrame.origin.y+toViewFrame.size.height +27)];
        
        [path addLineToPoint:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2+10, toViewFrame.origin.y+toViewFrame.size.height +27)];
        //关闭path
        [path closePath];
        //三角形内填充颜色
    }
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = path.CGPath;
    shapeLayer.fillColor = color_white.CGColor;
    //    shapeLayer.strokeColor =color_red_e8382b.CGColor;
    //添加图层蒙板
    [self.layer addSublayer:shapeLayer];
    
    if (toViewFrame.origin.x + toViewFrame.size.width/2<ScreenWidth/2) {
        orginX = 16;
    }else{
        orginX = ScreenWidth - 16 - widthView;
    }
        
    UIView *backgroundView = [[UIView alloc]initWithFrame:CGRectMake(orginX, orginY, widthView, HeightView)];
    backgroundView.backgroundColor = color_white;
    backgroundView.clipsToBounds = YES;
    backgroundView.layer.cornerRadius = 5;
    [self addSubview:backgroundView];
    
    UILabel *label = [UILabel new];
    label.numberOfLines = 0;
    label.font =  [UIFont systemFontOfSize:15];
    label.textColor = color_black3;
    label.text =_title;
    [backgroundView addSubview:label];
    label.frame = CGRectMake(16, 18, width, height);
    
    UIView *line = [[UIView alloc]initWithFrame:CGRectMake(width+32, 18, 1, height)];
    line.backgroundColor = color_line;
    [backgroundView addSubview:line];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(width+32, 0, 79, HeightView);
    [btn setTitle:@"知道了" forState:UIControlStateNormal];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [btn setTitleColor:color_red_ea4c40 forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(knownSomething) forControlEvents:UIControlEventTouchUpInside];
    [backgroundView addSubview:btn];
    
    if (self.image) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake( orginX, orginY-self.image.size.height, self.image.size.width, self.image.size.height)];
        imageView.image = self.image;
        [self addSubview:imageView];
    } 
}

-(void) removeAll{
    [self.toImageView removeFromSuperview];
    [self removeFromSuperview];
}

-(void)knownSomething{
    if (self.knownBlock) {
        self.knownBlock();
    }
    [self.toImageView removeFromSuperview];
    [self removeFromSuperview];
}

-(void) showView{
    UIWindow *window = [UIApplication sharedApplication].delegate.window;
    [window addSubview:self];
    UIBezierPath *bpath = [UIBezierPath bezierPathWithRect:CGRectMake(0, 0, ScreenWidth, ScreenHeight)];

    if (_isRound) {
        //中间添加一个圆形
        [bpath appendPath:[UIBezierPath bezierPathWithArcCenter:CGPointMake(toViewFrame.origin.x+toViewFrame.size.width/2, toViewFrame.origin.y+toViewFrame.size.height/2) radius:self.cornerRadius startAngle:0 endAngle:2*M_PI clockwise:NO]];
    }else{
        //贝塞尔曲线 画一个矩形
        [bpath appendPath:[[UIBezierPath bezierPathWithRoundedRect:toViewFrame cornerRadius:self.cornerRadius] bezierPathByReversingPath]];
    }
  
    //创建一个CAShapeLayer 图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.path = bpath.CGPath;
//    shapeLayer.strokeColor =color_red_e8382b.CGColor;
    //添加图层蒙板
    self.layer.mask = shapeLayer;
    
    if (self.toImage) {
        self.toImageView = [[UIImageView alloc] initWithFrame:CGRectMake( toViewFrame.origin.x+toViewFrame.size.width/2, toViewFrame.origin.y+toViewFrame.size.height/2, self.toImage.size.width, self.toImage.size.height)];
        self.toImageView.image = self.toImage;
        [window addSubview:self.toImageView];
    }
}
//-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
//    [self removeFromSuperview];
//}

-(instancetype)init{
    self = [super init];
    if (self) {
        self.frame = CGRectMake(0, 0, ScreenWidth, ScreenHeight);
        self.backgroundColor = color_black_alpha4;
    }
    return self;
}


- (void)drawRect:(CGRect)rect {
    // Drawing code
//    CGContextRef con = UIGraphicsGetCurrentContext();
    
}

@end
