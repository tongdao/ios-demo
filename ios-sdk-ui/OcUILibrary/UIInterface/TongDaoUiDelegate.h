//
//  TongDaoUiDelegate.h
//  TongdaoUILibrary
//
//  Created by bin jin on 11/17/14.
//  Copyright (c) 2014 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TongDaoUiDelegate <NSObject>

@optional

/**
 *
 *brief 调用reloadPromotionsData:(NSMutableArray*)函数成功的回调
 *@param NSMutableArray<PromotionBean*> data 开发者从同道平台获得的相应数据
 *@return
 */
-(void)reloadPromotionsData:(NSMutableArray *) data;

/**
 *
 *brief 调用locationView:(int)函数成功的回调
 *@param int 根据promotionlist 导航到相应的UIView
 *@return
 */
-(void)locationView:(NSInteger) index;

@end



