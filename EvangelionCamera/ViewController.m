//
//  ViewController.m
//  EvangelionCamera
//
//  Created by soppysonny on 15/10/6.
//  Copyright © 2015年 soppysonny. All rights reserved.
//
#import <Masonry.h>
#import "ViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <ImageIO/ImageIO.h>
#import <QuartzCore/QuartzCore.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "ZMImageEditView.h"
#import "MangaViewController.h"
#import <GoogleMobileAds/GoogleMobileAds.h>
#import "UMVideoAd.h"
#import <CoreTelephony/CTCarrier.h>
#import <CoreTelephony/CTTelephonyNetworkInfo.h>
#import <SVProgressHUD/SVProgressHUD.h>
#import "MangaToolCover.h"
typedef enum{
    isFrontCamera = 0,
    isBackCamera
} cameraType;

typedef enum{
    AutoFlash = 0,
    CloseFlash,
    OpenFlash
} flashModel;

@interface ViewController ()<GADBannerViewDelegate,
 AVCaptureAudioDataOutputSampleBufferDelegate, UIImagePickerControllerDelegate, UIAlertViewDelegate ,UINavigationBarDelegate, AVAudioRecorderDelegate>
{
    UIImage *_photo;
    BOOL _isFontCamera;
}
@property (weak, nonatomic) IBOutlet UIButton *cameraButton;
@property (weak, nonatomic) IBOutlet UIButton *button;
@property (weak, nonatomic) IBOutlet UIButton *makeMangaBt;
@property (strong, nonatomic)UIImagePickerController* imagelibpicker;
@property (strong, nonatomic) AVCaptureSession           *session;       // 捕获会话
@property (nonatomic, strong) AVCaptureStillImageOutput  *captureOutput; // 输出设备
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;  // 取景器
@property (nonatomic, strong) AVAudioRecorder *recorder;
@property (nonatomic, strong) NSTimer *levelTimer;
@property (nonatomic, assign) float lastFloat;
@property(nonatomic, strong) GADBannerView *bannerView;
@end


@implementation ViewController
- (void)addBannerViewToView:(UIView *)bannerView {
    bannerView.translatesAutoresizingMaskIntoConstraints = NO;
    [self.view addSubview:bannerView];
    [self.view addConstraints:@[
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeBottom
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.bottomLayoutGuide
                                                             attribute:NSLayoutAttributeTop
                                                            multiplier:1
                                                              constant:0],
                                [NSLayoutConstraint constraintWithItem:bannerView
                                                             attribute:NSLayoutAttributeCenterX
                                                             relatedBy:NSLayoutRelationEqual
                                                                toItem:self.view
                                                             attribute:NSLayoutAttributeCenterX
                                                            multiplier:1
                                                              constant:0],
                                 [NSLayoutConstraint constraintWithItem:bannerView attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:self.view attribute:NSLayoutAttributeWidth multiplier:1 constant:0]
                                ]];
}
- (IBAction)makeManga:(id)sender {
    MangaViewController* manga = [MangaViewController new];
    
    [self presentViewController:manga animated:YES completion:nil];
}

