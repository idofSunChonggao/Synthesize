//
//  WithParamVC.h
//  SDKTestDemoVery
//
//  Created by aiju_huangjing1 on 16/8/17.
//  Copyright © 2016年 aiju_huangjing1. All rights reserved.
//
#import <UIKit/UIKit.h>

@interface WithParamVC : UIViewController
@property (weak, nonatomic) IBOutlet UITextField *theTextField;
@property (weak, nonatomic) IBOutlet UIButton *theFuncBtn;
- (IBAction)func_cliclk_with_param:(id)sender;
@property (weak, nonatomic) IBOutlet UITextView *theTextView;
@property (weak, nonatomic) IBOutlet UILabel *switchLabel;
@property (weak, nonatomic) IBOutlet UISwitch *switchB;
- (IBAction)switch_change_click:(id)sender;


@property (nonatomic,assign) NSInteger type;
@end
