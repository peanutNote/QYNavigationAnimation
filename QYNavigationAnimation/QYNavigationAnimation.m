//
//  QYNavigationAnimation.m
//  BlueRhino
//
//  Created by 千叶 on 15/3/9.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import "QYNavigationAnimation.h"

#import "UIViewExt.h"


#define kScreenWidth  [UIScreen mainScreen].bounds.size.width
#define kScreenHeight [UIScreen mainScreen].bounds.size.height

@interface QYNavigationAnimation ()
// 背景视图
@property (strong, nonatomic) UIView *backgroundView;

// 截图视图
@property (strong, nonatomic) UIImageView *backImageView;

// 模糊视图
@property (strong, nonatomic) UIView *alphaView;

@end

@implementation QYNavigationAnimation
{
    BOOL _isUpDownPush;
    BOOL _isLeftRightPush;
    BOOL _isOtherPush;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - 确定推送方式
- (void)checkPushWay
{
    if (_QYNavigationAnimationModel == QYNavigationUpPush || _QYNavigationAnimationModel == QYNavigationDownPush) {
        _isUpDownPush = YES;
        _isLeftRightPush = NO;
        _isOtherPush = NO;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftPush || _QYNavigationAnimationModel == QYNavigationRightPush) {
        _isLeftRightPush = YES;
        _isUpDownPush = NO;
        _isOtherPush = NO;
    }else {
        _isOtherPush = YES;
        _isUpDownPush = NO;
        _isLeftRightPush = NO;
    }
}

#pragma mark - 重写导航控制器的push与pop方法
// push方法
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    [self checkPushWay];
    
    if (self.viewControllers.count == 0) {
        [super pushViewController:viewController animated:NO];
        return;
    }
    // 创建动画视图
    [self setPushAnimationView];
    
    // 配置导航栏效果
    if (_isUpDownPush) {
        [self moveViewPushWithX:0.0 Y:kScreenHeight];
    }else if (_isLeftRightPush){
        [self moveViewPushWithX:kScreenWidth Y:0.0];
    }else {
        [self moveViewPushWithX:kScreenWidth Y:kScreenHeight];
    }
    
    // 快速切换视图
    [super pushViewController:viewController animated:NO];
    
    // 启动动画
    [UIView animateWithDuration:.35 animations:^{
        [self moveViewPushWithX:0.0 Y:0.0];
    } completion:^(BOOL finished) {
        // 恢复设置
        _backImageView.transform = CGAffineTransformIdentity;
        [_backImageView removeFromSuperview];
        [_alphaView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        _backImageView = nil;
    }];
}

// 创建push时的动画视图
- (void)setPushAnimationView
{
    // 获取当前设备截图
    UIImage *captureImage = [self capture];
    
    // 视图的大小
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, version >= 7.0 ? kScreenHeight : kScreenHeight - 20);
    
    // 创建背景视图
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    
    // 将背景视图添加到被截图视图之后
    // 获取需要截图的视图
    UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    [captureView.superview insertSubview:_backgroundView belowSubview:captureView];
    
    // 创建截图视图
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    _backImageView.left = 0;
    // 设置图片并添加到被截图视图的后面
    _backImageView.image = captureImage;
    [captureView.superview insertSubview:_backImageView belowSubview:captureView];
    
    // 创建模糊视图
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc] initWithFrame:frame];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = .1;
    }
    [captureView.superview insertSubview:_alphaView belowSubview:captureView];
}

// pop方法
- (UIViewController *)popViewControllerAnimated:(BOOL)animated
{
    // 创建动画视图
    [self setPopAnimationView];
    
    // 把被截图视图移动到屏幕的右边，设置透明度和缩放
    [self moveViewPopWithX:0 Y:0];
    
    // 执行无动画导航
    UIViewController *viewCtrl = [super popViewControllerAnimated:NO];
    
    // 执行动画
    [UIView animateWithDuration:.35 animations:^{
        if (_isUpDownPush) {
            [self moveViewPopWithX:0.0 Y:kScreenHeight];
        }else if (_isLeftRightPush){
            [self moveViewPopWithX:kScreenWidth Y:0.0];
        }else {
            [self moveViewPopWithX:kScreenWidth Y:kScreenHeight];
        }
    } completion:^(BOOL finished) {
        // 恢复设置
        UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
        captureView.transform = CGAffineTransformIdentity;
        [_backImageView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_alphaView removeFromSuperview];
        _backImageView = nil;
    }];
    
    return viewCtrl;
}