- (AVCaptureSession *)session
{
    if (_session == nil) {
        _session = [[AVCaptureSession alloc] init];
    }
    return _session;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.lastFloat = 0;
    [self.button addTarget:self action:@selector(readLibrary) forControlEvents:UIControlEventTouchUpInside];
    [self.cameraButton addTarget:self action:@selector(takePic) forControlEvents:UIControlEventTouchUpInside];
//    if (!self.recorder) {
//        [[AVAudioSession sharedInstance]
//         setCategory: AVAudioSessionCategoryPlayAndRecord error:nil];
//
//        /* 不需要保存录音文件 */
//        NSURL *url = [NSURL fileURLWithPath:@"/dev/null"];
//
//        NSDictionary *settings = [NSDictionary dictionaryWithObjectsAndKeys:
//                                  [NSNumber numberWithFloat: 44100.0], AVSampleRateKey,
//                                  [NSNumber numberWithInt: kAudioFormatAppleLossless], AVFormatIDKey,
//                                  [NSNumber numberWithInt: 2], AVNumberOfChannelsKey,
//                                  [NSNumber numberWithInt: AVAudioQualityMax], AVEncoderAudioQualityKey,
//                                  nil];
//        NSError *error;
//        self.recorder = [[AVAudioRecorder alloc] initWithURL:url settings:settings error:&error];
//        [self.recorder prepareToRecord];
//        self.recorder.meteringEnabled = YES;
//
//    }
    self.bannerView = [[GADBannerView alloc]
                       initWithAdSize:kGADAdSizeBanner];
    NSString* unitid;
#ifdef DEBUG
    unitid = @"ca-app-pub-3940256099942544/2934735716";
#else
    unitid = @"ca-app-pub-1709854646699078/8258850974";
#endif
    self.bannerView.adUnitID = unitid;// @"ca-app-pub-3940256099942544/2934735716";
    self.bannerView.rootViewController = self;
    [self addBannerViewToView:self.bannerView];
    [self.bannerView loadRequest:[GADRequest request]];
    self.bannerView.delegate = self;
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(showYoumi:) name:@"showYoumi" object:nil];
//    MangaToolCover* cover = [MangaToolCover new];
//    [self.view addSubview:cover];
//    [cover mas_makeConstraints:^(MASConstraintMaker* make){
//        make.edges.mas_equalTo(self.view);
//    }];
}

- (void)showYoumi:(NSNotification *)notification{
    if (notification.object == nil) {
        return;
    }
    NSUserDefaults * defaults = [NSUserDefaults standardUserDefaults];
    NSArray * allLanguages = [defaults objectForKey:@"AppleLanguages"];
    NSString * preferredLang = [allLanguages objectAtIndex:0];
    CTTelephonyNetworkInfo *info = [[CTTelephonyNetworkInfo alloc] init];
    CTCarrier *carrier = info.subscriberCellularProvider;
    NSString *countryCode = [carrier isoCountryCode];
    if ([countryCode isEqualToString:@"cn"] && [preferredLang containsString:@"zh"]) {
        [UMVideoAd videoPlay:self videoPlayFinishCallBackBlock:^(BOOL isFinishPlay){
            if (isFinishPlay) {
                NSLog(@"视频播放结束");
                UIImage* image = notification.object;
                UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存成功(∩_∩)" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){}];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                NSLog(@"中途退出");
                UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"保存失败 (ㄒoㄒ)" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction* action = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction*action){}];
                [alert addAction:action];
                [self presentViewController:alert animated:YES completion:nil];
            }
        } videoPlayConfigCallBackBlock:^(BOOL isLegal){
            //注意：  isLegal在（app有联网，并且注册的appkey后台审核通过）的情况下才返回yes, 否则都是返回no.
            NSString *message = @"";
            if (isLegal) {
                message = @"此次播放有效";
            }else{
                message = @"此次播放无效";
            }
            NSLog(@"是否有效：%@",message);
        }];
    }else{
        UIImage* image = notification.object;
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil);
        [SVProgressHUD showSuccessWithStatus:@"Image Saved"];
    }
  
}

