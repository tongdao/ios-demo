//
//  TdInAppMessageView.h
//  TongdaoUILibrary
//
//  Created by bin jin on 5/25/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TongDaoUiCore.h"
#import <TongDaoSDK/TongDao.h>

@interface TdInAppMessageView : UIView
@property (nonatomic,assign) BOOL isClosed;

-(void)initComponent:(TdMessageBean*)bean andParentOfVc:(TongDaoUiCore*)tdUicore;

@end
