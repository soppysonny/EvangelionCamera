//
//  ZMImageEditView.h
//  EvangelionCamera
//
//  Created by soppysonny on 15/10/7.
//  Copyright © 2015年 soppysonny. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZMImageEditView : UIView<UIGestureRecognizerDelegate, UITextFieldDelegate>
@property (strong, nonatomic)UISwipeGestureRecognizer* recognizer;

@property (strong, nonatomic)UILabel* titleLable;
@property (strong, nonatomic)UIImageView* imageView;

@property (strong, nonatomic)UIButton* cancelButton;
@property (strong, nonatomic)UIButton* saveButton;
@property (strong, nonatomic)UIButton* setTitle;
@property (strong, nonatomic)UIButton* confirm;
@property (strong, nonatomic)UITextField* tf;
- (instancetype)initWithImage: (UIImage *)selectedImage;


@end
