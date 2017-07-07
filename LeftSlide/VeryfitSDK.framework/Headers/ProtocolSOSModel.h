//
//  ProtocolSOSModel.h
//  AijuVeryFit
//
//  Created by aiju_huangjing1 on 16/8/9.
//  Copyright © 2016年 morris. All rights reserved.
//

#import "JKDBModel.h"

@interface ProtocolSOSModel : JKDBModel
@property (nonatomic,copy) NSString *smart_device_id;
@property (nonatomic,assign) BOOL is_open;
@end
