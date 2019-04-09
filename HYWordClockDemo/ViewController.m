//
//  ViewController.m
//  HYWordClockDemo
//
//  Created by axc on 2019/4/3.
//  Copyright © 2019 axc. All rights reserved.
//

#import "ViewController.h"
#import "HYWordClockViewController.h"
#import "HYWordClockHViewController.h"
#import "HYWordClockYViewController.h"

@interface ViewController ()

@property (nonatomic, strong) UIButton *button;
@property (nonatomic, strong) UIButton *buttonTwo;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.title = @"HY";
    
    [self setupUI];
}

- (void)setupUI {
    [self.view addSubview:self.button];
    [self.view addSubview:self.buttonTwo];
}

- (void)buttonClick:(UIButton *)sender {
    //SD布局 耗性能
//    HYWordClockViewController *wordClockVC = [[HYWordClockViewController alloc] init];
//    [self.navigationController pushViewController:wordClockVC animated:YES];
    //frame布局
    HYWordClockYViewController *wordClockVC = [[HYWordClockYViewController alloc] init];
    [self.navigationController pushViewController:wordClockVC animated:YES];
    
}

- (void)buttonTwoClick:(UIButton *)sender {
    //frame布局
    HYWordClockHViewController *wordClockVC = [[HYWordClockHViewController alloc] init];
    [self.navigationController pushViewController:wordClockVC animated:YES];
    
}

#pragma mark -- Property
- (UIButton *)button {
    if (!_button) {
        _button = [UIButton buttonWithType:UIButtonTypeCustom];
        _button.bounds = CGRectMake(0.f, 0.f, 150.f, 45.f);
        _button.center = CGPointMake(self.view.center.x, self.view.center.y - 50);
        _button.layer.cornerRadius = 6.f;
        _button.layer.borderWidth = 0.5;
        _button.layer.borderColor = [[UIColor orangeColor] CGColor];
        [_button setTitle:@"Y" forState:UIControlStateNormal];
        [_button setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_button addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _button;
}

- (UIButton *)buttonTwo {
    if (!_buttonTwo) {
        _buttonTwo = [UIButton buttonWithType:UIButtonTypeCustom];
        _buttonTwo.bounds = CGRectMake(0.f, 0.f, 150.f, 45.f);
        _buttonTwo.center = CGPointMake(self.view.center.x, self.view.center.y + 50);
        _buttonTwo.layer.cornerRadius = 6.f;
        _buttonTwo.layer.borderWidth = 0.5;
        _buttonTwo.layer.borderColor = [[UIColor orangeColor] CGColor];
        [_buttonTwo setTitle:@"H" forState:UIControlStateNormal];
        [_buttonTwo setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
        [_buttonTwo addTarget:self action:@selector(buttonTwoClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _buttonTwo;
}

@end