// 退回到住控制器
- (NSArray *)popToRootViewControllerAnimated:(BOOL)animated
{
    // 创建动画视图
    [self setPopAnimationView];
    
    // 把被截图视图移动到屏幕的右边，设置透明度和缩放
    [self moveViewPopWithX:0 Y:0];
    
    // 执行无动画导航
    NSArray *viewCtrls = [super popToRootViewControllerAnimated:NO];
    
    // 执行动画
    [UIView animateWithDuration:.35 animations:^{
        if (_QYNavigationAnimationModel == QYNavigationUpPush || _QYNavigationAnimationModel == QYNavigationDownPush) {
            [self moveViewPopWithX:kScreenHeight Y:0];
        } else {
            [self moveViewPopWithX:kScreenWidth Y:0];
        }
    } completion:^(BOOL finished) {
        // 恢复设置
        UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
        captureView.transform = CGAffineTransformIdentity;
        [_backImageView removeFromSuperview];
        [_backgroundView removeFromSuperview];
        [_alphaView removeFromSuperview];
        _backImageView = nil;
    }];
    return viewCtrls;
}
// 创建POP时候动画的视图
- (void)setPopAnimationView
{
    // 获取当前设备截图
    UIImage *captureImage = [self capture];
    
    // 获取视图的大小
    float version = [[UIDevice currentDevice].systemVersion floatValue];
    CGRect frame = CGRectMake(0, 0, kScreenWidth, version >= 7.0 ? kScreenHeight : kScreenHeight - 20);
    
    // 创建背景视图
    if (_backgroundView == nil) {
        _backgroundView = [[UIView alloc] initWithFrame:frame];
        _backgroundView.backgroundColor = [UIColor blackColor];
    }
    
    // 将背景视图添加到被截图视图之后
    // 获取需要截图的视图
    UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    [captureView.superview insertSubview:_backgroundView belowSubview:captureView];
    
    // 创建模糊视图
    if (_alphaView == nil) {
        _alphaView = [[UIView alloc] initWithFrame:frame];
        _alphaView.backgroundColor = [UIColor blackColor];
        _alphaView.alpha = .1;
    }
    [captureView.superview insertSubview:_alphaView aboveSubview:captureView];
    
    // 创建截图视图
    if (_backImageView == nil) {
        _backImageView = [[UIImageView alloc] initWithFrame:frame];
    }
    _backImageView.left = 0;
    // 设置图片并添加到被截图视图的后面
    _backImageView.image = captureImage;
    [captureView.superview insertSubview:_backImageView aboveSubview:_alphaView];
}


// 获取当前界面的截图
- (UIImage *)capture
{
    // 获取需要截图的视图
    UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    if (captureView == nil) {
        return nil;
    }
    // 开始截图
    UIGraphicsBeginImageContextWithOptions(captureView.bounds.size, captureView.opaque, 0);
    
    [captureView.layer renderInContext:UIGraphicsGetCurrentContext()];
    // 获取截图
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭截图
    UIGraphicsEndImageContext();
    return image;
}

