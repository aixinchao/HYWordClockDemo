//
//  HYWordClockViewController.m
//  HYWordClockDemo
//
//  Created by axc on 2019/4/3.
//  Copyright © 2019 axc. All rights reserved.
//

#import "HYWordClockViewController.h"
#import "SDAutoLayout.h"

@interface HYWordClockViewController ()

@end

@implementation HYWordClockViewController

- (void)dealloc {
    NSLog(@"dealloc_____%@",[self class]);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"字时钟";
    self.view.backgroundColor = [UIColor blackColor];
    
    [self setupUI];
//    [self performSelector:@selector(setupUI) withObject:nil afterDelay:0.0f inModes:@[NSRunLoopCommonModes]];
}

- (void)setupUI {
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"Word" ofType:@"plist"];
    NSArray *dataArray = [[NSArray alloc] initWithContentsOfFile:filePath];
    
    CGFloat topViewSpace = 100.f;
    CGFloat bothViewSpace = 25.f;
    CGFloat bothSpace = 5.f;
    CGFloat topSpce = 5.f;
    CGFloat height = 20.f;
    
    UILabel *lastLabel = nil;
    UILabel *nextLabel = nil;
    
    BOOL isNextLine = YES;
    
    for (int i = 0; i < dataArray.count; i++) {
//        NSLog(@"第 %d 次执行",i);
        UILabel *label = [[UILabel alloc] init];
        label.text = dataArray[i];
        label.textColor = [UIColor colorWithRed:64.f / 255.f green:64.f / 255.f blue:64.f / 255.f alpha:0.75];
        label.font = [UIFont boldSystemFontOfSize:12];
        label.backgroundColor = [UIColor orangeColor];
        [self.view addSubview:label];
        
        label.sd_layout
        .topSpaceToView((nextLabel ? nextLabel : self.view), (nextLabel ? topSpce : topViewSpace))
        .leftSpaceToView((isNextLine ? self.view : lastLabel), (isNextLine ? bothViewSpace : bothSpace))
        .heightIs(height);
        [label setSingleLineAutoResizeWithMaxWidth:100];
        
        [label updateLayout];
        
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
