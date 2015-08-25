//
//  BtnViewController.h
//  TongDaoShow
//
//  Created by bin jin on 5/12/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "TransferBean.h"

typedef void (^AddBtnBlock)(TransferBean* bean);

@interface BtnViewController : UIViewController

@property (nonatomic, copy) AddBtnBlock addBtnBlock;

@end
