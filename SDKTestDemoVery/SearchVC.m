//
//  SearchVC.m
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/2/22.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//
#import "SearchVC.h"
#import "ScanVC.h"
#import "SharePeripheral.h"

@implementation SearchVC
- (void)viewDidLoad
{
     [super viewDidLoad];
     [self performSelector:@selector(didScanDevice) withObject:nil afterDelay:5.0f];
    }
- (void)didScanDevice
{
    [[SharePeripheral sharePeripheral]setCallBackDataBack:^(NSMutableArray *perArray) {
        AppDelegate *dele = [UIApplication sharedApplication].delegate;
        UIStoryboard *story = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ScanVC *vc = [story instantiateViewControllerWithIdentifier:@"scan_vc"];
        [dele.window setRootViewController:vc];
    }];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
