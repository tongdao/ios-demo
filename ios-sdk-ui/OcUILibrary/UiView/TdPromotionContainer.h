//
//  PromotionContainer.h
//  TongdaoUILibrary
//
//  Created by bin jin on 11/20/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RewardsBean;

@interface TdPromotionContainer : UIView


- (void)closeUiAction;

@property (strong, nonatomic) UIView      *closeUiView;
@property (strong, nonatomic)  UIImageView *closeUiImage;
@property (nonatomic) UIView               *backGroundView;

-(void) initControllersWithParentView:(UIView*) parentView;

-(void) downloadPageWithPageId:(int) pageId;

-(void) reloadDataAction;


@end
