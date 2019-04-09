//
//  HYWordClockYViewController.m
//  HYWordClockDemo
//
//  Created by axc on 2019/4/7.
//  Copyright © 2019 axc. All rights reserved.
//

#import "HYWordClockYViewController.h"

@interface HYWordClockYViewController ()

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) NSMutableArray *backGViewsArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *noonLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation HYWordClockYViewController

- (void)dealloc {
    NSLog(@"dealloc_____%@",[self class]);
    dispatch_source_cancel(self.timer);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"字时钟";
    self.view.backgroundColor = [UIColor blackColor];
    self.labelsArray = [NSMutableArray new];
    self.backGViewsArray = [NSMutableArray  new];
    
    [self setupUI];
    [self createTimer];
}

- (void)createTimer {
    //应用进入后台定时器不会走
    //创建队列
    dispatch_queue_t queue = dispatch_get_main_queue();
    //创建GCD中的定时器
    dispatch_source_t timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    //设置计时器
    dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, 1.0 * NSEC_PER_SEC, 0 * NSEC_PER_SEC);
    
    __weak typeof(self) weakSelf = self;
    //设置计时器的里操作事件
    dispatch_source_set_event_handler(timer, ^{
        [weakSelf dealLogic];
    });
    //开启定时器
    dispatch_resume(timer);
    
    self.timer = timer;
}

- (void)dealLogic {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierGregorian];
    NSDateComponents *monthComponent = [calendar components:NSCalendarUnitMonth fromDate:[NSDate date]];
    NSDateComponents *dayComponent = [calendar components:NSCalendarUnitDay fromDate:[NSDate date]];
    NSDateComponents *weekComponent = [calendar components:NSCalendarUnitWeekday fromDate:[NSDate date]];
    NSDateComponents *hourComponent = [calendar components:NSCalendarUnitHour fromDate:[NSDate date]];
    NSDateComponents *minuteComponent = [calendar components:NSCalendarUnitMinute fromDate:[NSDate date]];
    NSDateComponents *secondComponent = [calendar components:NSCalendarUnitSecond fromDate:[NSDate date]];
    
    if (self.monthLabel) {
        self.monthLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *monthLabel = [self.labelsArray objectAtIndex:monthComponent.month - 1];
    monthLabel.textColor = [UIColor whiteColor];
    self.monthLabel = monthLabel;
    UIView *monthBackGView = [self.backGViewsArray objectAtIndex:0];
    monthBackGView.transform = CGAffineTransformMakeRotation((((monthComponent.month - 1) * (360.f / 12.f)) / 180.0) * M_PI);
    
    if (self.dayLabel) {
        self.dayLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *dayLabel = [self.labelsArray objectAtIndex:12 + dayComponent.day - 1];
    dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel = dayLabel;
    UIView *dayBackGView = [self.backGViewsArray objectAtIndex:1];
    dayBackGView.transform = CGAffineTransformMakeRotation((((dayComponent.day - 1) * (360.f / 31.f)) / 180.0) * M_PI);
    
    if (self.weekLabel) {
        self.weekLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *weekLabel = [self.labelsArray objectAtIndex:12 + 31 + ((weekComponent.weekday == 1) ? 7 : weekComponent.weekday - 1) - 1];
    weekLabel.textColor = [UIColor whiteColor];
    self.weekLabel = weekLabel;
    UIView *weekBackGView = [self.backGViewsArray objectAtIndex:2];
    weekBackGView.transform = CGAffineTransformMakeRotation((((((weekComponent.weekday == 1) ? 7 : weekComponent.weekday - 1) - 1) * (360.f / 7.f)) / 180.0) * M_PI);
    
    if (self.noonLabel) {
        self.noonLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *noonLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + ((hourComponent.hour > 12) ? 2 : 1) - 1];
    noonLabel.textColor = [UIColor whiteColor];
    self.noonLabel = noonLabel;
    UIView *noonBackGView = [self.backGViewsArray objectAtIndex:3];
    noonBackGView.transform = CGAffineTransformMakeRotation((((((hourComponent.hour > 12) ? 2 : 1) - 1) * (360.f / 60.f)) / 180.0) * M_PI);
    
    if (self.hourLabel) {
        self.hourLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *hourLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + 2 + ((hourComponent.hour > 12) ? (hourComponent.hour - 12) : hourComponent.hour) - 1];
    hourLabel.textColor = [UIColor whiteColor];
    self.hourLabel = hourLabel;
    UIView *hourBackGView = [self.backGViewsArray objectAtIndex:4];
    hourBackGView.transform = CGAffineTransformMakeRotation((((((hourComponent.hour > 12) ? (hourComponent.hour - 12) : hourComponent.hour) - 1) * (360.f / 12.f)) / 180.0) * M_PI);
    
    if (self.minuteLabel) {
        self.minuteLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    if (minuteComponent.minute != 0) {
        UILabel *minuteLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + 2 + 12 + minuteComponent.minute - 1];
        minuteLabel.textColor = [UIColor whiteColor];
        self.minuteLabel = minuteLabel;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
            UIView *minuteBackGView = [self.backGViewsArray objectAtIndex:5];
            minuteBackGView.transform = CGAffineTransformMakeRotation((((minuteComponent.minute - 1) * (360.f / 60.f)) / 180.0) * M_PI);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
            UIView *minuteBackGView = [self.backGViewsArray objectAtIndex:5];
            minuteBackGView.transform = CGAffineTransformMakeRotation(((59 * (360.f / 60.f)) / 180.0) * M_PI);
        } completion:^(BOOL finished) {
            
        }];
    }
    
    if (self.secondLabel) {
        self.secondLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    if (secondComponent.second != 0) {
        UILabel *secondLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + 2 + 12 + 59 +  secondComponent.second - 1];
        secondLabel.textColor = [UIColor whiteColor];
        self.secondLabel = secondLabel;
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
            UIView *secondBackGView = [self.backGViewsArray objectAtIndex:6];
            secondBackGView.transform = CGAffineTransformMakeRotation((((secondComponent.second - 1) * (360.f / 60.f)) / 180.0) * M_PI);
        } completion:^(BOOL finished) {
            
        }];
    } else {
        [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:2.5 options:UIViewAnimationOptionCurveLinear animations:^{
            UIView *secondBackGView = [self.backGViewsArray objectAtIndex:6];
            secondBackGView.transform = CGAffineTransformMakeRotation(((59 * (360.f / 60.f)) / 180.0) * M_PI);
        } completion:^(BOOL finished) {
            
        }];
    }
}

