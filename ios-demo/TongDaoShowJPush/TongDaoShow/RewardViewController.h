//
//  RewardViewController.h
//  TongDaoShow
//
//  Created by bin jin on 5/10/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BaseViewController.h"

@class  TransferRewardBean;

typedef void(^AddRewardBlock)(TransferRewardBean* data);

typedef void (^addRewardView)();

@interface RewardViewController : BaseViewController

@property (nonatomic, copy) AddRewardBlock addRewardBlock;

@end
