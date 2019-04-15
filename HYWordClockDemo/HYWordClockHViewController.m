//
//  HYWordClockHViewController.m
//  HYWordClockDemo
//
//  Created by axc on 2019/4/4.
//  Copyright © 2019 axc. All rights reserved.
//

#import "HYWordClockHViewController.h"

@interface HYWordClockHViewController ()

@property (nonatomic, strong) NSMutableArray *labelsArray;
@property (nonatomic, strong) dispatch_source_t timer;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *weekLabel;
@property (nonatomic, strong) UILabel *noonLabel;
@property (nonatomic, strong) UILabel *hourLabel;
@property (nonatomic, strong) UILabel *minuteLabel;
@property (nonatomic, strong) UILabel *secondLabel;

@end

@implementation HYWordClockHViewController

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
    
    if (self.dayLabel) {
        self.dayLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *dayLabel = [self.labelsArray objectAtIndex:12 + dayComponent.day - 1];
    dayLabel.textColor = [UIColor whiteColor];
    self.dayLabel = dayLabel;
    
    if (self.weekLabel) {
        self.weekLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *weekLabel = [self.labelsArray objectAtIndex:12 + 31 + ((weekComponent.weekday == 1) ? 7 : weekComponent.weekday - 1) - 1];
    weekLabel.textColor = [UIColor whiteColor];
    self.weekLabel = weekLabel;
    
    if (self.noonLabel) {
        self.noonLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *noonLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + ((hourComponent.hour > 12) ? 2 : 1) - 1];
    noonLabel.textColor = [UIColor whiteColor];
    self.noonLabel = noonLabel;
    
    if (self.hourLabel) {
        self.hourLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    UILabel *hourLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + 2 + ((hourComponent.hour > 12) ? (hourComponent.hour - 12) : hourComponent.hour) - 1];
    hourLabel.textColor = [UIColor whiteColor];
    self.hourLabel = hourLabel;
    
    if (self.minuteLabel) {
        self.minuteLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    if (minuteComponent.minute != 0) {
        UILabel *minuteLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + 2 + 12 + minuteComponent.minute - 1];
        minuteLabel.textColor = [UIColor whiteColor];
        self.minuteLabel = minuteLabel;
    }
    
    if (self.secondLabel) {
        self.secondLabel.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
    }
    if (secondComponent.second != 0) {
        UILabel *secondLabel = [self.labelsArray objectAtIndex:12 + 31 + 7 + 2 + 12 + 59 +  secondComponent.second - 1];
        secondLabel.textColor = [UIColor whiteColor];
        self.secondLabel = secondLabel;
    }
}

- (void)setupUI {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Word" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    CGFloat topViewSpace = 100.f;
    CGFloat bothViewSpace = 25.f;
    CGFloat bothSpace = 5.f;
    CGFloat topSpce = 5.f;
    CGFloat kHeight = 20.f;
    CGFloat maxWidth = 100.f;
    CGFloat font = 10.f;
    
    UILabel *lastLabel = nil;
    UILabel *nextLabel = nil;
    
    BOOL isNextLine = YES;
    
    for (int i = 0; i < dataArray.count; i++) {
        NSLog(@"第 %d 次执行",i);
        UILabel *label = [[UILabel alloc] init];
        label.tag = i;
        label.text = dataArray[i];
        label.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
        label.font = [UIFont boldSystemFontOfSize:font];
        [self.view addSubview:label];
        
        CGSize size = [label.text boundingRectWithSize:CGSizeMake(maxWidth, kHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont boldSystemFontOfSize:font]} context:nil].size;
        label.frame = CGRectMake((isNextLine ? bothViewSpace : (lastLabel.frame.origin.x + lastLabel.frame.size.width + bothSpace)), (nextLabel ? (nextLabel.frame.origin.y + nextLabel.frame.size.height + topSpce) :topViewSpace), size.width, kHeight);
        
        if ((label.frame.origin.x + label.frame.size.width) > (self.view.frame.size.width - bothViewSpace)) {
            isNextLine = YES;
            nextLabel = lastLabel;
            [label removeFromSuperview];
            i--;
            continue;
        } else {
            isNextLine = NO;
        }
        
        lastLabel = label;
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
