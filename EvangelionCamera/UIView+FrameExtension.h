//
//  UIView+FrameExtension.h
//  LiveVideo
//
//  Created by Meiyou2 on 16/6/17.
//  Copyright © 2016年 meiyou. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (FrameExtension)

//宽高位置大小
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGSize size;

//中心点的x与y
@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@end
