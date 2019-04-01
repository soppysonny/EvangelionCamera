//
//  MangaViewController.m
//  EvangelionCamera
//
//  Created by zhang ming on 2017/9/4.
//  Copyright © 2017年 soppysonny. All rights reserved.
//

#import "MangaViewController.h"
#import <Masonry/Masonry.h>
@interface MangaViewController ()
@property (nonatomic, strong)UIView* contentView;
@property (nonatomic, strong)UIButton* closeButton;
@end

@implementation MangaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUpUI];
    
}

- (void)setUpUI{
    self.view.backgroundColor = RGBA(239, 239, 246, 1);
    self.contentView = [UIView new];
    self.contentView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.contentView];
    [self.contentView mas_makeConstraints:^(MASConstraintMaker *make){
        make.edges.mas_equalTo(UIEdgeInsetsMake(isIPhoneX?54:40, 20, isIPhoneX?94:60, 20));
    }];
    UIButton* closeButton = [[UIButton alloc]init];
    [self.view addSubview:closeButton];
    [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
    [closeButton mas_makeConstraints:^(MASConstraintMaker* maker){
        maker.height.mas_equalTo(30);
        maker.bottom.mas_equalTo(self.view).with.offset(-10);
        maker.width.mas_equalTo(60);
        maker.left.mas_equalTo(self.view).with.offset(20);
    }];
    [closeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [closeButton setBackgroundColor:[UIColor blackColor]];
    closeButton.layer.cornerRadius = 15;
    [closeButton addTarget:self action:@selector(closeAlert) forControlEvents:UIControlEventTouchUpInside];
}

- (void)closeAlert{
    UIAlertController* alert =  [UIAlertController alertControllerWithTitle:@"提示" message:@"是否关闭?" preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){
        [self dismissViewControllerAnimated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction* action){
        
    }]];
    [self presentViewController:alert animated:YES completion:nil];
    
}

/*
 漫画制作
 2*2...
 可拖拽/相邻
 */


@end
