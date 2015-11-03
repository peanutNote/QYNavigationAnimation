//
//  ViewController.m
//  QYNavigationAnimation
//
//  Created by qianye on 15/11/2.
//  Copyright © 2015年 qianye. All rights reserved.
//

#import "ViewController.h"

#import "QYNavigationAnimation.h"

@interface ViewController ()

@end

@implementation ViewController
{
    UIViewController *_testViewController;
    QYNavigationAnimation *_qyNavigation;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor cyanColor];
    // Do any additional setup after loading the view, typically from a nib.
    _testViewController = [[UIViewController alloc] init];
    _testViewController.title = @"这事一个测试页面";
    _testViewController.view.backgroundColor = [UIColor redColor];
    _qyNavigation = (QYNavigationAnimation *)self.navigationController;
    _qyNavigation.navigationBar.translucent = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)upPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationUpPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)downPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationDownPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)leftPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationLeftPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)leftUpPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationLeftUpPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)leftDownPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationLeftDownPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)rightPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationRightPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)rightUpPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationRightUpPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}

- (IBAction)rightDownPush:(id)sender {
    _qyNavigation.QYNavigationAnimationModel = QYNavigationRightDownPush;
    [_qyNavigation pushViewController:_testViewController animated:NO];
}



@end
