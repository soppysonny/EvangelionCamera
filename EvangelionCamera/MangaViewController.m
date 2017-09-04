//
//  MangaViewController.m
//  EvangelionCamera
//
//  Created by zhang ming on 2017/9/4.
//  Copyright © 2017年 soppysonny. All rights reserved.
//

#import "MangaViewController.h"

@interface MangaViewController ()

@end

@implementation MangaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = RGBA(239, 239, 246, 1);
    UIView* line_1 = [[UIView alloc] initWithFrame:CGRectMake(SCREENWIDTH*0.5, 0, 1, SCREENHEIGHT)];
    UIView* line_2 = [[UIView alloc] initWithFrame:CGRectMake(0, SCREENHEIGHT*0.5, SCREENWIDTH, 1)];
    line_1.backgroundColor = [UIColor blackColor];
    line_2.backgroundColor = [UIColor blackColor];
    [self.view addSubview:line_1];
    [self.view addSubview:line_2];
//    CGRectGetMaxX(<#CGRect rect#>)
    CGRectEdge edge;
    
}
/*
 漫画制作
 2*2...
 可拖拽/相邻
 */


@end