- (void)setupUI {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Word" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    CGPoint centerPoint = CGPointMake(self.view.frame.size.height / 2, self.view.frame.size.height / 2);
    CGFloat radius = 50.f;
    CGFloat kHeight = 20.f;
    CGFloat maxWidth = 100.f;
    CGFloat labelMaxWidth = 0;
    CGFloat labelSpace = 5;
    UIView *backGView = nil;
    
    for (int i = 0; i < dataArray.count; i++) {
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        label.text = dataArray[i];
        label.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
        label.font = [UIFont boldSystemFontOfSize:10];
        
        if (i == 0 || i == 12 || i == 43 || i == 50 || i == 52 || i == 64 || i == 123) {
            radius = radius + labelMaxWidth + labelSpace;
            labelMaxWidth = 0;
            
            backGView = [[UIView alloc] init];
            backGView.bounds = CGRectMake(0.f, 0.f, self.view.frame.size.height, self.view.frame.size.height);
            backGView.center = CGPointMake(self.view.frame.size.width / 2, self.view.frame.size.height / 2);
            [self.view addSubview:backGView];
            [self.backGViewsArray addObject:backGView];
        }
        [backGView addSubview:label];
        
        CGFloat degrees = 0;
        int index = i;
        if (i < 12) {
            degrees = 360.f / 12.f;
        } else if (i < 43) {
            index = i - 12;
            degrees = 360.f / 31.f;
        } else if (i < 50) {
            index = i - 43;
            degrees = 360.f / 7.f;
        } else if (i < 52) {
            index = i - 50;
            degrees = 360.f / 60.f;
        } else if (i < 64) {
            index = i - 52;
            degrees = 360.f / 12.f;
        } else if (i < 123) {
            index = i - 64;
            degrees = 360.f / 60.f;
        } else {
            index = i - 123;
            degrees = 360.f / 60.f;
        }
        
        CGFloat x = cos(((index * degrees) / 180.0) * M_PI) * radius;
        CGFloat y = sin(((index * degrees) / 180.0) * M_PI) * radius;
        
        //确定位置
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(maxWidth, kHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:10]} context:nil].size;
        if (size.width > labelMaxWidth) {
            labelMaxWidth = size.width;
        }
        label.bounds = CGRectMake(0.f, 0.f, size.width, kHeight);
        label.center = CGPointMake(centerPoint.x + x, centerPoint.y - y);
        //旋转
        label.layer.anchorPoint = CGPointMake(0, 0.5);
        label.transform = CGAffineTransformMakeRotation(((360 - index * degrees) / 180.0) * M_PI);
        
        [self.labelsArray addObject:label];
    }
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
