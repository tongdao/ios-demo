//
//  TdInAppMessageFullView.h
//  TongDaoUILibrary
//
//  Created by bin jin on 15/8/12.
//  Copyright (c) 2015年 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "TongDaoUiCore.h"
@interface TdInAppMessageFullView : UIView
@property(nonatomic,assign)BOOL isClosed;
-(void)initComponentWithMessageBean:(TdMessageBean*)messageBean andTongDaoUI:(TongDaoUiCore*)tduicore;
@end
