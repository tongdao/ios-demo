//
//  TdDataTool.h
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TransferBean.h"
#import "TransferRewardBean.h"

extern NSString *const DISPLAYED_CONTROLLER;
extern NSString *const Default_ImageName;

#define IPHONE4 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 960), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(750, 1334), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPHONE6_PLUS ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1242, 2208), [[UIScreen mainScreen] currentMode].size) : NO)

#define IPAD (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? YES : NO)

@interface DemoTdDataTool : NSObject

@property (nonatomic, retain) NSMutableArray *transferRewardBeanList;

+(DemoTdDataTool*)sharedManager;

+(NSBundle*)getBundle;

+(void)showErrorMessage:(NSString*)message;

-(void)putTempRewardInfo:(NSString*)sku andNum:(int)num;
-(NSDictionary*)getTempRewardInfo;
-(void)clearTempRewardInfo;

-(void)addNewBean:(TransferBean*)newTransferBean;
-(void)deleteBean:(int)index;
-(NSArray*)getAllBeans;

-(void)addNewRewardBean:(TransferRewardBean*)newTransferRewardBean;
-(void)deleteRewardBean:(int)index;
-(NSMutableArray*)getAllRewardBeans;

-(NSString*)getAppKey;

-(void)initialBtnDatas:(NSString*)btnJsonString;
-(void)initialRewardDatas:(NSString*)rewardJsonString;

-(NSString*)makeBtnsString;
-(NSString*)makeRewardsString:(NSArray*)rewards;

-(void)saveTempRewards:(NSArray*)rewards;
-(NSArray*)recoverTempRewards;
-(BOOL)isNumeric:(NSString*)str;

@end