- (void)levelTimerCallback:(NSTimer *)timer {
    [self.recorder updateMeters];
    
    float   level;                // The linear 0.0 .. 1.0 value we need.
    float   minDecibels = -80.0f; // Or use -60dB, which I measured in a silent room.
    float   decibels    = [self.recorder averagePowerForChannel:0];
    
    if (decibels < minDecibels)
    {
        level = 0.0f;
    }
    else if (decibels >= 0.0f)
    {
        level = 1.0f;
    }
    else
    {
        float   root            = 2.0f;
        float   minAmp          = powf(10.0f, 0.05f * minDecibels);
        float   inverseAmpRange = 1.0f / (1.0f - minAmp);
        float   amp             = powf(10.0f, 0.05f * decibels);
        float   adjAmp          = (amp - minAmp) * inverseAmpRange;
        
        level = powf(adjAmp, 1.0f / root);
    }
    float numToRecord = level*120;
    
    if (numToRecord - self.lastFloat> 30) {
        [self.imagelibpicker takePicture];
        [self.recorder stop];
        [self.levelTimer invalidate];
    }
    self.lastFloat = numToRecord;
    /* level 范围[0 ~ 1], 转为[0 ~120] 之间 */
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"%f", level*120);
    });
}

//'ALAuthorizationStatus' is deprecated: first deprecated in iOS 9.0 - Use PHAuthorizationStatus in the Photos framework instead
- (void)readLibrary{

    ALAuthorizationStatus status = [ALAssetsLibrary authorizationStatus];
    if (status == ALAuthorizationStatusRestricted||status ==ALAuthorizationStatusDenied) {
        UIAlertView * alert = [[UIAlertView alloc]initWithTitle:@"错误" message:@"无法打开相册，请在“设置-隐私-照片”中打开本应用访问相册权限" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
        [alert show];
    }else{
       
       _imagelibpicker = [[UIImagePickerController alloc]init];
        _imagelibpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        _imagelibpicker.delegate = self;///Users/soppysonny/Desktop/EvangelionCamera/EvangelionCamera/ViewController.m:67:33: Assigning to 'id<UINavigationControllerDelegate,UIImagePickerControllerDelegate> _Nullable' from incompatible type 'ViewController *const __strong'
        
//        _imagelibpicker.allowsEditing = YES;
        // imagelibpicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        [self presentViewController:_imagelibpicker animated:YES completion:^{
    
        }];
    }
}

- (void)takePic{
//    [self.recorder record];
//    self.levelTimer = [NSTimer scheduledTimerWithTimeInterval: 0.1 target: self selector: @selector(levelTimerCallback:) userInfo: nil repeats: YES];
    if (_imagelibpicker == nil) {
        _imagelibpicker = [[UIImagePickerController alloc]init];
        _imagelibpicker.delegate = self;
    }
    _imagelibpicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:_imagelibpicker animated:YES completion:^{}];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary<NSString *,id> *)editingInfo{
    
    ZMImageEditView* coverView = [[ZMImageEditView alloc]initWithImage:image];
    [self.view addSubview:coverView];
    NSUserDefaults* def = [NSUserDefaults standardUserDefaults];
    if (![def  objectForKey:@"usageDeff"]) {
        [def setObject:@"1" forKey:@"usageDeff"];
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"使用" message:@"照片支持缩小放大, 文字标题可拖动" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction* action = [UIAlertAction actionWithTitle:@"好" style:UIAlertActionStyleDefault handler:^(UIAlertAction* action){}];
        [alert addAction:action];
        [picker dismissViewControllerAnimated:YES completion:^{
            
        }];
        [self presentViewController:alert animated:YES completion:^{
       
        }];
        return;
    }
    [picker dismissViewControllerAnimated:YES completion:^{
    
    }];
}


