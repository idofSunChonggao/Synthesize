//
//  ScanVC.h
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/1/23.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface ScanVC : UIViewController<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *ScanButton;
@property (weak, nonatomic) IBOutlet UIButton *BindButton;
@property (weak, nonatomic) IBOutlet UILabel *Search;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *ActivityIndicator;
@property (strong, nonatomic) UINavigationController *mainNavigationController;
- (IBAction)ScanDevice:(id)sender;
- (IBAction)BindDevice:(id)sender;
@end
