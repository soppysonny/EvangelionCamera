//
//  ZMImageEditView.m
//  EvangelionCamera
//
//  Created by soppysonny on 15/10/7.
//  Copyright © 2015年 soppysonny. All rights reserved.
//lable旋转手势、屏幕方向旋转

#import "ZMImageEditView.h"
#define SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define SCREENHEIGHT [UIScreen mainScreen].bounds.size.height
@implementation ZMImageEditView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (UIImageView *)imageView{
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
    }return _imageView;
}

- (UILabel *)titleLable{
    if (!_titleLable) {
        _titleLable = [[UILabel alloc]initWithFrame:CGRectMake(0, SCREENHEIGHT - 50, SCREENWIDTH*0.8, 150)];
        _titleLable.numberOfLines = 0;
        _titleLable.font = [UIFont fontWithName:@"MatisseVPro-UB" size:30];
        _titleLable.text = @"零号機、参上";
    }return _titleLable;
}

-(UIButton *)cancelButton{
    if (!_cancelButton) {
        _cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _cancelButton.frame = CGRectMake(10, 20, 70, 40);
        _cancelButton.titleLabel.font = [UIFont fontWithName:@"MatisseVPro-UB" size:18];
        [_cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        _cancelButton.titleLabel.numberOfLines = 0;
        [_cancelButton addTarget:self action:@selector(removeEditView) forControlEvents:UIControlEventTouchUpInside];
    }return _cancelButton;
}



- (void)removeEditView{
    [UIView animateWithDuration:0.4 animations:^{
        self.transform = CGAffineTransformMakeTranslation(0, SCREENHEIGHT);
    }];

    //[self removeFromSuperview];
}

- (UIButton *)saveButton{
    if (!_saveButton) {
        _saveButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _saveButton.frame = CGRectMake(SCREENWIDTH - 80, 20, 70, 40);
        _saveButton.titleLabel.font = [UIFont fontWithName:@"MatisseVPro-UB" size:18];
        [_saveButton setTitle:@"保存" forState:UIControlStateNormal];
        _saveButton.titleLabel.numberOfLines = 0;
        [_saveButton addTarget:self action:@selector(saveImg) forControlEvents:UIControlEventTouchUpInside];
    }return _saveButton;
}

- (void)saveImg{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, 0.0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    [self.saveButton removeFromSuperview];
    [self.cancelButton removeFromSuperview];
    [self.setTitle removeFromSuperview];
    
    [self.layer renderInContext:ctx];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
    [self removeEditView];
}

- (UIButton *)setTitle{
    if (!_setTitle) {
        _setTitle = [UIButton buttonWithType:UIButtonTypeRoundedRect];
        _setTitle.frame = CGRectMake(SCREENWIDTH*0.5 - 50, 20, 100, 40);
        _setTitle.titleLabel.font = [UIFont fontWithName:@"MatisseVPro-UB" size:18];
        [_setTitle setTitle:@"設置標題" forState:UIControlStateNormal];
        _setTitle.titleLabel.numberOfLines = 0;
        [_setTitle addTarget:self action:@selector(popTextfield) forControlEvents:UIControlEventTouchUpInside];
    }return _setTitle;
}



-(void)popTextfield{
    _tf = [[UITextField alloc]initWithFrame:CGRectMake(0, 70, SCREENWIDTH*0.8, 50)];
    _tf.placeholder = @"修改標題";
    _tf.backgroundColor = [UIColor whiteColor];
    _tf.font = self.titleLable.font;
    
    CGFloat x = SCREENWIDTH*0.8;
    CGFloat y= 70;
    CGFloat height = _tf.frame.size.height;
    _confirm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    _confirm.frame =CGRectMake(x, y, SCREENWIDTH*0.2, height);
    [_confirm setTitle:@"確定" forState:UIControlStateNormal];
    _confirm.titleLabel.font = [UIFont fontWithName:@"MatisseVPro-UB" size:26];
    _confirm.titleLabel.numberOfLines = 0;
    _confirm.titleLabel.textColor = [UIColor blackColor];
    [_confirm addTarget:self action:@selector(tfEndEditing) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_confirm];
    
    [self.titleLable removeFromSuperview];
    [self addSubview:_tf];
    
}

- (void)tfEndEditing{
    self.titleLable.text = _tf.text;
    [_tf endEditing:YES];
    [self addSubview:self.titleLable];
    [_tf removeFromSuperview];
    [_confirm removeFromSuperview];
}



-(instancetype)initWithImage:(UIImage *)selectedImage{
    self = [super init];
    [self setFrame:CGRectMake(0, 0,SCREENWIDTH , SCREENHEIGHT)];
    self.backgroundColor = [UIColor whiteColor];
    CGFloat i = SCREENWIDTH / SCREENHEIGHT;
    CGFloat j = selectedImage.size.width / selectedImage.size.height;
    if (i > j) {
    self.imageView.frame = CGRectMake((SCREENWIDTH-SCREENWIDTH*j)*0.5 , 0, SCREENHEIGHT*j, SCREENHEIGHT);
    }else if (i < j){
//        if (j > 1) {
//            NSLog(@"rottate");
//            ///Users/soppysonny/Desktop/EvangelionCamera/EvangelionCamera/ZMImageEditView.m:66:72: Implicit conversion from enumeration type 'enum UIDeviceOrientation' to different enumeration type 'UIInterfaceOrientation' (aka 'enum UIInterfaceOrientation')
//            [[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationLandscapeRight animated:YES];
//            self.imageView.frame = CGRectMake((SCREENWIDTH-selectedImage.size.height)*0.5, 0, selectedImage.size.height, selectedImage.size.width);
//        }else{
            NSLog(@"norotate%lf",(SCREENHEIGHT - SCREENWIDTH/j)*0.5);
            self.imageView.frame = CGRectMake(0, (SCREENHEIGHT - SCREENWIDTH/j)*0.5, SCREENWIDTH, SCREENWIDTH/j);
      //  }
    }else if(i == j){
        self.imageView.frame = CGRectMake(0, 0, SCREENWIDTH, SCREENHEIGHT);
    }

    self.imageView.contentMode = UIViewContentModeScaleToFill;
    self.imageView.image = selectedImage;
    [self addSubview:self.imageView];
    [self addSubview:self.titleLable];
    [self addSubview:self.cancelButton];
    [self addSubview:self.saveButton];
    [self addSubview:self.setTitle];
    //缩放
    UIPinchGestureRecognizer* pincher = [[UIPinchGestureRecognizer alloc]initWithTarget:self action:@selector(pinchAction:)];
    pincher.delegate = self;
    [self.imageView addGestureRecognizer:pincher];
    //拖拽
    UIPanGestureRecognizer* panner = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panAction:)];
    panner.delegate = self;
    [self.imageView addGestureRecognizer:panner];
    
    self.imageView.multipleTouchEnabled = YES;
    self.imageView.userInteractionEnabled = YES;
    
    self.titleLable.userInteractionEnabled = YES;
    
    UIPanGestureRecognizer* lablePanner = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(lablePanAction:)];
    lablePanner.delegate = self;
    [self.titleLable addGestureRecognizer:lablePanner];
    
    UIRotationGestureRecognizer *rotation = [[UIRotationGestureRecognizer alloc]initWithTarget:self action:@selector(lableRotateAction:)];
    rotation.delegate = self;
    [self.titleLable addGestureRecognizer:rotation];
    
    return self;
}



- (void)lableRotateAction:(UIGestureRecognizer *)recognizer{



}

- (void)lablePanAction:(UIPanGestureRecognizer *)recognizer{
    CGPoint translation = [recognizer translationInView:recognizer.view];
    recognizer.view.transform = CGAffineTransformTranslate(recognizer.view.transform, translation.x, translation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
}

- (void)pinchAction:(UIPinchGestureRecognizer *)recognizer{
    recognizer.view.transform = CGAffineTransformScale(recognizer.view.transform, recognizer.scale, recognizer.scale);
    recognizer.scale = 1.0;
}

- (void)panAction:(UIPanGestureRecognizer *)recognizer{
    CGPoint tranlation = [recognizer translationInView:recognizer.view];
    recognizer.view.transform =  CGAffineTransformTranslate(recognizer.view.transform, tranlation.x, tranlation.y);
    [recognizer setTranslation:CGPointZero inView:recognizer.view];
    
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer{
    return YES;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat centerX = self.bounds.size.width * 0.5;
    CGFloat centerY = self.bounds.size.height * 0.5;
    self.imageView.center = CGPointMake(centerX, centerY);
}

@end
