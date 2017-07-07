//
//  BarcodeViewController.h
//  枣矿集团应急救援综合平台
//
//  Created by Air on 2017/4/11.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@interface BarcodeViewController : UIViewController
@property(nonatomic, strong) AVCaptureSession *session;
@property (nonatomic, weak) UIImageView *scanLineImageView;
@end