#pragma mark - 导航栏效果设置
- (void)moveViewPushWithX:(float)x Y:(float)y
{
    CGFloat lenghtX = 0.0f;
    CGFloat lenghtY = 0.0f;
    float alpha = 0.0f;
    float scale = 0.0f;
    if (_isUpDownPush) {
        lenghtY = kScreenHeight;
        y = MIN(y, lenghtY);
        y = MAX(y, 0);
        scale = (y / lenghtY) * .1 + .9;
        alpha = .5 - (y / lenghtY) * .5;
    }else if (_isLeftRightPush){
        lenghtX = kScreenWidth;
        x = MIN(x, lenghtX);
        x = MAX(x, 0);
        scale = (x / lenghtX) * .1 + .9;
        alpha = .5 - (x / lenghtX) * .5;
    }else {
        lenghtX = kScreenWidth;
        x = MIN(x, lenghtX);
        x = MAX(x, 0);
        scale = (x / lenghtX) * .1 + .9;
        alpha = .5 - (x / lenghtX) * .5;
    }
    
    // 定以视图缩放比例 0.9 <= scale <= 1
    _backImageView.transform = CGAffineTransformMakeScale(scale, scale);
    
    // 定义模糊视图的透明图 alpha区间[0,0.5]
    _alphaView.alpha = alpha;
    
    // 获取需要截图的视图
    UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    if (_QYNavigationAnimationModel == QYNavigationDownPush) {
        captureView.bottom = kScreenHeight - y;
    }else if (_QYNavigationAnimationModel == QYNavigationUpPush) {
        captureView.top = y;
    }else if (_QYNavigationAnimationModel == QYNavigationRightPush) {
        captureView.right = kScreenWidth - x;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftPush){
        captureView.left = x;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftUpPush){
        captureView.top = y;
        captureView.left = x;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftDownPush) {
        captureView.bottom = kScreenHeight - y;
        captureView.left = x;
    }else if (_QYNavigationAnimationModel == QYNavigationRightUpPush) {
        captureView.top = y;
        captureView.right = kScreenWidth - x;
    }else if (_QYNavigationAnimationModel == QYNavigationRightDownPush) {
        captureView.bottom = kScreenHeight - y;
        captureView.right = kScreenWidth - x;
    }
}

- (void)moveViewPopWithX:(float)x Y:(float)y
{
    CGFloat lenghtX = 0.0f;
    CGFloat lenghtY = 0.0f;
    float alpha = 0.0f;
    float scale = 0.0f;
    if (_isUpDownPush) {
        lenghtY = kScreenHeight;
        y = MIN(y, lenghtY);
        y = MAX(y, 0);
        scale = (y / lenghtY) * .1 + .9;
        alpha = .5 - (y / lenghtY) * .5;
    }else if (_isLeftRightPush){
        lenghtX = kScreenWidth;
        x = MIN(x, lenghtX);
        x = MAX(x, 0);
        scale = (x / lenghtX) * .1 + .9;
        alpha = .5 - (x / lenghtX) * .5;
    }else {
        lenghtX = kScreenWidth;
        x = MIN(x, lenghtX);
        x = MAX(x, 0);
        scale = (x / lenghtX) * .1 + .9;
        alpha = .5 - (x / lenghtX) * .5;
    }
    
    // 定义视图的缩放比例
    UIView *captureView = self.tabBarController == nil ? self.view : self.tabBarController.view;
    captureView.transform = CGAffineTransformMakeScale(scale, scale);
    
    // 定义遮罩视图的透明度
    _alphaView.alpha = alpha;
    
    if (_QYNavigationAnimationModel == QYNavigationUpPush) {
        _backImageView.top = y;
    }else if (_QYNavigationAnimationModel == QYNavigationDownPush) {
        _backImageView.bottom = kScreenHeight - y;
    }else if (_QYNavigationAnimationModel == QYNavigationRightPush){
        _backImageView.right = kScreenWidth - x;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftPush){
        _backImageView.left = x;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftUpPush){
        _backImageView.top = y;
        _backImageView.left = x;
    }else if (_QYNavigationAnimationModel == QYNavigationLeftDownPush) {
        _backImageView.bottom = kScreenHeight - y;
        _backImageView.left = x;
    }else if (_QYNavigationAnimationModel == QYNavigationRightUpPush) {
        _backImageView.top = y;
        _backImageView.right = kScreenWidth - x;
    }else if (_QYNavigationAnimationModel == QYNavigationRightDownPush) {
        _backImageView.bottom = kScreenHeight - y;
        _backImageView.right = kScreenWidth - x;
    }
}
@end