#pragma mark - action
// 拍照
- (void)capture
{
    if (![self.session isRunning]) {
        [self getPhoto];
    }else{
        [_session stopRunning];
    }
}
// 切换摄像头
- (void)switchCamera:(UIButton *)sender
{
    [self.session stopRunning];
    [_previewLayer removeFromSuperlayer];
    sender.selected = !sender.selected;
    _isFontCamera = !_isFontCamera;
    [self setupCamera];
}
// 获取图片
- (void)getPhoto
{
    AVCaptureConnection *videoConnection = nil;
    for (AVCaptureConnection *connection in _captureOutput.connections) {
        for (AVCaptureInputPort *port in [connection inputPorts]) {
            if ([[port mediaType] isEqual:AVMediaTypeVideo] ) {
                videoConnection = connection;
                break;
            }
        }
        if (videoConnection) {
            break;
        }
    }
    [_captureOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler:^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         CFDictionaryRef exifAttachments = CMGetAttachment(imageSampleBuffer, kCGImagePropertyExifDictionary, nil);
         if (exifAttachments) {
             // Do something with the attachments.
         }
         // 获取图片数据
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *t_image = [[UIImage alloc] initWithData:imageData];
         _photo = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.5 orientation:UIImageOrientationRight];
         UIImageView *imageView = [[UIImageView alloc]initWithFrame:_previewLayer.frame];
         [_previewLayer removeFromSuperlayer];
         imageView.image = _photo;
         imageView.contentMode = UIViewContentModeScaleAspectFill;
         imageView.clipsToBounds = YES;
         [self.view addSubview:imageView];
     }];
}

// 切换闪光灯模式
- (void)switchFlashMode:(UIButton*)sender {
    Class captureDeviceClass = NSClassFromString(@"AVCaptureDevice");
    if (!captureDeviceClass) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有拍照功能" delegate:nil cancelButtonTitle:NSLocalizedString(@"Sure", nil) otherButtonTitles: nil];
        [alert show];
        return;
    }
    NSString *imgName = @"";
    AVCaptureDevice *device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    [device lockForConfiguration:nil];
    if ([device hasFlash]) {
        if (device.flashMode == AVCaptureFlashModeOff) {
            device.flashMode = AVCaptureFlashModeOn;
            imgName = @"";
        } else if (device.flashMode == AVCaptureFlashModeOn) {
            device.flashMode = AVCaptureFlashModeAuto;
            imgName = @"";
        } else if (device.flashMode == AVCaptureFlashModeAuto) {
            device.flashMode = AVCaptureFlashModeOff;
            imgName = @"";
        }
        if (sender) {
            [sender setImage:[UIImage imageNamed:imgName] forState:UIControlStateNormal];
        }
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示信息" message:@"您的设备没有闪光灯功能" delegate:nil cancelButtonTitle:@"ok" otherButtonTitles: nil];
        [alert show];
    }
    [device unlockForConfiguration];
}



// 初始化相机

- (void)setupCamera
{
    AVCaptureDevice *captureDevice = [self getVideoInputCamera:(_isFontCamera ? isFrontCamera : isBackCamera)];
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:captureDevice error:nil];
    if ([self.session canAddInput:deviceInput]){
        [_session addInput:deviceInput];
    }
    
    // 预览视图(取景器)
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    CALayer *preLayer = [[self view] layer];
    [preLayer setMasksToBounds:YES];
    [_previewLayer setFrame:CGRectMake(10, 100, 300, 300)];
    [preLayer insertSublayer:_previewLayer atIndex:0];
    [_session startRunning];
    
    // 创建一个输出设备,并将它添加到会话
    _captureOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys:AVVideoCodecJPEG,AVVideoCodecKey,nil];
    _captureOutput.outputSettings = outputSettings;
    [_session addOutput:_captureOutput];
}



#pragma mark VideoCapture
- (AVCaptureDevice *)getVideoInputCamera:(cameraType )cameraType
{
    //获取(后置/前置)摄像头设备
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in cameras){
        switch (cameraType) {
            case isFrontCamera:
                if (device.position == AVCaptureDevicePositionFront)
                    return device;
                break;
            case isBackCamera:
                if (device.position == AVCaptureDevicePositionBack)
                    return device;
                break;
            default:
                break;
        }
    }
    return [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
}


- (void)adViewDidReceiveAd:(GADBannerView *)bannerView{
    
}
- (void)adView:(GADBannerView *)bannerView didFailToReceiveAdWithError:(GADRequestError *)error{
    NSLog(@"%@",error);
}
@end
