//
//  TransferRewardBean.h
//  TongDaoShow
//
//  Created by bin jin on 5/8/15.
//  Copyright (c) 2015 Tongdao. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TransferRewardBean : NSObject

@property (nonatomic, retain, readonly) NSData *picture;
@property (nonatomic, copy) NSString *rewardName;
@property (nonatomic, copy, readonly) NSString *rewardSku;
@property (nonatomic, assign) int num;

-(instancetype)initWithPicture:(NSData*)picture andRewardName:(NSString*)rewardName andRewardSku:(NSString*)rewardSku andNum:(int)num;

-(NSMutableDictionary*)writeToJson;
-(void)readFromJson:(NSDictionary*)dictData;

@end
