//
//  QYNavigationAnimation.h
//  BlueRhino
//
//  Created by 千叶 on 15/3/9.
//  Copyright (c) 2015年 qianye. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, QYNavigationAnimationModel) {
    // 往上push
    QYNavigationUpPush,
    // 往左push
    QYNavigationLeftPush,
    // 往右push
    QYNavigationRightPush,
    // 往下push
    QYNavigationDownPush,
    // 往左上push
    QYNavigationLeftUpPush,
    // 往左下push
    QYNavigationLeftDownPush,
    // 往右上push
    QYNavigationRightUpPush,
    // 往右下push
    QYNavigationRightDownPush
};

@interface QYNavigationAnimation : UINavigationController

@property (assign, nonatomic) QYNavigationAnimationModel QYNavigationAnimationModel;

@end
