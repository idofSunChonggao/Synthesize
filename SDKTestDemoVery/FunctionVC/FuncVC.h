//
//  FuncVC.h
//  Veryfit Test
//
//  Created by 孙崇高 on 2017/1/23.
//  Copyright © 2017年 aiju_huangjing1. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface FuncVC : UIViewController<UITableViewDelegate,UITableViewDataSource>

- (IBAction)toScanVC:(id)sender;
- (IBAction)unBindDevice:(id)sender;
@property (weak, nonatomic) IBOutlet UILabel *connectLabel;
@property (weak, nonatomic) IBOutlet UILabel *macdressLabel;
@property (weak, nonatomic) IBOutlet UIButton *toScanVCButton;
@property (weak, nonatomic) IBOutlet UITableView *myTableView;
- (void)viewWillDisappear:(BOOL)animated;
- (void)viewWillAppear:(BOOL)animated;
@end
