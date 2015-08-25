//
//  LandingPageView.h
//  TongdaoUILibrary
//
//  Created by bin jin on 11/18/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <TongDaoSDK/TongDao.h>

@interface LandingPageView : UIView
@property (strong, nonatomic) UIImageView *landingPageImage;

-(void)initControllersWithPageBean:(PageBean*) pageBean;
-(void)setCenterPointWithParentView:(UIView*)parentView;

@end
